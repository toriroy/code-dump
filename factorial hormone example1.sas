* Example with no interaction;
* input data from the lecture note;

data glycogen;
input trt $ resp1 resp2 resp3 resp4 resp5 resp6 @;
resp=resp1; output; 
resp=resp2; output; 
resp=resp3; output; 
resp=resp4; output; 
resp=resp5; output; 
resp=resp6; output; 
keep trt resp ;
datalines;
A	106	101	120	86	132	97
a	51	98	85	50	111	72
B	103	84	100	83	110	91
b	50	66	61	72	85	60
run;

data new;
set glycogen;
/* Transform data into two factors */
if trt="a" then horm=1; if trt="a" then level=1;
if trt="A" then horm=1; if trt="A" then level=2;
if trt="b" then horm=2; if trt="b" then level=1;
if trt="B" then horm=2; if trt="B" then level=2;
run;

data new2;
set glycogen;
/* Transform data into two factors */
if trt="a" then horm1=1; else if trt="A" then horm1=2; 
if trt="b" then horm2=1; else if trt="B" then horm2=2; 
run;

/* Break down one-way analysis by contrasts */
ods rtf file="I:\bmtry702\BMTRY702\Fall 2010\data and sas code\Factorial hormone examples.rtf";

ods graphics on;
proc glm data=new;
class trt;
model resp = trt;
contrast 'hormone' trt 1 -1 1 -1; * low level vs high level;
contrast 'level' trt 1 1 -1 -1;	* hormone A vs B;
contrast 'interaction' trt 1 -1 -1 1; *equivalence of level effect;
run;
ods graphics off;

/* t-test on each factor */
proc glm data=new;
class level;
model resp = level;
run;
proc glm data=new;
class horm;
model resp = horm;
run;

/* Do anova with interactions */
ods graphics on;
proc glm data=new plots=diagnostics;
class horm level ;
model resp = horm level  level*horm / solution clparm;
*lsmeans level|horm / adjust=tukey pdiff;
/* Shows means at each level */
*lsmeans level horm level*horm / adjust=tukey pdiff tdiff;
*lsmeans level*horm / slice=(horm level) adjust=tukey pdiff; * to study simple effects of level at each level of hormone and viceversa;
output out=new1 r=res p=pred;
run;
ods graphics off;
ods rtf close;

**pooled analysis***;
proc glm data=new;
class level horm;
model resp = level horm / solution clparm;
lsmeans level horm / adjust=tukey pdiff tdiff;
run;

/*Interaction test plots */
proc sort data=new; 
by horm level;
proc means data=new noprint;
var resp; 
by horm level;
output out=means mean=mn;
run;
symbol1 v=circle i=join; symbol2 v=square i=join; 
proc gplot data=means;
plot mn*horm=level;
run;

/* Normal diagnostics */
proc univariate data=new1 noprint;
hist res / normal (L=1 mu=0 sigma=est) kernel (L=2);
run;
/* Residuals diagnostics */
symbol1 v=circle; axis1 offset=(5);
proc gplot data=new1;
plot res*pred / haxis=axis1;

proc gplot data=new1;
plot res*pred=level / haxis=axis1;
run;

proc gplot data=new1;
plot res*pred=horm / haxis=axis1;
run;
/* Scatter plot */
symbol1 v=circle; axis1 offset=(5);
symbol2 v=plus; axis1 offset=(5);
proc gplot data=new;
plot resp*level=horm / haxis=axis1;
run;
* Checking homogneity of variance using proc glimmix or mixed: BOTH DO NOT SEEM TO AGREE;
proc glimmix data=new ; 
class level horm;
model resp = level horm level*horm / solution;
random _residual_/ group=level*horm;
covtest 'common variance' homogeneity;
*lsmeans soap /adjust=tukey;
run;



