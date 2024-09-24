proc import file = 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\frmgham_period1.csv'
dbms=csv
out=fram;
run;
/*categorical total cholesterol*/
data framchol;
set fram;
if totchol LT 200 then cholcat = '1'; /*normal*/
if totchol GE 200 and cholcat LE 239 then cholcat = '2'; /*borderline high*/
if totchol GE 240 then cholcat = '3'; /*high, at or above 240 mg/dl*/
if totchol  = . then delete;
run;
data framchol2;
set fram; 
if totchol LE 239 then cholcat = '1'; /*borderline high*/
if totchol GE 240 then cholcat = '2'; /*high, at or above 240 mg/dl*/
if totchol  = . then delete;
run;
/*Changing age and Heart rate to categorical. New Code!*/
data framcategories;
set framchol; 
if Age GE 32 and Age LE 42  then agecat = '1'; /*32-42*/
if Age GE 43 and Age LE 53 then agecat = '2'; /*43-53*/
if Age GE 54 then agecat = '3'; /*54-64*/
if age = . then delete;
if heartrte LE 75 then heartcat = '1'; /*Lower and Higher than 75*/ ; 
if heartrte GE 76 then heartcat = '2';
if heartrte = . then delete;
run;

/*outcome*/
proc freq data=fram;
tables angina;
run;

/*exposure*/
proc freq data=framchol;
tables cholcat;
run;
proc freq data=framchol2;
tables cholcat;
run;
proc univariate data=fram;
var totchol;
histogram/normal;
run;
/*Other: Sex (binary), age (continuous), BMI (continuous), Heart Rate (continuous). */
proc freq data=fram;
tables sex;
run;
proc univariate data=fram;
var age ;
histogram/normal;
run;
proc univariate data=fram noprint;
histogram age/midpoints=28 to 75 by 1;
run;
proc means data=fram;
var age BMI heartrte;
run;
proc univariate data=fram;
var bmi;
histogram/normal;
run;
proc univariate data=fram;
var heartrte;
histogram/normal;
run;

/*Question 3: Bivariate relationships. [for 2a and 2b, if both variables are binary then your description would be,
e.g., “Smokers were 2.2 times as likely to be obese as non-smokers”; 
if both variables are continuous, use both graphical techniques (scatterplot) and 
simple correlation coefficient or linear regression (do not rely on p-value for slope)*/
/*if one is continuous and the other is binary or categorical:
compare means, standard deviations, and histograms or boxplots.]  Confidence intervals and p-values are important and 
should be included but consider strength of effect (strength of association) as your primary finding of interest. */
/*
a.	The main exposure by each covariate:  first among all subjects, and second only among those who did not have 
the outcome of interest (this is especially relevant for a case-control study).
Main exposure can be cat (cholcat) or cont. (totchol) 
Included variables from proc logistic in modified project 1 = angina=totchol sex age educ bmi

sex - categorical. cholcat categ. 1-men 2=women */

proc freq data = framchol2 order=freq;
tables sex*cholcat/OR chisq;
run;
/*Women were 0.760 times as likely to have high cholesterol as men. Protective effect*/
proc univariate data = fram plot;
var totchol;
class sex;
histogram/normal;
run;
proc sgplot data=fram;
vbox totchol / category=sex;
run;

/* age - can be cont. or cat. */
proc univariate data=framcategories plot;
var age;
histogram/normal;
run;
proc univariate data=framcategories plot;
var totchol;
histogram/normal;
run;
proc univariate data = framcategories plot;
var totchol ;
class agecat ;
histogram/normal;
run;
proc corr data=fram;
var age totchol;
run;
proc freq DATA=framcategories2;
tables agecat*cholcat /or chisq;
RUN; 
proc anova data=framcategories;
class agecat;
model totchol=agecat;
run;
proc corr data=fram;


data framcategories2;
set framchol2; 
if age LE 60 then agecat = '0'; 
if Age GE 61 then agecat = '1'; 
if age = . then delete;
run;

proc freq data = framcategories2 order=freq;
tables educ*cholcat/OR chisq;
run;
/*educ - categorical*/
proc freq data = framchol2 order=freq;
tables educ*cholcat/OR chisq;
run;
proc univariate data = fram plot;
var totchol;
class educ;
histogram/normal;
run;
proc anova DATA=fram;
CLASS educ;
MODEL totchol=educ;
RUN; 
/*bmi - cont. */
proc univariate data=framchol;
var bmi;
class cholcat;
histogram/normal;
run;
proc anova data=framchol;
class cholcat;
model bmi=cholcat;
run;
proc corr data=framchol;
var bmi totchol;
run;

/*b. The outcome by each covariate:  first among all subjects, and second only among the unexposed 
(if your main exposure is continuous, define a relatively unexposed group which is large enough for this purpose). */
proc freq data = fram order=freq;
tables sex*angina/OR chisq;
run;
proc univariate data=framchol;
var age;
class angina;
histogram/normal;
run;
proc logistic data=framchol;
class educ (ref='4');
model angina=educ;
run;

/*
c.	Do the distributions in 3a and 3b change your choices of coding for any variable(s)?  If so, which one(s) and why?  
d.	Summarize your findings from 3a and 3b in one or two simple tables.  For the purposes of this table, you can exclude the associations among controls only from 3a, or the unexposed only from 3b.  A good way to set the table up is as follows:  have each row show a different covariate.  One column can show the association between that covariate and the main exposure.  Another column can show the association between that covariate and the outcome variable.  
e.	Based on the two bivariate relationships (exposure/confounder and confounder/outcome), which covariates are strong, possible, or unlikely candidates for confounding?  
f.	Can the exposure/confounder and confounder/outcome relationships tell you anything about possible effect modification?  Explain why or why not
*/


/* Project 1 code for backwards selection with changes*/

proc logistic data=fram descending;
class angina (ref='0') /param=ref;
model angina = totchol;
run;
/*backwards stepwise regression for new Angina = Total Cholesterol*/
proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') cursmoke (ref='0') educ (ref='4') diabetes (ref='0')/param=ref;
model angina=totchol diabetes sex age cursmoke educ bmi HEARTRTE cigpday/corrb;
run;
/*Remove cursmoke p=0.6558*/
proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') educ (ref='4') diabetes (ref='0')/param=ref;
model angina=totchol diabetes sex age educ bmi HEARTRTE cigpday/corrb;
run;
/*Remove cigpday p=0.7559*/
proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') educ (ref='4') diabetes (ref='0')/param=ref;
model angina=totchol diabetes sex age educ bmi HEARTRTE/corrb;
run;
/*remove diabetes p=0.1514, second highest is education 1 p=0.1104, but other levels are significant*/
proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') educ (ref='4')/param=ref;
model angina=totchol sex age educ bmi HEARTRTE/corrb;
run;
/*CHANGR FROM PROJECT 2: remove heart rate p=0.088*/
proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') educ (ref='4')/param=ref;
model angina=totchol sex age educ bmi/corrb;
run;
/*one group in education is still significant, leaving in*/

