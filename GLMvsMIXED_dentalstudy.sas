/*******************************************************************
EXAMPLE: Dental growth study: Analysis of the dental study data by repeated measures analysis of variance using PROC GLM nad MIXED
- the repeated measurement factor is age (time)
- there is one "treatment" factor, gender
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
/* The following lines plot the data */
Symbol1 I = join v = none r = 12;
Proc gplot data = formixed;
Plot y*age = person/ nolegend;
By gender;
Run;
* mean plot using proc glimmix;
Proc Glimmix data = formixed;
class gender person age;
model y = gender age gender*age;
random _residual_/subject = person type = cs;
lsmeans gender*age/plot=meanplot(sliceby=gender join); *requests a graphical display for the interaction LS means;
run;
** correlation;
proc corr data=forglm cov;
var y1 y2 y3 y4;
run;

*univariate ANOVA and MANOVA;
* Does NOT allow for running reduced model with only linear, linear+quadratic;
proc glm data=forglm;
class gender;
model y1-y4=gender / nouni;
repeated age 4 (8 10 12 14) / printe;
lsmeans gender / pdiff; *to compare GENDER means adjusted for AGE and AGE*GENDER and averaged across the repeated measures;
run;
* using proc MIXED;
* polynomial effects using proc mixed equivalent to the proc glm ;
* allows for running reduced model with only linear, linear+quadratic;
* between and within subject factors are in the model statement, but only between subject in GLM;
*covariance pattern model with CS;
proc mixed data=formixed;
class gender age person;
model y = gender|age;
repeated / type=cs sub=person;
lsmeans gender / pdiff; *to compare GENDER means adjusted for AGE and AGE*GENDER and averaged across the repeated measures;
*lsmeans gender/pdiff; * LSMEANS here has advantages over that of proc GLM: computes correct SE, allows for time to be continuous;
run;

* CS that varies by Gender;
proc mixed data=formixed;
class gender age person;
model y = gender|age;
repeated / type=cs sub=person group=gender;
*lsmeans gender/pdiff; * LSMEANS here has advantages over that of proc GLM: computes correct SE, allows for time to be continuous;
run;


*covariance pattern model with HF;
proc mixed data=formixed;
class gender age person;
model y = gender|age;
repeated / type=hf sub=person;
lsmeans gender / pdiff;
run;
*covariance pattern model with UN;
proc mixed data=formixed;
class gender age person;
model y = gender|age;
repeated / type=un sub=person;
*lsmeans gender / pdiff;
run;
* Mixed model with polynomial in age;
proc mixed data=formixed;
class gender person;
model y = gender|age|age|age / htype=1;* type I sum of squres;
repeated / type=un sub=person;
run;
*it appears that the cubic and quadratic terms are not needed;
* we can not fit this type of model in proc GLM;
proc mixed data=formixed;
class gender person;
model y = gender|age / htype=1;
repeated / type=un sub=person;
run;
*polynomial effects of age in GLM;
proc glm data=forglm;
class gender;
model y1-y4=gender / nouni ss1;
repeated age 4 (8 10 12 14) polynomial /summary;
run;

*random coefficient models;
proc mixed data=formixed;
class gender person;
model y = gender|age ;
*repeated / type=un sub=person;
random int age/subject=person;
run;


