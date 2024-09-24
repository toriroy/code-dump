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

title "Question 4" ;
proc glm data=short;
class trt;
  model weight4-weight0  = trt /nouni;
  repeated weight 4 / printe;
  lsmeans  trt /out=means;
run;
quit;
proc print data=means;
run;
goptions reset=all;
symbol1 c=blue v=star h=.8 i=j;
symbol2 c=red v=dot h=.8 i=j;
symbol3 c=green v=square h=.8 i=j;
axis1 order=(40 to 180 by 10) label=(a=90 'Means');
axis2  label=('weight');
proc gplot data=means;
  plot lsmean*_name_= trt / vaxis=axis1 haxis=axis2;
run;
quit;

* Box's M test for equality of variances;
proc discrim data=short method=normal pool=test wcov;
class trt ;
var weight0 weight1 weight2 weight3 weight4;
run;
proc discrim data=short method=normal pool=test wcov;
class trt ;
var weight0 weight1 weight2 weight3 weight4;
run;

proc mixed data=long covtest;
   class trt time;
   model weight = trt time trt*time /corrb ;
   repeated time / type=cs subject=subject ;
   random intercept /subject=subject;
  
run;




proc mixed data=long covtest;
   class trt time;
   model weight = trt time trt*time / solution;
   repeated time / type=cs subject=subject;
   random intercept / subject=subject;
   store out=mymodel;
run;

/* predicted values and residuals */
proc plm restore=mymodel;
   score data=long out=PredictedValues predicted=pred residual=residual;
run;

/* normal probability plot of the residuals */
proc univariate data=PredictedValues;
   var residual;
   probplot residual / normal(mu=est sigma=est);
   title 'Normal Probability Plot of Residuals';
run;


/*a. Matrix plot and describe general distribution and correlation of responses*/

data responses;
   set long;
   *log_var = log(original_var);
   
run;
/* Create a matrix plot for distribution and correlation of responses */
proc sgscatter data=responses;
   matrix weight time trt/* Include other response variables if any */;
   title 'Matrix Plot for Distribution and Correlation of Responses';
run;

proc mixed data=long;
  class time trt;
  model weight = trt time trt*time / solution;
  repeated time / subject=subject type=cs;
run;

/*mean plot*/
proc means data=long mean noprint;
  class time trt;
  var weight;
  output out=mean_data mean=mean_weight;
run;

/* Proc sgplot to create mean plot */
proc sgplot data=mean_data;
  title 'Mean Outcome Weight by Treatment and Time';
  scatter x=time y=mean_weight / group=trt markerattrs=(symbol=circlefilled);
  keylegend / position=topright;
  xaxis label='Time';
  yaxis label='Mean Outcome Weight';
run;
proc sgplot data=mean_data;
  title 'Mean Outcome Weight by Treatment and Time';
  series x=time y=mean_weight / group=trt lineattrs=(thickness=2);
  keylegend / position=topright;
  xaxis label='Time';
  yaxis label='Mean Outcome Weight';
run;

/* Proc sgplot to create profile plot */
proc sgplot data=long;
  scatter x=time y=weight / group=trt markerattrs=(symbol=circlefilled);
  xaxis label='Time';
  yaxis label='Weight';
  keylegend / title='Treatment';
run;

/*repeated measures ANOVA. assuming CS covariance structure*/
proc mixed data=long method=ml;
   class trt time;
   model weight = trt time / solution;
   repeated / type=cs subject=subject;
run;



proc glm data = short;
 model weight0-weight4 = trt / nouni;
 repeated weight / printe nom;
run;
proc glm data = short;
 model weight0-weight4 = / nouni;
 repeated weight / printe nom ;
run;
proc means data = short n mean stderr t prt;
 var weight0 weight1 weight2 weight3 weight4;
 by trt;
run;
ods graphics on;

proc mixed data=long;
   class trt time;
   model weight = trt time trt*time / s;
   repeated time / type=cs subject=subject;
   lsmeans trt / pdiff adjust=tukey;
run;

* Mauchly's test for the (S) condition is significant,
* indicating that the analyses run earlier may not be the appropriate ones --
* we now run one-way RM analyses of B within each level of A;

proc glm data = short;
 model weight0-weight1 = / nouni;
 repeated weight 4 / printe;
 by trt;
run;



