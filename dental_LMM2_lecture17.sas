/*******************************************************************
EXAMPLE: Dental growth study: Analysis of the dental study data by repeated measures analysis of variance using PROC GLM nad MIXED
- the repeated measurement factor is age (time)
- there is one "treatment" factor, gender
- Pothoff & Roy 
   This study was conducted in 16 boys and 11 girls, who at ages 8, 10, 12,
   and 14 had their distance (mm) from the center of the pituitary gland to
   the pteryomaxillary fissure measured.  Changes in pituitary-pteryomaxillary
   distances during growth is important in orthodontal therapy.  The goals of
   the study were to describe the distance in boys & girls as simple functions
   of age, and then to compare the functions for boys & girls.
*******************************************************************/
options ls=80 ps=59 nodate; run;
/******************************************************************/;

data forglm(keep=person gender y1-y4)
formixed(keep=person gender age y);
input person gender$ y1-y4;
output forglm;
y=y1; age=8; output formixed;
y=y2; age=10; output formixed;
y=y3; age=12; output formixed;
y=y4; age=14; output formixed;
datalines;
1 F 21.0 20.0 21.5 23.0
2 F 21.0 21.5 24.0 25.5
3 F 20.5 24.0 24.5 26.0
4 F 23.5 24.5 25.0 26.5
5 F 21.5 23.0 22.5 23.5
6 F 20.0 21.0 21.0 22.5
7 F 21.5 22.5 23.0 25.0
8 F 23.0 23.0 23.5 24.0
9 F 20.0 21.0 22.0 21.5
10 F 16.5 19.0 19.0 19.5
11 F 24.5 25.0 28.0 28.0
12 M 26.0 25.0 29.0 31.0
13 M 21.5 22.5 23.0 26.5
14 M 23.0 22.5 24.0 27.5
15 M 25.5 27.5 26.5 27.0
16 M 20.0 23.5 22.5 26.0
17 M 24.5 25.5 27.0 28.5
18 M 22.0 22.0 24.5 26.5
19 M 24.0 21.5 24.5 25.5
20 M 23.0 20.5 31.0 26.0
21 M 27.5 28.0 31.0 31.5
22 M 23.0 23.0 23.5 25.0
23 M 21.5 23.5 24.0 28.0
24 M 17.0 24.5 26.0 29.5
25 M 22.5 25.5 25.5 26.0
26 M 23.0 24.5 26.0 30.0
27 M 22.0 21.5 23.5 25.0
;
*** Plots for longitudinal data ***;
* Matrix plot;
* set ODS graphics to landscape mode and designate output PDF file;
OPTIONS ORIENTATION=LANDSCAPE;
ODS GRAPHICS ON;
*ODS PDF FILE="I:\BMTRY748\mulugeta\sas examples\Pothoff_plots.pdf";

* multivariate plot;
TITLE 'Pituitary-Pteryomaxillary Distances - Ages 8, 10, 12, & 14';
        PROC SGSCATTER DATA=forglm;
        MATRIX y1--y4 / DIAGONAL=(HISTOGRAM KERNEL);
RUN;
* Profile or spaghetti Plot;
Symbol1 I = join v = none r = 12;
Proc gplot data = formixed;
Plot y*age = person/ nolegend;
By gender;
Run;
* sort data by gender and age;
data formixed2;
set formixed;
run;
PROC SORT formixed2;
BY Gender Age;
RUN;

* spaghetti plot using Proc SGPANEL;
  TITLE 'Observed Data, All Subjects';
  PROC SGPANEL NOAUTOLEGEND DATA=formixed;
  PANELBY Gender;
  * observed trends;
  SERIES X=Age Y=y / GROUP = person LINEATTRS = (THICKNESS=1);
  RUN;

 * mean plots;
TITLE 'Means across Ages by Gender';
PROC SGPLOT DATA=formixed;
   * mean trends;
   VLINE Age /RESPONSE=y STAT=MEAN 
   GROUP=Gender LINEATTRS=(THICKNESS=2) MARKERS MARKERATTRS=(SIZE=2MM) DATALABEL;
RUN;
* mean plot using proc glimmix;
Proc Glimmix data = formixed;
class gender person age;
model y = gender age gender*age/noint;
random _residual_/subject = person type = cs;
lsmeans gender*age/plot=meanplot(sliceby=gender join); *requests a graphical display for the interaction LS means;
run;
ODS PDF CLOSE;
ODS GRAPHICS OFF;

** correlation;
proc corr data=forglm cov ;
var y1 y2 y3 y4;
run;

