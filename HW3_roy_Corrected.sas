data sodium;
input subject treatment $ diet $ SPB;
datalines;
1 x L 124
2 x L 120
3 x L 121
4 x L 115
5 x N 154
6 x N 155
7 x N 148
8 x N 151
9 y L 160
10 y L 141
11 y L 152
12 y L 151
13 y N 157
14 y N 141
15 y N 153
16 y N 145
17 z L 150
18 z L 170
19 z L 147
20 z L 150
21 z N 145
22 z N 161
23 z N 157
24 z N 153
;run;
proc print data=sodium;
run;

ods graphics on;
proc mixed data=sodium covtest plots=all ;
class treatment diet;
model spb = treatment|diet /cl;
*random subject;
lsmeans treatment|diet /cl adjust=tukey;
run;

proc mixed data=sodium;
   class treatment diet;
   model spb = treatment diet treatment*diet /cl;
*random subject;
contrast 'treatment' treatment 1 -1 0;
contrast 'diet' diet 1 -1;
estimate'interaction' treatment*diet 1 -1 0;
lsmeans treatment diet treatment*diet / cl adjust=tukey;
run;
/*problem from book*/
data gas;  
input temp gas $ resol ;  
datalines ;  
120 Low 10
120 High 13  
180 Low 12 
180 High 18 
run ;
ods graphics on;
proc sgplot ;
series x= temp y= resol / group = gas markers ;
yaxis label = 'Peak reolution';
xaxis label = 'Column Temperature';
keylegend / title = 'Gas Flow Rate';
run ;
ods graphics off ; 


/*------------------------------------------*/

ods graphics on;
proc glm data = sodium ;
class treatment diet;
model spb=treatment|diet /clparm solution ;
means treatment|diet;
lsmeans treatment|diet / adjust=tukey;
output out=diagnostics r=res p=pred; 
run ; ods graphics off;
*check normality of residulas;
proc univariate data = diagnostics normaltest;
title 'check normality of residuals';
 qqplot res / normal (L = 1 mu = 0 sigma = est);
 *histogram res /normal (L = 1 mu = 0 sigma = est) kernel(L = 2 K = quadratic);
run;
* checking constant variance using proc glm each factor at a time;
title 'Constant Variance using GLM by factor';
proc glm data = sodium ;
 class treatment diet;
 model spb =treatment|diet;
 means treatment / hovtest;
output out=Residuals r=residual;
 run;
data Residuals;
    set Residuals;
    abs_residual = abs(residual);
run;
title 'treatment';
proc glm data=Residuals;
    class treatment;
    model abs_residual = treatment;
    means treatment / hovtest=levene;
run;
title 'diet';
proc glm data=Residuals;
    class diet;
    model abs_residual = diet;
    means diet / hovtest=levene;
run;

Data short(keep=subject trt weight0-weight4)
     Long(keep=subject trt time weight);
Input subject trt weight0-weight4;
Output short;
Weight=weight0; time=0; output long;
Weight=weight1; time=1; output long;
Weight=weight2; time=2; output long;
Weight=weight3; time=3; output long;
Weight=weight4; time=4; output long;
Datalines;
          1      1     57    86    114    139    172
          2      1     60    93    123    146    177
          3      1     52    77    111    144    185
          4      1     49    67    100    129    164
          5      1     56    81    104    121    151
          6      1     46    70    102    131    153
          7      1     51    71     94    110    141
          8      1     63    91    112    130    154
          9      1     49    67     90    112    140
         10      2     57    82    110    139    169
         11      2     61    86    109    120    129
         12      2     59    80    101    111    122
         13      2     53    79    100    106    133
         14      2     59    88    100    111    122
         15      2     51    75    101    123    140
         16      2     51    75     92    100    119
         17      2     56    78     95    103    108
         18      2     58    69     93    114    138
         19      3     46    61     78     90    107
         20      3     53    72     89    104    122
         21      3     59    85    121    146    181
         22      3     54    71     90    110    138
         23      3     56    75    108    151    189
         24      3     59    85    116    148    177
         25      3     57    72     97    120    144
         26      3     52    73     97    116    140
		 27	     3     52    70    105    138    171

;run;

title "Question 4 Normality" ;
proc univariate data=long;
qqplot weight / normal(mu=est sigma=est color=red l=1);
by trt;
run;
TITLE 'Means across Time by Treatment';
PROC SGPLOT DATA=long;
 VLINE time /RESPONSE=weight STAT=MEAN
 GROUP=trt
LINEATTRS=(THICKNESS=2) MARKERS
MARKERATTRS=(SIZE=2MM)
DATALABEL;
RUN;
TITLE 'Correlation (covariance)';
proc corr data=long cov ;
var time trt weight;
run;
TITLE 'Correlation (covariance)';
proc corr data=short cov ;
var trt weight0 weight1 weight2 weight3 weight4;
run;
TITLE 'Compound symmetry';
proc mixed data=long;
class trt time;
model weight = trt time trt*time;
repeated / type=cs sub=subject;
run;
TITLE 'Mauchlys';
proc glm data=short;
class trt;
model weight0-weight4 = trt /nouni;
repeated weight 5 /printe;
run;

proc glm data=short;
class trt; 
model weight0-weight4 = /nouni;
repeated weight 5 polynomial/printm summary;
run;
quit;


/*MANOVA*/
title 'MANOVA';
PROC GLM DATA = short;
CLASS trt ;
MODEL weight0-weight4 = trt;
REPEATED weight / PRINTE ;
LSMEANS trt;
RUN;

title 'MANOVA';
PROC GLM DATA = long;
CLASS trt time;
MODEL weight = trt time trt*time;
REPEATED weight / PRINTE ;
LSMEANS trt;
RUN;

title 'Manova';
proc glm data=short;
class trt;
model weight0-weight4 = trt ;
repeated weight;
run;
