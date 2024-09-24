
******************************************************************************* ;
* Excersise example ;
data exercise;
  input id exertype diet time1 time2 time3;
cards;
1     1         1       85       85       88
2     1         1       90       92       93
3     1         1       97       97       94
4     1         1       80       82       83
5     1         1       91       92       91
6     1         2       83       83       84
7     1         2       87       88       90
8     1         2       92       94       95
9     1         2       97       99       96
10    1         2      100       97      100
11    2         1       86       86       84
12    2         1       93      103      104
13    2         1       90       92       93
14    2         1       95       96      100
15    2         1       89       96       95
16    2         2       84       86       89
17    2         2      103      109       90
18    2         2       92       96      101
19    2         2       97       98      100
20    2         2      102      104      103
21    3         1       93       98      110
22    3         1       98      104      112
23    3         1       98      105       99
24    3         1       87      132      120
25    3         1       94      110      116
26    3         2       95      126      143
27    3         2      100      126      140
28    3         2      103      124      140
29    3         2       94      135      130
30    3         2       99      111      150
;
run;


****************************************************************************************** ;
title "Exercise model 1: time and diet" ;
proc glm data=exercise;
  class diet;
  model time1 time2 time3 = diet /nouni;
  repeated time 3 / printe;
run;
quit;

****************************************************************************************** ;
title "Exercise model 2: time and exertype" ;
* output means for the graph below;
proc glm data=exercise;
  class exertype;
  model time1 time2 time3 = exertype/nouni;
  repeated time 3/printe ;
  lsmeans exertype / out=means;
run;
quit;
proc print data=means;
run;
/* We reset all the graph options, create different symbols for each level of the 
   group variable and create a nice label for the vertical axis.   */
goptions reset=all;
symbol1 c=blue v=star h=.8 i=j;
symbol2 c=red v=dot h=.8 i=j;
symbol3 c=green v=square h=.8 i=j;
axis1 order=(60 to 150 by 30) label=(a=90 'Means');
axis2 value=('1' '2' '3') label=('Time');
proc gplot data=means;
  plot lsmean*_name_= exertype / vaxis=axis1 haxis=axis2;
run;
quit;

****************************************************************************************** ;
title " exercise model 3: time, diet and exertype" ;
*MANOVA and repeated measures ANOVA after sphericity test; 
*output means for the graph below ;
proc glm data=exercise;
  class diet exertype;
  model time1 time2 time3 = diet exertype diet*exertype/nouni;
  repeated time 3 / printe;
  lsmeans diet*exertype / out=means;
run;
quit;

* Box's M test for equality of variances;
proc discrim data=exercise method=normal pool=test wcov;
class diet ;
var time1 time2 time3;
run;

proc discrim data=exercise method=normal pool=test wcov;
class exertype ;
var time1 time2 time3;
run;

*If you would like to do MANOVA only;
proc glm data=exercise;
      class diet exertype;
      model time1 time2 time3 = diet exertype diet*exertype / nouni;
      manova h=diet   /  printe ;
	  manova h=exertype   /  printe ;
      manova h=diet*exertype  / printe;
     
   run;
* MANOVA without listing all the individual hypothesis;
proc glm data=exercise;
      class diet exertype;
      model time1 time2 time3 = diet exertype diet*exertype / nouni;
      manova h=_all_  /  printe ;    
   run;

proc print data=means;
run;

proc sort data=means out=sortdiet;
 by diet;
run;

goptions reset=all;
symbol1 c=blue v=star h=.8 i=j;
symbol2 c=red v=dot h=.8 i=j;
symbol3 c=green v=square h=.8 i=j;
axis1 order=(60 to 150 by 30) label=(a=90 'Means');
axis2 value=('1' '2' '3') label=('Time');
proc gplot data=sortdiet;
  by diet;
  plot lsmean*_name_=exertype / vaxis=axis1 haxis=axis2;
run; 
quit;


******************************************************************************************;
*USING PROC MIXED;
****************************************************************************************** ;
* Look at covariances ;
proc corr data=exercise cov;
  var time1 time2 time3;
run;

****************************************************************************************** ;
* Reshaping exercise data: creating univariate data from multivariate data;
*method1;
data vertical (keep=id time exertype diet pulse);
set exercise;
array x[3] time1 time2 time3;
do time=1 to 3;
 pulse=x[time];
