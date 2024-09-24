** Example 1: Estimating Parameters of a GLM via SAS procedures *********;

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
if time eq 35 then tr35=1; else tr35=0;
if time eq 40 then tr40=1; else  tr40=0;
if time eq 45 then tr45=1; else  tr45=0;
*effect coding*;
if time eq 35 then te35=1; else te35=0;
if time eq 40 then te40=1; else te40=0;
if time eq 45 then do; 
	te35=-1; 
    te40=-1;
	end;
run;

** NOte;
* cell mean model can be estimates using means statement in glm;
* effect factor model need constraint (sum taus =0 or tau_g=0 as in GLM)
* getting the estimates, design matrix and its inverse;

*******OLS***********;
proc glm data=bread;
class time;
model height=time/solution xpx inverse;
run;

*******MLE via Proc Genmod***********;
proc genmod data=bread;
class time;
model height=time/dist=normal;
run;

*******MLE via Proc Mixed***********;
proc mixed data=bread method=ML;
class time;
model height=time/ solution;
run;

*******REML via Proc GLIMMIX***********;
proc glimmix data=bread ;
class time;
model height=time/ solution dist=normal;
run;

*******MLE via Proc NLMixed***********;
data bread2;
set bread;
 if time eq 35 then time35=1; else time35=0;
 if time eq 40 then time40=1; else time40=0;
 if time eq 45 then time45=1; else time45=0;
run;

proc nlmixed data=bread2;
   parms beta0=0 beta11=0 beta12=0 s2e=1;
   mu=beta0 + beta11*time35 + beta12*time40;
   model height ~ normal(mu, s2e);
run;

******* BoxPlot of the distribution of height************;
proc sgplot data=bread;
  title "Box plot of bread rise data";
  vbox height / category=time;
run;

*********** GLM with diagnostic plots via ODS ***********;
ods graphics on;
proc glm data=bread;
class time;
model height=time/solution;
means time / hovtest welch; *default hovtest is levens with square. you can use levens(abs); *welch is for weighted anova;
run;
ods graphics off;

*** GLM, REF and EFFECT coding: But these do not give the same set of estimates as in proc genmode below. Check??**;
proc glm data=bread;
class time;
model height=time/solution;
means time / hovtest=levene(type=abs);
run;
*GLM: Parameter estimates of main effects estimate the difference in the effects of each level compared to the last level. ;
proc glm data=bread;
model height=tg35 tg40/solution;
run;
*REF: estimate the difference in the effect of each nonreference level compared to the effect of the reference level;
proc glm data=bread;
model height=tr35 tr40/solution;
run;
*effect: Parameter estimates of main effects estimate the difference in the effect of each nonreference level compared to the average effect over all three levels;
proc glm data=bread;
model height=te35 te40 /solution;
run;
proc means data=bread;
*class time;
var height;
run;
proc glm data=bread;
class time;
model height=time/solution;
run;
** USING proc genmod;
proc genmod data=bread;
class time(param=effect);
model height=time/dist=normal;
run;
proc genmod data=bread; * the default results in same values as REF and GLM options;
class time;
model height=time/dist=normal;
run;

* testing variance via Proc MIXED and GLIMMIX: BUT these do not agree with Levens Test;
proc glimmix data=bread;
class time;
model height=time/solution;
*random _residual_/group=time;
random _residual_/subject=id group=time;
covtest 'common variance' homogeneity; * this is a df=g-1 chisquare test for homogneity of variances;
run;
** Non-parametric test if ANOVA assumptions are violated;
proc NPAR1WAY data=bread wilcoxon;
class time;
var height;
run;
**Weighted Least Squares is another solution to deal with unequal variances***;
/* Calculates mean and standard deviations  */
proc sort data=bread; by time;
proc means data=bread; var height; by time;
  output out=means stddev=s;
/* Creates weights                          */
data bread3; merge bread means; by time;
  w=1/s;
proc glm data=bread3;
  class time;
  model height=time;
  weight w;
run;
*hetrogenous variance model using MIXED;
ods graphics on;
proc mixed data=bread asycov;
   class time;
   model height = time / s;
   repeated / group=time; * group with the default type=VC is used to fit hetrogenous variance model;
run;
ods graphics off;

******* GLM with diagnostics **********;
proc glm data=bread plots=diagnostics;
class time;
model height=time;
output out=diagnostics p=yhat student=student r=residual; *output residual information for diagnostic purposes;
run;

proc univariate data=diagnostics normal; *check resid diag;
	var residual;
	histogram residual;
	qqplot residual / normal(mu=0 sigma=1);
run;

******* GLM with Multiple comparisons **********;
proc glm data=bread;
class time;
model height=time;
means time/cldiff tukey bon scheffe lsd dunnett('35') alpha=0.05; * time=35 is the control group for Dunnett;
run;


*simulate option;
proc glm data=bread;
class time;
model height=time;
lsmeans time /pdiff cl adjust=simulate (NSAMP=100000 seed=278912);
run;

* Create orthogonal polynomials;
Proc iml;
t={1 2 3 4};
c=orpol(t);
print c;
quit;

* SEPARATE contrast STATEMENTS;
proc glm data=bread;
class time;
model height=time/solution clparm;
contrast '35 versus 45' time -1 0 1;
contrast '35 versus 40' time -1 1 0;
CONTRAST 'Linear trend' time -1 0 1;
CONTRAST 'Quadratic trend' time 1 -2 1;
estimate '-0.5(35+40)+45' time -1 -1 2/divisor=2 ;
run;
* TREND: DEPENDENT TEST UISNG ORTHOGONAL CONTRASTS;
proc glm data=bread;
class time;
model height=time/solution ;
contrast 'LINEAR & QUAD' time -1 0 1,
		                  time 1 -2 1;
run;

* Trend test:INDEPENDENT ;
proc glm data=bread;
class time;
model height=time;
estimate 'Linear trend' time -0.707107 0 0.707107;
estimate 'Quadratic trend' time 0.4082483 -0.816497 0.4082483;
run;

proc glm data=bread;
class time;
model height=time;
estimate 'Linear trend' time -1 0 1;
estimate 'Quadratic trend' time 1 -2 1;
run;

*** Reading F critical values using SAS***;
data Fvalues;
*do v1=5 ;
 do v2=10 to 20 by 5;
 do lambda=0 to 5 by 1;
f1=finv(.95,1,v2,lambda);
f5=finv(.95,5,v2,lambda);
f10=finv(.95,10,v2,lambda);
output;
end;
end;
*end;
run;

proc sgplot data=fvalues;
*series x=v2 y=f1/group=lambda;
*series x=v2 y=f5/group=lambda;
series x=v2 y=f10/group=lambda;
run;
