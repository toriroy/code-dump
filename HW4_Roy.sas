/*Homework 4: Tori Roy*/;
/*Variable List:
ID, Treatment (1=Control, 2=Thiouracil, 3=Thyroxin), 
Baseline Weight (Week 0), Weight at Week 1, Weight at Week 2, 
Weight at Week 3, Weight at Week 4. */

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
27	3     52    70    105    138    171
;
/*short(subject trt weight0-weight4)
Long(subject trt time weight) */

*mean plot using proc glimmix question 1a;
proc glimmix data = long;
 class trt time;
 model weight = trt time trt*time/noint;
 random _residual_ / subject = subject type = cs;
 lsmeans trt*time / plot = meanplot (sliceby = trt join);
 *requests a graphical display for the interaction LS means;
run;

*mean plot using proc glimmix;
proc glimmix data = long;
 class trt time;
 model weight = trt time trt*time / noint;
 random _residual_ / subject = subject type = cs;
 lsmeans trt*time / plot = meanplot (sliceby = trt join);
 *requests a graphical display for the interaction LS means;
run;

/*question 1b */
proc corr data=short cov ;
var weight0 weight1 weight2 weight3 weight4;
run;

/*unstructured covariance matrix */
title 'unstructured';
proc mixed data=long CL;
class trt time subject;
model weight = trt time /s chisq;
repeated / type=un sub=subject r rcorr;
run;
proc mixed data=long CL method=ML;
class trt time subject;
model weight = trt time trt*time/s chisq;
repeated / type=un sub=subject r rcorr;
run;
/*Compound symmetry */
title 'compound';
proc mixed data=long CL;
class trt time subject;
model weight = trt time /s chisq;
repeated / type=cs sub=subject r rcorr;
run;
proc mixed data=long CL method=ML;
class trt time subject;
model weight = trt time trt*time/s chisq;
repeated / type=cs sub=subject r rcorr;
run;
/*Autoregressive AR(1)*/
title 'ar(1)';
proc mixed data=long CL;
class trt time subject;
model weight = trt time /s chisq;
repeated / type=ar(1) sub=subject r rcorr;
run;
proc mixed data=long CL method=ML;
class trt time subject;
model weight = trt time trt*time/s chisq;
repeated / type=ar(1) sub=subject r rcorr;
run;
/*Heterogeneous ARH(1)*/
title 'arh(1)';
proc mixed data=long CL;
class trt time subject;
model weight = trt time /s chisq;
repeated / type=arh(1) sub=subject r rcorr;
run;
proc mixed data=long CL method=ML;
class trt time subject;
model weight = trt time trt*time/s chisq;
repeated / type=arh(1) sub=subject r rcorr;
run;




/*page 161 

proc mixed;
CLASS id group t;
MODEL y=group time group*time / S CHISQ;
REPEATED t / TYPE=UN SUBJECT=id R RCORR;  

/*short(subject trt weight0-weight4)
Long(subject trt time weight) */

/*proc mixed data = long;
class subject trt time;
model weight = trt time trt*time / s chisq;
repeated time /type=un subject=subject R Rcorr;
run;