* assuming independence;
/*
In general, ignoring the dependency of the observations will overestimate the standard errors of the the time-dependent predictors 
(such as age SE=0.0977 vs SE=0.06 in CS), since we haven’t accounted for between-subject variability.
However, standard errors of the time-independent predictors (such as gender SE=0.45 vs SE=0.76 under CS) will be underestimated. 
The long form of the data makes it seem like there’s 4 times as much data then there really is! 
*/;
proc mixed data=formixed;
class gender;
model y=age gender /s;
run;

*ANOVA - assumes compund symmetry;
/*******************************************************************
Construct the analysis of variance using PROC GLM via the below specification. 
Note that the F ratio that PROC GLM prints out automatically for the gender effect (averaged across age) will use the MSE in the denominator. This is not the correct F ratio for
testing this effect. The RANDOM statement asks SAS to compute the expected mean squares for each source of variation. The TEST option asks
SAS to compute the test for the gender effect (averaged across age), treating the child(gender) effect as random, giving the
correct F ratio. Other F-ratios are correct.
In older versions of SAS it was done by adding a: test h=gender e = child(gender);
*******************************************************************/
* check SE of LSMEANS statement below and compare it to the one with repeated and MIXED;
* the random statement induces a CS covariance structure;
proc glm data=formixed;
class age gender person;
model y = gender person(gender) age age*gender;
random person(gender) / test;* if you do not put this test statement then F(gender)=MSgender/MSE instead of MSgender/MSperson(gender);
lsmeans gender / pdiff; *to compare GENDER means adjusted for AGE and AGE*GENDER and averaged across the repeated measures;
run;

* polynomial trend assuming CS;
PROC GLM data=formixed;
class gender age person;
model y = gender person(gender) age age*gender;
random person(gender) / test;
     CONTRAST 'Linear' age -3  -1   1   3 ;
     CONTRAST 'Quad'   age  1  -1  -1   1 ;
     CONTRAST 'Cubic'  age -1   3  -3   1 ;
     CONTRAST 'GrpLinear' age*gender -3  -1   1   3     3   1  -1  -3 ;
     CONTRAST 'GrpQuad'   age*gender  1  -1  -1   1    -1   1   1  -1 ;
     CONTRAST 'GrpCubic'  age*gender -1   3  -3   1     1  -3   3  -1 ;
RUN;

*univariate ANOVA and MANOVA - assumes sphericity (var(yi-yj)=same for all i and j);
* Does NOT allow for running reduced model with only linear, linear+quadratic;
proc glm data=forglm;
class gender;
model y1-y4=gender / nouni;
repeated age 4 (8 10 12 14) / printe;
lsmeans gender / pdiff; *to compare GENDER means adjusted for AGE and AGE*GENDER and averaged across the repeated measures;
run;
*polynomial effects of age in GLM - multivariate ;
proc glm data=forglm;
class gender;
model y1-y4=gender / nouni ;
repeated age 4 (8 10 12 14) polynomial /summary;
run;

****** Profile analysis with covariance pattern models ***;
* using proc MIXED - you can use METHOD=REML, ML or TYPE3;
* polynomial effects using proc mixed equivalent to the proc glm ;
* allows for running reduced model with only linear, linear+quadratic;
* between and within subject factors are in the model statement, but only between subject in GLM;
*covariance pattern model with CS;
proc mixed data=formixed method=ML;
class gender age person;
model y = gender age gender*age/solution chisq;
repeated age/ type=cs sub=person;
*lsmeans gender / pdiff; *to compare GENDER means adjusted for AGE and AGE*GENDER and averaged across the repeated measures;
*lsmeans gender/pdiff; * LSMEANS here has advantages over that of proc GLM: computes correct SE, allows for age to be continuous;
run;

*covariance pattern model with HF - equivalent to adjusted univariate ANOVA in proc GLM;
proc mixed data=formixed;
class gender age person;
model y = gender age gender*age;
repeated / type=hf sub=person;
lsmeans gender / pdiff;
run;
*covariance pattern model with UN;
proc mixed data=formixed;
class gender age person;
model y = gender age gender*age;
repeated / type=un sub=person;
*lsmeans gender / pdiff;
run;
*covariance pattern model with AR(1);
proc mixed data=formixed;
class gender age person;
model y = gender age gender*age;
repeated / type=AR(1) sub=person;
*lsmeans gender / pdiff;
run;
*covariance pattern model with ARH(1);
proc mixed data=formixed;
class gender age person;
model y = gender age gender*age;
repeated / type=ARH(1) sub=person;
*lsmeans gender / pdiff;
run;

