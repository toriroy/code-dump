proc import file = 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\frmgham_period1.csv'
dbms=csv
out=fram;
run;

data framcat;
set fram;
/*categorical total cholesterol*/
if totchol LT 200 then cholcat = '1'; /*normal*/
if totchol GE 200 and cholcat LE 239 then cholcat = '2'; /*borderline high*/
if totchol GE 240 then cholcat = '3'; /*high, at or above 240 mg/dl*/
if totchol  = . then delete;
/*Dichotomized total cholesterol */
if totchol LE 239 then cholcatbinary = '1'; /*borderline high*/
if totchol GE 240 then cholcatbinary = '2'; /*high, at or above 240 mg/dl*/
if totchol  = . then delete;
/*Changing age and Heart rate to categorical. New Code!*/
if Age GE 32 and Age LE 42  then agecat = '1'; /*32-42*/
if Age GE 43 and Age LE 53 then agecat = '2'; /*43-53*/
if Age GE 54 then agecat = '3'; /*54-64*/
if age = . then delete;
if heartrte LE 75 then heartcat = '1'; /*Lower and Higher than 75*/ ; 
if heartrte GE 76 then heartcat = '2';
if heartrte = . then delete;
/*Dichotomizing age to "younger" and "older"*/
if age LE 60 then agebinary = '0'; 
if Age GE 61 then agebinary = '1'; 
if age = . then delete;
/*Changing BMI to categorical*/
if bmi LE 18.4 then bmicat = '1'; /*underweight*/
if bmi GE 18.5 and bmi LE 24.9 then bmicat = '2'; /*normal weight*/
if bmi GE 25 and bmi LE 29.9 then bmicat = '3'; /*overweight*/
if bmi GE 30 then bmicat = '4';
if bmi = . then delete;
/*BMI as binary. Because the underweight group is so small, compining with normal*/
if bmi LE 24.9 then bmibinary = '0';
if bmi GE 25 then bmibinary = '1';
/*education as binary variable*/
if educ LE 2 then educbinary = '1'; /*0 - 11 years and HS diploma, GED*/
if educ GT 2 then educbinary ='2'; /*Some college, vocational school and 4 year degree +*/
run;



/*outcome*/
proc freq data=fram;
tables angina;
run;

/*Main exposure*/
proc freq data=framcat;
tables cholcat;
run;
proc freq data=framcat;
tables cholcatbinary;
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

/*Question 3: Bivariate relationships. */
/*a.Main exposure can be categorical (cholcat) binary (cholcat in framchol2) or cont. (totchol) 
Included variables from proc logistic in modified project 1 = angina=totchol sex age educ bmi

sex - binary 1-men 2=women. by main exposure total cholesterol*/

/*sex and total cholesterol as categorical*/
proc freq data = framcat;
tables sex*cholcatbinary/OR chisq;
run;
/*Women were 0.760 times as likely to have high cholesterol as men. Protective effect*/



/*total cholesterol as cont and sex*/
proc univariate data = fram plot;
var totchol;
class sex;
histogram/normal;
run;
/*box plot for total cholesterol as cont. variable*/
proc sgplot data=fram;
vbox totchol / category=sex;
run;

/* age - can be cont. or cat. by main exposure total cholesterol*/
proc univariate data=framcat plot;
var age;
histogram/normal;
run;
/*total cholesterol graphed*/
proc univariate data=framcat plot;
var totchol;
histogram/normal;
run;
/*age as a categorical variable and total cholesterol as cont.*/
proc univariate data = framcat plot;
var totchol ;
class agecat ;
histogram/normal;
run;
/*correlation matric for age (cont) and total cholesterol (cont)*/
proc corr data=fram;
var age totchol;
run;
/*age and total cholesterol as categorical (binary) variables*/
proc freq DATA=framcat;
tables agebinary*cholcatbinary /or chisq;
RUN; 
/*ANOVA between age (categorical) and total cholesterol as cont. variable*/
proc anova data=framcat;
class agecat;
model totchol=agecat;
run; /*p=<0.0001*/
/*total cholesterol (cont) and age (cont) pearson corr coeff.*/
proc corr data=fram;
var age totchol;
run;
/*education and main exposure total cholesterol */
proc freq data = framcat order=freq;
tables educ*cholcat/OR chisq;
run;
/*educ - categorical and total cholesterol as categorical (binary)*/
proc freq data = framcat order=freq;
tables educ*cholcatbinary/OR chisq;
run;
proc glm data=framcat;
model totchol=educ;
run;