output;
end;
run;
*method2;
proc transpose data=exercise out=long;
  by id diet exertype;
run;
data long;
  set long (rename=(col1=pulse) );
  time = substr(_NAME_, 5, 1 )+0;
  drop _name_;
run;
proc print data=long (obs=20);
  var id diet exertype time pulse;
run;

****************************************************************************************** ;
Title "model 3 with cs structure";
proc mixed data=long;
  class exertype time;
  model pulse = exertype time exertype*time;
  repeated time / subject=id type=cs;
run;

****************************************************************************************** ;
Title "model 3 with unstructure";
proc mixed data=long;
  class exertype time;
  model pulse = exertype time exertype*time;
  repeated time / subject=id type=un;
run;

****************************************************************************************** ;
Title "model 3 with ar(1) structure";
proc mixed data=long;
  class exertype time;
  model pulse = exertype time exertype*time;
  repeated time / subject=id type=ar(1);
run;

****************************************************************************************** ;
Title "model 3 with arh(1) structure";
proc mixed data=long;
  class exertype time;
  model pulse = exertype time exertype*time;
  repeated time / subject=id type=arh(1) ;
run;
title " ";

****************************************************************************************** ;
* How to get a graph using only proc mixed.  Note: proc mixed does not have an out option ;
* in the lsmeans statement so instead we use ODS to create the dataset of the means. ;
ods output LSMeans=means1;
proc mixed data=long;
  class exertype time;
  model pulse = exertype time exertype*time;
  repeated time / subject=id type=ar(1);
  lsmeans time*exertype;
run; 
proc print data=means1;
run;

goptions reset=all;
symbol1 c=blue v=star h=.8 i=j;
symbol2 c=red v=dot h=.8 i=j;
symbol3 c=green v=square h=.8 i=j;
axis1 order=(60 to 150 by 30) label=(a=90 'Means');
axis2 value=('1' '2' '3') label=('Time');
proc gplot data=means1;
  plot estimate*time=exertype / vaxis=axis1 haxis=axis2;
run; 
quit;

****************************************************************************************** ;
* graph of exertype over time by diet using proc mixed and arh(1) var-cov structure ;

ods output LSMeans = means;
proc mixed data=long;
  class exertype diet time;
  model pulse = exertype|diet|time;
  repeated time / subject=id type=arh(1) ;
  lsmeans time*diet*exertype;
run;
proc print data=means;
run;
proc sort data=means;
  by diet;
run;
goptions reset=all;
symbol1 c=black v=dot i=j;
symbol2 c=blue v=circle i=j;
symbol3 c=red v=square i=j;
axis1 order=(60 to 150 by 30) label=(a=90 'Means');
proc gplot data=means;
  by diet;
  format estimate 8.;
  plot estimate*time=exertype / vaxis=axis1;
run;
quit;


****************************************************************************************** ;
*Contrasts and contrast interactions in proc mixed.;
proc mixed data=long;
  class diet exertype  time;
  model pulse = exertype|diet|time;
  repeated time / subject=id type=arh(1) ;
  estimate 'exer 12 v 3' exertype  -.5 -.5 1; /* across time and across diet groups */
  estimate 'exer 1 v 2' exertype  -1 1 0; /* across time and across diet groups */
  estimate 'diet' diet  -1 1; /* across time and across exercise types */
  estimate 'diet 1v2 & exertype 12v3' diet*exertype -.5 -.5  1 .5  .5 -1;   /* across time only */  
  estimate 'runners only, diet 1 v 2'  diet 1 -1 diet*exertype 0 0  1 0 0 -1; /* across time only */
  lsmeans diet*exertype / slice=diet; /*testing for differences among exertype for each level of diet */ 
  lsmeans exertype*time / slice=time; /*differences in exertype for each time point*/
  lsmeans exertype*diet*time / slice=time*diet;
run;
quit;

*what do we get with ods graphics?;
ods graphics on;
proc mixed data=long plots=all;
  class exertype time;
  model pulse = exertype time exertype*time;
  repeated time / subject=id type=ar(1);
  lsmeans time*exertype/slice=exertype;
run; 
ods graphics off;