****** Parametric Curve analysis with covariance pattern models ***;
** Comparison of mean models should be based on ML ***;
*linear;
proc mixed data=formixed method=ml;
class gender person;
model y = gender|age;
repeated / type=cs sub=person;
run;
*quadratic;
proc mixed data=formixed method=ml;
class gender person;
model y = gender|age|age;
repeated / type=cs sub=person;
run;

* spline aanalysis;
data spline;
set formixed;
st1=min(age, 10); *knot at time=2;
st2=max(0, age-10);
run;
proc mixed data = spline;
class person age gender;
model y=gender st1 st2 st1*gender st2*gender / s chisq; * chisq provides likelihood ratio test in addition to F test;
repeated age/ type=un subject=person r;
run;

proc mixed data = spline method=ml;
class person age gender;
model y=gender st1 st2 st1*gender st2*gender / s chisq; * chisq provides likelihood ratio test in addition to F test;
repeated age/ type=cs subject=person r;
run;


* analysis assuming independence;
proc mixed data=formixed method=ml;
 class person gender;   
 model y = gender age gender*age/s;
 repeated / subject=person;
run;
* covariance pattern model- UN;
proc mixed data=formixed method=ml;
 class person gender;   
 model y = gender age gender*age/s;
 repeated / type=un subject=person;
run;

*** Linear Mixed Models *******;
* Choosing among mean models: use LRT;
* LMM with random int;

* LMM with random int with G varying by gender;
proc mixed data=formixed method=ml;
 class person gender;   
 model y = gender age gender*age/s;
 random intercept  / type=un group=gender subject=person;
run;
* LMM with random int with G varying by gender;
proc mixed data=formixed method=ml;
 class person gender;   
 model y = gender age gender*age age*age age*age*gender/s;
 random intercept  / type=un group=gender subject=person;
run;

* comparison between variants of random int and/or slope models;
* M1:Random Int model with uncorrelated errors;
proc mixed data=formixed method=reml;
    class person gender;
	model y = age gender gender*age / s;
	random intercept / type=un subject=person g;
run;

* M1-Random Int and slope model with uncorrelated errors;
proc mixed data=formixed method=reml;
    class person gender;
	model y = age gender gender*age / s;
	random intercept age/ type=un subject=person g;
run;
* M2-Random Int model with uncorrelated errors varying by gender;
proc mixed data=formixed method=reml;
    class person gender;
	model y = age gender gender*age / s;
	random intercept / type=un subject=person g;
    repeated / type=VC group=gender subject=person;
run;
* M3-Random Int model with correlated errors AR(1);
proc mixed data=formixed method=reml;
    class person gender;
	model y = age gender gender*age / s;
	random intercept / type=un subject=person g ;
	repeated / type=AR(1) group=gender subject=person;
run;

* M4-Random Int model with un correlated errors and G matrix both varying by gender;
proc mixed data=formixed method=reml;
    class person gender;
	model y = age gender gender*age / s;
	random intercept / type=un group=gender subject=person g;
    repeated / type=VC group=gender subject=person;
run;

* M5-Random Int model with correlated errors (AR(1)) and G matrix both varying by gender;
proc mixed data=formixed method=reml;
    class person gender;
	model y = age gender gender*age / s;
	random intercept / type=un group=gender subject=person g;
    repeated / type=AR(1) group=gender subject=person;
run;

**** More complext models that account for measurment error and unequally spaced time intervals;
* Random Int model with correlated errors and measurement error;
proc mixed data=formixed method=reml;
    class person gender;
	model y = age gender gender*age / s;
	random intercept / type=un subject=person g;
    repeated / type=sp(pow)(age) subject=person local; * local asks for inclusion of measurement error;
run;
* Random Int and slope model with correlated errors ;
proc mixed data=formixed method=reml;
    class person gender;
	model y = age gender gender*age / s;
	random intercept age / type=un subject=person g;
    repeated / type=sp(pow)(age) subject=person;
run;
* Random Int and slope model with correlated errors and measurement error;
proc mixed data=formixed method=reml;
    class person gender;
	model y = age gender gender*age / s;
	random intercept age/ type=un subject=person g;
    repeated / type=sp(pow)(age) subject=person local; * local asks for inclusion of measurement error;
run;

*** GEE Analysis-marginal models ***;
proc genmod data=formixed;
class person gender;
model y = age gender gender*age/link=identity dist=normal;
repeated subject=person / type=exch corrw; * type can take AR(1) or UN;
run;


