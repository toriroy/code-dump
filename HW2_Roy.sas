Title 'Questions from Book';
data HW2Q5;
    input experiment a1-a3;
    treatment = "Control"; assay = a1; output;
    treatment = "Drug 1"; assay = a2; output;
    treatment = "Drug 2"; assay = a3; output;
    keep experiment treatment assay;
    datalines;
1 1147 1169 1009
2 1273 1323 1260
3 1216 1276 1143
4 1046 1240 1099
5 1108 1432 1385
6 1265 1562 1164
;
run;

proc glm data=HW2Q5;
    class treatment;
    model assay = treatment;
	lsmeans treatment /cl;
run;
quit;

proc glm data = HW2Q5 ;
class treatment experiment ;
model assay = experiment treatment ;
lsmeans treatment /cl;
run ;

/*Question 8a: Blocking*/
data powerRCB ;
do b =2 to 6; /*sets b to take values from 2 to 6*/
t =4; /*treatment levels*/
nu1 =(t -1) ; /*df for treatments, number of treatments - 1*/
nu2 =(b -1) * (t -1) ; /*df in RCB design, number blocks - 1 and number of treatments -1*/
alpha =.05; 
sigma2rcb =0.5; /*RCB variance*/
css =2.0; /*corrected sum squares - sum of squared deviations from the mean. Subtract grand 
mean from each observation and square that deviation the sum of these squared deviations 
would be corrected total SS*/ 
Fcrit = finv (1 - alpha , nu1 , nu2 ); /*critical f value*/
nc =b*( css )/ sigma2rcb ; /*number of replications required in RCB design, = 
#blocks x corrected SS*/
power =1 - probf ( Fcrit , nu1 , nu2 , nc ); /*power*/
output ;
keep b nu2 nc power ;
end ;
proc print data = powerRCB; 
run ;
/*because we want .90 power, 5 blocks*/
title 'Question 2';
data hw2q2;
    input treatment $ block $ response;
    datalines;
A 1 450
A 2 469
A 3 249
A 4 125
A 5 280
A 6 352
A 7 221
A 8 251
B 1 331
B 2 402
B 3 183
B 4 70
B 5 258
B 6 281
B 7 219
B 8 46
C 1 317
C 2 423
C 3 379
C 4 63
C 5 289
C 6 239
C 7 269
C 8 357
D 1 479
D 2 341
D 3 404
D 4 115
D 5 182
D 6 349
D 7 276
D 8 182
;
run;
title 'part a';
/*a. interaction plot */
symbol1 v = circle i = join;
symbol2 v = square i = join;
symbol3 v = triangle i = join;
symbol4 v = star i = join;
proc gplot data=hw2q2;
    plot response*treatment=block;
run;

title 'part b';
/*b. Two-way ANOVA with blocking */
proc glm data=hw2q2 plots=diagnostics;
    class block treatment;
    model response = treatment block;
    means treatment;
    lsmeans treatment / adjust=tukey;
    output out=diagnostics r=res p=pred;
run;

proc univariate data=diagnostics noprint;
    qqplot res / normal(L=1 mu=0 sigma=est);
    histogram res / normal(L=1 mu=0 sigma=est) kernel(L=2 K=quadratic);
run;

/* Two-way ANOVA with blocking */
proc glm data=hw2q2;
    class block treatment;
    model response = treatment block;
run;

proc glm data=hw2q2;
    class treatment;
    model response = treatment;
    contrast 'Mean of Treatment 1 - 3' treatment 1 0 -1 0;
    estimate 'Mean 1-3' treatment 1 0 -1 0;
    means treatment / cldiff tukey bon scheffe lsd dunnett('35') alpha=0.05;
    lsmeans treatment / diff cl;
    means treatment / dunnettl('3');
run;
title 'part c';
/*c. Variance estimate and CI */
proc glm data=hw2q2;
    class block treatment;
    model response = treatment block;
    output out=resid_data r=residuals;
run;

proc means data=resid_data n mean std stderr clm;
    var residuals;
