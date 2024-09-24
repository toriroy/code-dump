*FLW pages 126-132;
data tlc;
    infile 'I:\bmtry702\bmtry702\Resources\fitxmaurice book\tlc.txt';
   input id group $ lead0 lead1 lead4 lead6;
   y=lead0; time=0; t=0; output;
   y=lead1; time=1; t=1; output;
   y=lead4; time=4; t=4; output;
   y=lead6; time=6; t=6; output;
   drop lead0 lead1 lead4 lead6;

title1 Analysis of Response Profiles of data on Blood Lead Levels;
title2 Treatment of Lead Exposed Children (TLC) Trial;

**************************************************************************;
*   Uncomment to change reference levels for group and time   *;
**************************************************************************;
proc sort;
by group descending time;

*profile analysis using GLM;
proc mixed data=tlc noclprint=10 order=data;
class id group time;
model y = group time group*time / s chisq;
repeated time / type=un subject=id r;
run;
* linear trend;
proc mixed data=tlc noclprint=10 order=data;
class id group t;
model y = group time group*time / s chisq;
repeated t / type=un subject=id r;
run;
data tlc;
set tlc;
timesq=time*time;
timesq_c=(time-2.75)*(time-2.75);
time_4=max(time-4,0); * for spline;
run;
* quadratic trend- please compute centered time first;
proc mixed data=tlc noclprint=10 order=data;
class id group t;
model y = group time timesq_c group*time group*timesq_c/ s chisq;
repeated t / type=un subject=id r;
run;
* spline or piece wise linear with single knot at time=4 weeks;
proc mixed data=tlc noclprint=10 order=data;
class id group t;
model y = group time time_4 group*time group*time_4/ s chisq;
repeated t / type=un subject=id r;
run;

* modeling BASELINE data;
*Analysis of Response Profiles assuming Equal Mean Response at Baseline	;
*approach 1: exclude group;
proc mixed data=tlc noclprint=10 order=data;
class id group time;
model y =  time group*time / s chisq;
repeated time / type=un subject=id r;
run;

*approach2;
data tlc;
     set tlc;
 
********************************************************;
*   Create dummy variables for group and time   *;
********************************************************;
succimer=(group='A');
array t(4) t0 t1 t4 t6;
     j=0;
     do i = 0,1,4,6;
          j+1;
          t(j)=(time=i); *dummy for time;
     end;
     drop i j;
run;

*same as approach 1;
proc mixed noclprint=10 order=data; 
     class id time;
     model y = t1 t4 t6 succimer*t1 succimer*t4 succimer*t6 / s chisq;
     repeated time / type=un subject=id r;
run;

*approach 3: Analysis of Response Profiles of Changes in Response from Baseline	;
data tlc;
     infile 'tlc.dat';
     input id group $ lead0 lead1 lead4 lead6;
     y=lead1; time=1; baseline=lead0; output;
     y=lead4; time=4; baseline=lead0; output;
     y=lead6; time=6; baseline=lead0; output;
     drop lead0 lead1 lead4 lead6;

data tlc;
     set tlc;
change=y - baseline;

********************************************************;
*   Create dummy variables for group and time   *;
********************************************************;

succimer=(group='A');
array t(3) t1 t4 t6;
     j=0;
     do i = 1,4,6;
          j+1;
          t(j)=(time=i); * this takes values of 1 if time=i and 0 otherwise;
     end;

     drop i j;
 
title1 Analysis of Response Profiles of Changes from Baseline;
title2 Treatment of Lead Exposed Children (TLC) Trial;
 

proc mixed noclprint=10 order=data; 
     class id time;
     model change = succimer t4 t6  succimer*t4 succimer*t6 / s chisq;
     repeated time / type=un subject=id r;
     contrast '3 DF Test of Main Effect and Interaction'  
          succimer 1, succimer*t4 1, succimer*t6 1 / chisq;

run;

*Analysis of Response Profiles of Adjusted Changes in Response from Baseline;
 
data tlc;

     infile 'tlc.dat';
     input id group $ lead0 lead1 lead4 lead6;
     y=lead1; time=1; baseline=lead0; output;
     y=lead4; time=4; baseline=lead0; output;
     y=lead6; time=6; baseline=lead0; output;
     drop lead0 lead1 lead4 lead6;

data tlc;
     set tlc;
change=y - baseline;
cbaseline=baseline - 26.406; * centered baseline response;

********************************************************;
*   Create dummy variables for group and time   *;
********************************************************;
succimer=(group='A');
array t(3) t1 t4 t6;
     j=0;
     do i = 1,4,6;
          j+1;
          t(j)=(time=i);
     end;
     drop i j;
 
title1 Analysis of Response Profiles of Adjusted Changes from Baseline;
title2 Treatment of Lead Exposed Children (TLC) Trial;
 proc mixed noclprint=10 order=data; 
     class id time;
     model change = cbaseline succimer t4 t6  succimer*t4 succimer*t6 / s chisq;
     repeated time / type=un subject=id r;
     contrast '3 DF Test of Main Effect and Interaction'  
          succimer 1, succimer*t4 1, succimer*t6 1 / chisq;

run;



