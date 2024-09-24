* Creating RCBD in SAS;

data ABP;
input blocks$ 1-3 A B P;
litter=A; treat=A; output;
litter=B; treat=B; output;
litter=P; treat=P; output;
datalines;
l1 1 2 3
l2 1 2 3
l3 1 2 3
l4 1 2 3
l5 1 2 3
l6 1 2 3
l7 1 2 3
;
run;
data litters;
set ABP;
keep blocks litter;
run;

data rand;
set ABP;
u=ranuni(0);
keep blocks treat u;
run;

proc sort;
by blocks u;
run;

data RCBD;
merge litters rand;
keep blocks litter treat;
run;

proc print;
id blocks;
var litter treat ;
run;

*Using Proc Plan;
proc plan seed=1234 ordered;
factors litter=7 treat=3;
treatments treatment=3 random;
output out=RCBD2 litter cvals=('l1' 'l2' 'l3' 'l4' 'l5' 'l6' 'l7'); 
run;

proc print data=rcbd2;
id litter;
run;

data abp;
input litter treat y;
datalines;
1 1 5.4
1 2 6.0
1 3 5.1
2 1 4.0
2 2 4.8
2 3 3.9
3 1 7.0
3 2 6.9
3 3 6.5
4 1 5.8
4 2 6.4
4 3 5.6
5 1 3.5
5 2 5.5
5 3 3.9
6 1 7.6
6 2 9.0
6 3 7.0
7 1 5.5
7 2 6.8
7 3 5.4
;
run;

* Graphical check of additivity assumption: are lines parallel?;
symbol1 v=circle i=join;
symbol2 v=square i=join;
symbol3 v=triangle i=join;
proc gplot data=abp;
plot y*treat=litter;
run;


*** AExample 1: Litter study;
* wrong analysis- one way ANOVA agnoring blocking;
ods graphics on;
proc glm data=abp plots=diagnostics; *provides digagnostic plots including for test of additivity;
class treat;
model y = treat  ;
means treat ; 
lsmeans treat /adjust=tukey;
output out=diagnostics r=res p=pred;
run;
ods graphics off;

* correct analysis - two way ANOVA with blocking;
ods graphics on;
proc glm data=abp plots=diagnostics; *provides digagnostic plots including for test of additivity;
class litter treat;
model y = treat litter ;
means treat ; 
lsmeans treat /adjust=tukey;
output out=diagnostics r=res p=pred;
run;
ods graphics off;

*check normality of residulas;
proc univariate data=diagnostics noprint;
qqplot res / normal (L=1 mu=0 sigma=est);
histogram res /normal (L=1 mu=0 sigma=est) kernel(L=2 K=quadratic);	* L if for line type 1=solid 2=dash;
run;
* checking constant variance using proc glm each factor at a time;
proc glm data=abp ; *provides digagnostic plots including for test of additivity;
class treat litter;
model y = treat ;
means treat /hovtest ;
run;


* are block effects additive?;
* Tukey non-additivity test;

proc means data=abp mean std n; /* Get mean of y for Step 2 */
var y;
run;
ods graphics on;
proc glm data=abp;
class litter treat;
model y = treat litter ;/* Step 1 */
output out=resid1 r=res1 p=pred1; /* Step 2 */
run;
ods graphics off;

data resid1;
set resid1;
pred1sq = pred1*pred1/(2*5.79); /* 5.79 is mean from proc means */
run;
* test of lambda=0 is the pvalue corresponding to pred1sq;
proc glm data=resid1;
class treat litter;
model y = treat litter pred1sq / solution;
output out=resid2 r=res2 p=pred2; /* Steps 3-5 */
run;

*** exmple 2: Detergent study;
ods graphics on;
proc glm data=wash plots=diagnostics; *provides digagnostic plots including for test of additivity;
class stain soap;
model y =  soap ;
means soap /hovtest ;
run;
* are block effects additive?;
* Tukey non-additivity test;

proc means data=wash mean std n; /* Get mean of y for Step 2 */
var y;
run;
proc glm data=wash;
class stain soap;
model y = stain soap; /* Step 1 */
output out=resid1 r=res1 p=pred1; /* Step 2 */
run;
data resid1;
set resid1;
pred1sq = pred1*pred1/(2*47.08); /* 47.08 is mean from proc univariate */
run;
* test of lambda=0 is the pvalue corresponding to pred1sq;
proc glm data=resid1;
class stain soap;
model y = stain soap pred1sq / solution;
output out=resid2 r=res2 p=pred2; /* Steps 3-5 */
run;

* Graphical check of additivity assumption: are lines parallel?;
symbol1 v=circle i=join;
symbol2 v=square i=join;
symbol3 v=triangle i=join;
proc gplot data=wash;
plot y*stain=soap;
run;