run;
title 'part d';
/*d. CRD Model */
proc glm data=hw2q2;
    class treatment;
    model response = treatment;
run;

/* RCBD Model */
proc glm data=hw2q2;
    class block treatment;
    model response = treatment block;
run;
title 'part e';
/*part e.*/
data hw2q2_reduced;
    set hw2q2;
    if block in ('1','2') then new_block = '1';
    else if block in ('3','4') then new_block = '2';
    else if block in ('5','6') then new_block = '3';
    else if block in ('7','8') then new_block = '4';
run;

/* Fixed block effects */
proc glm data=hw2q2_reduced;
    class new_block treatment;
    model response = treatment new_block;
run;

/* Random block effects */
proc mixed data=hw2q2_reduced;
    class new_block treatment;
    model response = treatment;
    random new_block;
run;
proc sort data=hw2q2_reduced;
    by new_block;
run;

symbol1 v = circle i = join;
symbol2 v = square i = join;
symbol3 v = triangle i = join;
symbol4 v = star i = join;
proc gplot data=hw2q2_reduced;
    plot response*treatment=new_block;
run;
/* Fixed block effects */
proc glm data=hw2q2_reduced plots=diagnostics;
    class new_block treatment;
    model response = treatment new_block;
    means treatment;
    lsmeans treatment / adjust=tukey;
    output out=diagnostics_fixed r=residuals p=predicted;
run;

/* Normality check */
proc univariate data=diagnostics_fixed noprint;
    qqplot residuals / normal(L=1 mu=0 sigma=est);
    histogram residuals / normal(L=1 mu=0 sigma=est) kernel(L=2 K=quadratic);
run;
/* Random block effects */
proc mixed data=hw2q2_reduced;
    class new_block treatment;
    model response = treatment;
    random new_block;
run;

/* Normality check */
proc univariate data=diagnostics_random noprint;
    qqplot Residual / normal(L=1 mu=0 sigma=est);
    histogram Residual / normal(L=1 mu=0 sigma=est) kernel(L=2 K=quadratic);
run;

Title 'question 3';
/*Question 3a. 
Determine if the slopes for caloric intake are equal for all treatments. 
Write out the linear model (identifying each term), the assumptions 
and the null Hypothesis.*/

data hw2q3;
    input diet weight cal;
    datalines;
1	58	35
1	67	44
1	78	44
1	69	51
1	63	47
2	65	40
2	49	45
2	37	37
2	73	53
2	63	42
3	79	51
3	52	41
3	63	47
3	65	47
3	67	48
4	51	53
4	50	52
4	49	52
4	42	51
4	34	43
;
run;

proc glm data=hw2q3;
    class Diet;
    model cal = Weight Diet / solution;
	run;
proc glm data=hw2q3;
    class diet;
    model weight = cal diet cal*diet / solution;
    test h=cal*diet;
run;
/* Perform ANCOVA */
title 'three b';
PROC GLM DATA=hw2q3;
    CLASS Diet;
    MODEL Weight = Cal Diet / SOLUTION;
    LSMEANS Diet / ADJUST=TUKEY;
RUN;
QUIT;

/* Check the assumptions */
PROC UNIVARIATE DATA=hw2q3 NORMAL;
    VAR Weight;
RUN;

PROC PLOT DATA=hw2q3;
    PLOT Weight*Cal;
RUN;
title '3c';
PROC MEANS DATA=hw2q3;
    VAR Cal;
    OUTPUT OUT=mean_calorie MEAN=mean_calorie_intake;
RUN;

PROC MEANS DATA=hw2q3;
    CLASS Diet;
    VAR Cal;
    OUTPUT OUT=treatment_means MEAN=mean_calorie_intake;
RUN;
/* Perform ANCOVA */
PROC GLM DATA=hw2q3;
    CLASS Diet;
    MODEL Weight = Cal Diet / SOLUTION;
    LSMEANS Diet / PDIF=ALL CL AT MEANS MEAN(0);
    LSMEANS Diet / PDIF=ALL CL AT (Cal=35) AT (Cal=44) AT (Cal=51) AT (Cal=48);
