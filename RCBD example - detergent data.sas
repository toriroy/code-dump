* An experiment was designed to study the performance of four different detergents for cleaning
clothes. The following cleanness readings (higher = cleaner) were obtained with specially
designed equipment for three different types of common stains. 
* Is there a difference among the detergents?;

options nocenter ls=78;
goptions colors=(none);
symbol1 v=circle; axis1 offset=(5);
data wash;
input stain soap y @@;
cards;
1 1 45 1 2 47 1 3 48 1 4 42
2 1 43 2 2 46 2 3 50 2 4 37
3 1 51 3 2 52 3 3 55 3 4 49
;
run;
*one way ANOVA: soap is not significant;
ods graphics on;
proc glm data=wash plots=diagnostics; *provides digagnostic plots including for test of additivity;
class soap;
model y = soap ;
output out=diagnostics r=res p=pred;
run;

ods rtf file="I:\bmtry702\BMTRY702\Fall 2010\data and sas code\RCBD examples.rtf";
ods graphics on;
* soap is significant after adjsuting for stain effect: BUT need to check assumptions first;
proc glm data=wash plots=diagnostics; *provides digagnostic plots including for test of additivity;
class stain soap;
model y = soap stain  ; 
*means soap / tukey bon scheffe; 
*lsmeans soap /adjust=tukey;
output out=diagnostics r=res p=pred;
run;

*check normality of residulas;
proc univariate data=diagnostics noprint;
qqplot res / normal (L=1 mu=0 sigma=est);
histogram res /normal (L=1 mu=0 sigma=est) kernel(L=2 K=quadratic);	* L if for line type 1=solid 2=dash;
run;
* checking constant variance using proc glm each factor at a time;
proc glm data=wash ; *provides digagnostic plots including for test of additivity;
class stain soap;
model y = soap ;
means soap /hovtest ;
run;

proc glm data=wash ; *provides digagnostic plots including for test of additivity;
class stain soap;
model y = stain  ;
means stain /hovtest ;
run;
* Checking homogneity of variance using proc glimmix or mixed: BOTH DO NOT SEEM TO AGREE;
proc glimmix data=wash ; 
class stain soap;
model y =  soap stain;
random _residual_/ group=soap;
covtest 'common variance' homogeneity;
*lsmeans soap /adjust=tukey;
run;
proc glimmix data=wash ; 
class stain soap;
model y =  soap stain;
random stain/ group=soap;
covtest 'common variance' homogeneity;
*lsmeans soap /adjust=tukey;
run;
* Checking homogneity of variance using proc mixed;
* NOTE: use stain in the model statement to get approapriate denominator test for soap BUT if you want to get test of varinace romove it from model;
proc mixed data=wash covtest; 
class stain soap;
model y = stain ;
random soap;
*lsmeans soap /adjust=tukey;
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
plot y*soap=stain;
run;

* Missing data example;
data wash2;
set wash;
if y=37 then y=.;
run;

goptions reset=all;
proc glm data=wash2; /* Regression Approach */
class stain soap;
model y=stain soap ;
output out=diag p=pred r=res;
means soap / lsd lines;	*lists the means in descending order and indicates nonsignificant subsets by line segments beside the corresponding means;
lsmeans soap / stderr;
run;
* imputing OLS estimate;
data new1; /* Input estimate */
set wash2;
if y=. then y=42.17;
run;

proc glm data=new1; /* Analysis of imputed data*/
class stain soap;
model y=soap stain;
output out=diag p=pred r=res;
means soap / lsd lines;
run;

ods rtf close;

* RANDOM BLOCK EXAMPLE;
* assume that stain is random;
proc glm data=wash;
class stain soap;
model y = stain soap /*soap*stain*/; 
random stain/test; *The TEST option in the RANDOM statement requests that PROC GLM to determine the appropriate  
tests based on stain being treated as random effects. ;
*test e=soap h=soap*stain; 	* if the design was generalized RCBD with replication;
lsmeans soap/stderr tdiff;
run;
* equivalently;
proc mixed data=wash;
class stain soap;
model y = soap; 
random stain;
lsmeans soap/diff ;
run;

* Comparison between proc mixed and proc glm for Random Effects
	
	* Standard error for a mean: proc glm incorrect
	* Standard error for a contrast: proc glm correct
;

*** Additional Example from Montegomery ***;

* Tukey non-additivity test;
* Impurity in chemical product is affected by temperature and pressure. We will assume
temperature is the blocking factor. The data is shown below. 
* We test for non-additivity.	;

data impurity;
input trt blk y @@;
cards;
1 1 5 1 2 3 1 3 1 2 1 4 2 2 1 2 3 1
3 1 6 3 2 4 3 3 3 4 1 3 4 2 2 4 3 1
5 1 5 5 2 3 5 3 2
;
proc univariate; /* Get mean of y for Step 2 */
var y;
proc glm;
class blk trt;
model y = blk trt; /* Step 1 */
output out=resid1 r=res1 p=pred1; /* Step 2 */
data resid1;
set resid1;
pred1sq = pred1*pred1/(2*2.933333); /* 2.933 is mean from proc univariate */

* test of lambda=0 is the pvalue corresponding to pred1sq;
proc glm;
class blk trt;
model y = blk trt pred1sq / solution;
output out=resid2 r=res2 p=pred2; /* Steps 3-5 */
run;

