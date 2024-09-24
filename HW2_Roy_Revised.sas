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
/*5a. Homogeneity of variance*/
title '5a';
proc glm data = HW2Q5;
class treatment;
model assay = treatment;
means treatment / hovtest=levene(type=abs);
run;
/* Fit model and Examine Residual Plots 
Q-Q Plot for residuals assay*/  
ods graphics on;  
proc glm data = HW2Q5 plots = diagnostics (unpack);  
class treatment (ref='Control');  
model assay = treatment / solution;
run; ods graphics off;  


/*5b*/
title '5b';
ods graphics on;
proc glm data = HW2Q5 ;
class treatment(ref='Control') experiment (ref='1');
model assay = treatment experiment /clparm solution;
means treatment;
lsmeans treatment / adjust=tukey;
output out=diagnostics r=res p=pred; 
run ; ods graphics off;

*check normality of residulas;
proc univariate data = diagnostics noprint;
 qqplot res / normal (L = 1 mu = 0 sigma = est);
 histogram res /normal (L = 1 mu = 0 sigma = est) kernel(L = 2 K = quadratic);
run;

* checking constant variance using proc glm each factor at a time;
proc glm data = HW2Q5;
 class treatment experiment;
 model assay = treatment experiment;
 means treatment / hovtest;
output out=Residuals r=residual;
 run;
data Residuals;
    set Residuals;
    abs_residual = abs(residual);
run;
proc glm data=Residuals;
    class treatment;
    model abs_residual = treatment;
    means treatment / hovtest=levene;
run;
proc glm data=Residuals;
    class experiment;
    model abs_residual = experiment;
    means experiment / hovtest=levene;
run;
* are block effects additive? Tukey non-additivity test;
proc means data = hw2q5 mean std n; *get mean of y for Step 2;
 var assay;
run;
proc glm data = HW2Q5;
 class treatment experiment;
 model assay = treatment experiment; *Step 1;
 output out = resid1 r = res1 p = pred1; *Step 2;
run;
data resid1;
 set resid1;
 pred1sq = pred1*pred1/(2*1228.72); 
run;
* test of lambda = 0 is the pvalue corresponding to pred1sq (p=0.3674);
proc glm data = resid1;
 class treatment experiment;
 model assay = treatment experiment pred1sq / solution;
 output out = resid2 r = res2 p = pred2; *Steps 3-5;
run;

/*2a*/
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
title '2a';
/*a. interaction plot */
symbol1 v = circle i = join;
symbol2 v = square i = join;
symbol3 v = triangle i = join;
symbol4 v = star i = join;
proc gplot data=hw2q2;
    plot response*treatment=block;
run;
proc glm data = hw2q2;
class treatment block;
model response = treatment block ;
run ;
ods graphics on;
proc glm data = hw2q2;
class treatment block;
model response = treatment block /clparm solution;
means treatment;
lsmeans treatment / adjust=tukey;
output out=diagnostics r=res p=pred; 
run ; ods graphics off;
*check normality of residulas;
proc univariate data = diagnostics noprint;
 qqplot res / normal (L = 1 mu = 0 sigma = est);
 histogram res /normal (L = 1 mu = 0 sigma = est) kernel(L = 2 K = quadratic);
run;
* checking constant variance using proc glm each factor at a time;
proc glm data = HW2Q2;
 class treatment block;
 model response = treatment block;
 means treatment / hovtest;
output out=Residuals r=residual;
 run;
data Residuals;
    set Residuals;
    abs_residual = abs(residual);
run;
proc glm data=Residuals;
    class treatment;
    model abs_residual = treatment;
    means treatment / hovtest=levene;
run;
proc glm data=Residuals;
    class block;
    model abs_residual = block;
    means block / hovtest=levene;
run;
* are block effects additive? Tukey non-additivity test;
proc means data = hw2q2 mean std n; *get mean of y for Step 2: 276.5937500;
 var response;
run;
proc glm data = HW2Q2;
 class treatment block;
 model response = treatment block; *Step 1;
 output out = resid1 r = res1 p = pred1; *Step 2;
run;
data resid1;
 set resid1;
 pred1sq = pred1*pred1/(2*276.5937500); 
run;
* test of lambda = 0 is the pvalue corresponding to pred1sq (p=0.3674);
proc glm data = resid1;
 class treatment block;
 model response = treatment block pred1sq / solution;
 output out = resid2 r = res2 p = pred2; *Steps 3-5;
run;


/*______________________________________________________________________*/

title 'part ba';
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

title 'part bb';
proc glm data = hw2q2;
 class treatment;
 model response = treatment /clparm solution;
 contrast 'Mean of Treatment 1 - 3' treatment 1 0 -1 0;
estimate 'Mean 1-3' treatment 1 0 -1 0 ;
means treatment / cldiff tukey bon scheffe lsd dunnett('C') alpha = 0.05;
lsmeans treatment / diff cl;
means treatment / dunnettl ('C');
run; 
proc glm data = hw2q2;
 class treatment block;
 model response = treatment /clparm solution;
 lsmeans treatment /diff cl;
*contrast 'Mean of Treatment 1 - 3' treatment 1 0 -1 0;
estimate 'Difference mean 1 and mean 3' treatment 1 0 -1 0;
run; 


title 'part bc';
/*c. Variance estimate and CI */


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
proc import datafile = 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\hw2_q2.csv'
out=ques3
dbms=csv;
run;
*ANCOVA parametrization 2: yij = tau_i + beta_i*X_ij + e_ij;
proc glm data = ques3 plots = diagnostics;
 class diet;
 *fits separate intercepts and slopes for each drug;
 model weight = diet diet*cal / noint solution;
 *tests if slopes for all drugs are equal;
 contrast 'all slopes equal' diet*cal 1 1 -1 -1 ,
							 diet*cal 1 1 -1 -1;
run;




*an estimate and 95%CI variance among experimental units*/;
proc mixed data=ques3;
    class cal;
    model weight = diet cal ;
    random diet / subject=cal;
run;