/*total cholesterol (cont) and education (cat.)*/
proc univariate data = fram plot;
var totchol;
class educ;
histogram/normal;
run;
/*ANOVA between total cholesterol (cont) and education*/
proc anova DATA=fram;
CLASS educ;
MODEL totchol=educ;
RUN; /*p=0.33*/
/*bmi - cont. and cholesterol as categorical*/
proc univariate data=framcat;
var bmi;
class cholcat;
histogram/normal;
run;
/*ANOVA between cholesterol as categorical and BMI*/
proc anova data=framcat;
class cholcat;
model bmi=cholcat;
run; /*p=<.0001*/ 
proc logistic data=framcat;
class bmicat (ref='2') /param=ref;
model cholcatbinary = bmi;
run;
/*Corr Coeff. for BMI and total cholesterol (cont.)*/
proc corr data=framchol;
var bmi totchol;
run;

/*b. The outcome by each covariate:  first among all subjects, and second only among the unexposed 
(if your main exposure is continuous, define a relatively unexposed group which is large enough for this purpose). */

/*sex (binary) and angina (binary)*/
proc freq data = fram order=freq;
tables sex*angina/OR chisq;
run;
proc univariate data=framcat;
var age;
class angina;
run;
proc sgplot data=fram;
title 'Box plot of AGE for those with and without Angina';
vbox age / category=angina;
run;
proc logistic data=framcat;
model angina=age ;
run;

/*BMI (cont) and total cholesterol (cont)*/
proc logistic data=framcat;
class angina /param = ref;
model angina=bmi;
run;
proc univariate data=framcat;
var bmi;
class angina;
histogram/normal;
run;
/*BMI as categorical*/
proc logistic data=framcat;
class bmicat (ref='2') /param=ref;
model angina = bmicat;
run;
proc freq data=framcat;
tables angina*bmicat;
run;
proc freq data=framcat;
tables bmibinary*angina /or chisq;
run;

/*education (categorical) and angina (binary)*/
proc logistic data=framcat;
class educ (ref='4');
model angina=educ;
run;
proc logistic data=framcat;
class educ (ref='4') angina (ref='0')/ param=ref;
model angina=educ;
run;
proc freq data=framcat;
tables educbinary*angina /or chisq;
run;

/*crude association between angina and total cholesterol by sex*/
proc logistic data=framcat descending;
class angina (ref='0') /param=ref;
model angina = totchol;
run;
proc freq data=framcat;
tables cholcatbinary*angina/or chisq;
run;
proc freq data=framcat;
where (sex = 1);
tables cholcatbinary*angina / or chisq;
run;
proc freq data=framcat;
where (sex = 2);
tables cholcatbinary*angina / or chisq;
run;
/*education strata*/
proc freq data=framcat;
tables cholcatbinary*angina / or chisq;
run;
proc freq data=framcat;
where (educ = 1);
tables cholcatbinary*angina / or chisq;
run;
proc freq data=framcat;
where (educ = 2);
tables cholcatbinary*angina / or chisq;
run;
proc freq data=framcat;
where (educ = 3);
tables cholcatbinary*angina / or chisq;
run;
proc freq data=framcat;
where (educ = 4);
tables cholcatbinary*angina / or chisq;
run;

/*bmi strata*/
proc freq data=framcat;
tables cholcatbinary*angina / or chisq;
run;
proc freq data=framcat;
where (bmicat = '1');
tables cholcatbinary*angina / or chisq;
run;
proc freq data=framcat;
where (bmicat = '2');
tables cholcatbinary*angina / or chisq;
run;
proc freq data=framcat;
where (bmicat = '3');
tables cholcatbinary*angina / or chisq;
run;
proc freq data=framcat;
where (bmicat = '4');
tables cholcatbinary*angina / or chisq;
run;
/*BMI cat group 1 too small, changing to binary*/
proc freq data=framcat;
where (bmibinary = '0');
tables cholcatbinary*angina / or chisq;
run;
proc freq data=framcat;
where (bmibinary = '1');
tables cholcatbinary*angina / or chisq;
run;
/*testing interaction terms*/
proc logistic data=framcat descending;
class angina (ref='0') /param=ref;
model angina = totchol bmi educ sex age age*totchol bmi*totchol educ*totchol sex*totchol ;
run;
/*remove totchol*age p=.4187 and totchol*BMI p=.6936 and totchol*sex p=.1501*/
proc logistic data=framcat descending;
class angina (ref='0') /param=ref;
model angina = totchol bmi educ sex age educ*totchol ;
run;
proc freq data=framcat;
tables sex*angina;
run;
proc freq data=framcat;
tables agebinary*angina;
run;
proc freq data=framcat;
tables bmibinary*angina;
run;
proc freq data=framcat;
tables educbinary*angina;
run;






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