RUN;
QUIT;

PROC GLM DATA=hw2q3;
    CLASS Diet (ref='2');
    MODEL Weight = Cal Diet / SOLUTION ;
    LSMEANS Diet / PDIF=ALL CL AT MEANS MEAN(0);
    LSMEANS Diet / PDIF=ALL CL AT (Cal=35) AT (Cal=44) AT (Cal=51) AT (Cal=48);
RUN;
QUIT;

PROC GLM DATA=hw2q3;
    CLASS Diet;
    MODEL Weight = Cal Diet/ SOLUTION;
    LSMEANS Diet/ PDIFF=CONTROL('1') ADJUST=DUNNETT CL;
RUN;
QUIT;
PROC GLM DATA=hw2q3;
    CLASS Diet;
    MODEL Weight = Cal Diet/ SOLUTION;
    LSMEANS Diet/ PDIFF=CONTROL('4') ADJUST=DUNNETT CL;
RUN;
QUIT;






	/*---------------------------------------------------------------------------------------------------------------*/


	/*this was my first attempt at question 2, i left it here for me. You can ignore! bascially scratch work :)*/
	/*question 2: Kuehl, Design of Experiments, 2000 where treatment 1=a etc*/
/*data hw2q2;
    input Block Treatment Response;
    datalines;
1 1 450
2 1 469
3 1 249
4 1 125
5 1 280
6 1 352
7 1 221
8 1 251
1 2 331
2 2 402
3 2 183
4 2 70
5 2 258
6 2 281
7 2 219
8 2 46
1 3 317
2 3 423
3 3 379
4 3 63
5 3 289
6 3 239
7 3 269
8 3 357
1 4 479
2 4 341
3 4 404
4 4 115
5 4 182
6 4 349
7 4 276
8 4 182
;
run;

/* Print to verify
proc print data=hw2q2;
run;

*graphical check of additivity assumption: are lines parallel?;
symbol1 v = circle i = join;
symbol2 v = square i = join;
symbol3 v = triangle i = join;
proc gplot data = hw2q2;
 plot response*treatment=block;
run;

/*two-way ANOVA with blocking
proc glm data = hw2q2 plots = diagnostics;
 class block treatment;
 model response = treatment block;
 means treatment; 
 lsmeans treatment / adjust = tukey;
 output out = diagnostics r = res p = pred;
run;
*check normality of residulas;
proc univariate data = diagnostics noprint;
 qqplot res / normal (L = 1 mu = 0 sigma = est);
 histogram res /normal (L = 1 mu = 0 sigma = est) kernel(L = 2 K = quadratic);
run;
/*CRD
proc glm data = hw2q2;
 class treatment;
 model response = treatment;
 means treatment / hovtest;
run;
* are block effects additive? parallel lines;
proc means data = hw2q2 mean std n; 
 var response;
run;
proc glm data = hw2q2;
 class block treatment;
 model response = treatment block; 
 output out = resid1 r = res1 p = pred1; 
run;
data resid1;
 set resid1;
 pred1sq = pred1*pred1/(2*276.5937500);
run;
proc glm data = resid1;
 class treatment block;
 model response = treatment block pred1sq / solution;
 output out = resid2 r = res2 p = pred2; 
run;

/*2b. Estimates of differences between means of treatment 1 and 3
proc means data = hw2q2 noprint;
by treatment;
var response;
output out = means;
run;
proc print data=means;
run;

proc glm data = hw2q2;
 class treatment;
 model response = treatment;
 contrast 'Mean of Treatment 1 - 3' treatment 1 0 -1 0;
estimate 'Mean 1-3' treatment 1 0 -1 0 ;
means treatment / cldiff tukey bon scheffe lsd dunnett('35') alpha = 0.05;
lsmeans treatment / diff cl;
means treatment / dunnettl ('3');
run; 

/*Question 2c. 
proc glm data=hw2q2 plots = diagnostics;
  class Treatment block;
  model Response = Treatment block;
  means treatment/ hovtest=levene (type=abs) hovtest=bartlett;
run;
*/
