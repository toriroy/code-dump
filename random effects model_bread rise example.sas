
data bread;
input time h1-h4;
height=h1; output;
height=h2; output;
height=h3; output;
height=h4; output;
keep time height;
datalines;
35 4.5 5.0 5.5 6.75
40 6.5 6.5 10.5 9.5
45 9.75 8.75 6.5 8.25
;
run;

data bread;
set bread;
id=_N_;
*GLM coding*;
if time eq 35 then tg35=1; else tg35=0;
if time eq 40 then tg40=1; else tg40=0;
if time eq 45 then tg45=1; else tg45=0;
*ref coding*;
if time eq 35 then tr35=1; else tr40=0;
if time eq 40 then tr35=0; else tr40=1;
if time eq 45 then tr35=0; else tr40=0;
*effect coding*;
if time eq 35 then te35=1; else te40=0;
if time eq 40 then te35=0; else te40=1;
if time eq 45 then te35=-1; else te40=-1;
run;

** NOte;
* cell mean model can be estimates using means statement in glm;
* effect factor model need constraint (sum taus =0 or tau_g=0 as in GLM)
* getting the estimates, design matrix and its inverse;
* these methods provide equivalent estimates if the method of moments estimator is in the parameter space and data is balanced;
* method of moment estimators are unbiased under the assumption that random effects are independent of errors;
* when random effects are normally distributed REML and ML possess large sample propoerties;
*******random effects model***********;
proc glm data=bread;
class time;
model height=time/clparm;
random time/test;
run;
* gives estimates of variance components and their 95% CI;
* the SE estimates of variance components from REML and ML are computed from inverse of information matrix, 
* But the approximation is not apprpriate when the number of levels of the random effect (in this example 3) is small;
* also the Z-test for sigma2>0 is not appropriate if number of levels is small;
proc mixed data=bread asycov covtest cl; *default REML;
class time;
model height=;
random time;
run;
proc mixed data=bread asycov cl method=type3; * this gives a method of moments estimator based on MSE and MSA;
class time;
model height=;
random time;
run;
* gives var(time)=(MSA-MSE)/r;
* by default assumes all factors are random unless you specify;
proc varcomp data=bread ;
class time;
model height=time;
run;

 /*-------------------------------------------------------*/
 /*---CHAPTER 3: Random Effects Models                 ---*/
 /*---Data Set 3.3, Mississippi River  (UNBALNACED)                ---*/
data influent;
  input influent y @@;
  datalines;
1   21  1   27  1   29  1   17  1   19 
1   12  1   29  1   20  1   20  2   21 
2   11  2   18  2   9   2   13  2   23 
2   2   3   20  3   19  3   20  3   11 
3   14  4   14  4   24  4   30  4   21 
4   31  4   27  5   7   5   15  5   18 
5   4   5   28  6   41  6   42  6   35 
6   34  6   30 
;
 /*---Output 3.1                                       ---*/
proc mixed data=influent covtest cl;
   class influent;
   model y = /solution;
   random influent / solution;
run;

 /*---Output 3.2                                       ---*/
proc mixed data=influent method=ml;
   class influent;
   model y = / solution;
   random influent / solution;
   run;
 
 /*---Output 3.3                                       ---*/
proc mixed data=influent method=mivque0;
   class influent;
   model y = / solution;
   random influent / solution;
   run;


 /*---Output 3.6                                       ---*/    
proc glm data=influent; 
   class influent;
   model y = influent;
   random influent / test;
run;
quit;
 
proc varcomp data=influent method=reml; * you can specify method to ML, REML, Type1-3, MIVIQUE;
class influent;
model y = influent;
run;

* we artificially modified to make levels of A to be 8 (larger) and balanced;
* these methods provide equivalent estimates if the method of moments estimator is in the parameter space and data is balanced;

data influent2;
  input influent y @@;
  datalines;
1   21  1   27  1   29  1   17  1   19 
2   12  2   29  2   20  2   20  2   21 
3   11  3   18  3   9   3   13  3   23 
4   2   4   20  4   19  4   20  4   11 
5   14  5   14  5   24  5   30  5   21 
6   31  6   27  6   7   6   15  6   18 
7   4   7   28  7   41  7   42  7   35 
8   34  8   30  8   29  8   17  8   19 
;
proc mixed data=influent2 covtest cl; *REML;
   class influent;
   model y = /solution;
   random influent / solution;
run;
proc mixed data=influent2 covtest cl method=type3; *type3;
   class influent;
   model y = /solution;
   random influent / solution;
run;
proc varcomp data=influent2 method=type3; * you can specify method to ML, REML, Type1-3, MIVIQUE;
class influent;
model y = influent;
run;
proc glm data=influent2; * get esti mates using MS since GLM does not provide one;
   class influent;
   model y = influent;
   random influent / test;
run;
quit;
