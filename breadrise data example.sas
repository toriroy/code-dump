** Example 1: Estimating Parameters of a GLM via SAS procedures *********;

data bread;
input time h1-h4;
height=h1; rep=1; output;
height=h2; rep=2; output;
height=h3; rep=3; output;
height=h4; rep=4; output;
keep time rep height;
datalines;
35 4.5 5.0 5.5 6.75
40 6.5 6.5 10.5 9.5
45 9.75 8.75 6.5 8.25
;
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

* with diagnostics;
ods graphics on;
proc glm data=bread plot=diagnostics;
class time;
model height=time/solution;
means time / hovtest ;
run;
ods graphics off;
******* BoxPlot of the distribution of height************;
proc sgplot data=bread;
  title "Box plot of bread rise data";
  vbox height / category=time;
run;

proc means data=bread;
class time;
var height;
run;
*********** GLM with diagnostic plots via ODS ***********;
ods graphics on;
proc glm data=bread;
class time;
model height=time/solution;
means time / hovtest welch; *default hovtest is levens with square. you can use levens(abs); *welch is for weighted anova;
run;
ods graphics off;
*you can use levens(abs);
proc glm data=bread;
class time;
model height=time/solution;
means time / hovtest=levene(type=abs);
run;
*HOV test;
proc glimmix data=bread;
   class rep time;
   model height=time/solution;
   random _residual_ / subject=rep group=time;
   covtest 'common variance' homogeneity;
run;

** Non-parametric test if ANOVA assumptions are violated;
proc NPAR1WAY data=bread wilcoxon;
class time;
var height;
run;
**Weighted Least Squares is another solution to deal with unequal variances***;
/* Calculates mean and standard deviations  */
proc sort data=bread; by time;
proc means data=bread; 
var height; 
by time;
output out=means stddev=s;
run;
/* Creates weights                          */
data bread3; merge bread means; by time;
  w=1/s;
proc glm data=bread3;
  class time;
  model height=time;
  weight w;
run;
/* BOX-COX transformation;                              */
proc sort data=bread; by time;
proc means data=bread noprint; var height; by time;
  output out=means mean=meanht stddev=s;
data logs; set means;
  logmean=log(meanht);
  logs=log(s);
proc reg data=logs;
model logs=logmean;
run;

ods graphics on;
proc sgplot data=logs;
  reg y=logs x=logmean/curvelabel="Slope=1.29487";
  xaxis label="log mean";
  yaxis label="log standard deviation";
run;
ods graphics off;

 data bread2;
  input time h1-h4;
  height=h1**(1-1.294869); output;
  height=h2**(1-1.294869); output;
  height=h3**(1-1.294869); output;
  height=h4**(1-1.294869); output;
  keep time height;
datalines;
35 4.5 5.0 5.5 6.75
40 6.5 6.5 10.5 9.5
45 9.75 8.75 6.5 8.25
run;
/* Fits model with proc glm           */
ods graphics on;
proc glm data=bread2 plots=diagnostics(unpack);
  class time;
  model height=time/solution;
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
