/*
Subsample (N=100) of data on Blood Lead Levels from the 
Treatment of Lead Exposed Children (TLC) Trial.

Source: Data courtesy of Dr. George G. Rhoads (Chair, TLC Steering Committee).

Reference: Treatment of Lead-exposed Children (TLC) Trial Group. (2000).
Safety and Efficacy of Succimer in Toddlers with Blood Lead Levels of 
20-44 µg/dL.  Pediatric Research, 48, 593-599.

Description: 
The Treatment of Lead-Exposed Children (TLC) trial was a placebo-controlled, 
randomized study of succimer (a chelating agent) in children with blood 
lead levels of 20-44 micrograms/dL.
These data consist of four repeated measurements of blood lead 
levels obtained at baseline (or week 0), week 1, week 4, and 
week 6 on 100 children who were randomly assigned to chelation treatment 
with succimer or placebo.

Variable List: 
Each row of the data set contains the following 6 variables:

ID, Treatment Group, Lead Level Week 0, Lead Level Week 1, 
Lead Level Week 4, Lead Level Week 6. */;

data lead;
   infile 'I:\bmtry702\bmtry702\Resources\fitxmaurice book\tlc.txt';
   input id group $ lead0 lead1 lead4 lead6;
   trt=(group eq 'P');
   /*y=lead0; time=0; output;
   y=lead1; time=1; output;
   y=lead4; time=4; output;
   y=lead6; time=6; output;
   drop lead0 lead1 lead4 lead6; */
run;

data lead2;
   set lead;
   y=lead0; time=0; t=1; days=0; output;
   y=lead1; time=1; t=2; days=7; output;
   y=lead4; time=4; t=3; days=28; output;
   y=lead6; time=6; t=4; days=42; output;
   drop lead0 lead1 lead4 lead6;
run;
title1 Analysis of Response Profiles of data on Blood Lead Levels;
title2 Treatment of Lead Exposed Children (TLC) Trial;

proc corr data=lead cov;
     var lead0 lead1 lead4 lead6;
run;
proc means data=lead mean std;
class trt;
var lead0 lead1 lead4 lead6;
run;

proc means data=lead2 mean std;
*class time ;
var y;
run;

proc sort data=lead2;
by trt descending time;
run;
*** Plots for longitudinal data ***;
* Matrix plot;
* set ODS graphics to landscape mode and designate output PDF file;
OPTIONS ORIENTATION=LANDSCAPE;
ODS GRAPHICS ON;
TITLE 'Lead Exposure Data';
        PROC SGSCATTER DATA=lead;
        MATRIX lead0 lead1 lead4 lead6 / DIAGONAL=(HISTOGRAM KERNEL);
RUN;
* spaghetti plot using Proc SGPANEL;
  TITLE 'Observed Data, All Subjects';
  PROC SGPANEL NOAUTOLEGEND DATA=lead2;
  PANELBY trt;
  * observed trends;
  SERIES X=time Y=y / GROUP = id LINEATTRS = (THICKNESS=1);
  RUN;
 * mean plots;
TITLE 'Means across Ages by treatment';
PROC SGPLOT DATA=lead2;
   * mean trends;
   VLINE time /RESPONSE=y STAT=MEAN 
   GROUP=trt LINEATTRS=(THICKNESS=2) MARKERS MARKERATTRS=(SIZE=2MM) DATALABEL;
RUN;

*plot of means;
ods graphics on;
proc glimmix data=lead2 noclprint=2 ;
      class trt days id;
      model y=days trt days*trt /solution covb ddfm=kr; 
      random _residual_ / subject=id type=un;
	  lsmeans days*trt/ cl plot=meanplot(sliceby=trt join);
      label days ='time in days';
run;
ods graphics off;

*are patterns of change the same in the placebo and succimer groups?;
*profile analysis with UN;
*observations from covariance matrix: increase in variability from baseline to post baseline;
proc mixed data=lead2 noclprint=10 order=data;
class id trt time;
model y = trt time trt*time / s chisq;
repeated time / type=un subject=id r;
run;

*profile analysis with CS;
proc mixed data=lead2 noclprint=10 ;
class id trt time;
model y = trt time trt*time / s chisq;
repeated time / type=cs subject=id r;
run;

*profile analysis with ML;
proc mixed data=lead2 method=ml noclprint=10 ;
class id trt time;
model y = trt time trt*time / s chisq;
repeated time / type=un subject=id r;
run;

*a simpler model with no group effect that forces both groups to have same baseline means;
proc mixed data=lead2 noclprint=10 order=data ;
class id trt time;
model y = time trt*time / s chisq;
repeated time / type=un subject=id r;
run;

* with spatial correlation - exponentail correlation;

proc mixed data=lead2 noclprint=10 order=data ;
class id trt time;
model y = time trt trt*time / s chisq;
repeated time / type=sp(exp)(time) subject=id r;
run;

proc mixed data=lead2 noclprint=10 order=data;
class id trt time;
model y = trt time trt*time / s chisq;
repeated time / type=un subject=id r;
* here include all the (2x4=8) terms involving trt*time interaction;
estimate 'Trt*Time 1' trt*time -1 1 0 0 1 -1 0 0 / e;*Pt1 Pt2 Pt3 Pt4 At1 At2 At3 At4=At1-Pt1 + Pt2-At2;
estimate 'Trt*Time 4' trt*time -1 0 1 0 1 0 -1 0/e;
estimate 'Trt*Time 6' trt*time -1 0 0 1 1 0 0 -1/e;
* using F test which is equivalent to t-square of the above t tests;
contrast 'Trt*Time 1' trt*time -1 1 0 0 1 -1 0 0 / e;
contrast 'Trt*Time 4' trt*time -1 0 1 0 1 0 -1 0/e;
contrast 'Trt*Time 6' trt*time -1 0 0 1 1 0 0 -1/e;
* main effect comparison;
estimate 'Trt' trt -1 1  / e;
estimate 'Trt' trt -1 1 trt*time  / e;
estimate 'time 1 vs 4' time -1 0 0 1 /e;
estimate 'time 2 vs 4' time 0 -1 0 1 /e;
estimate 'time 3 vs 4' time 0 0 -1 1 /e;
run;
 
* regular spacing of time intervals;
data lead3 ;
set lead;
y=lead0; time=1; t=1; tc=-1.5; output; * tc is time centered;
y=lead1; time=2; t=2; tc=-0.5; output;
y=lead4; time=3; t=3; tc=0.50; output;
y=lead6; time=4; t=4; tc=1.50; output;
run;

proc sort data=lead3;
by trt descending t;
run;
*Parametric curves;
* to do parametric with irrgular intervals use data=lead2;
* to compare (using LR test) profile analysis and parametric analysis use method=ML;


*linear with regular time interval to compare it with ML profile analysis;
ods graphics on;
proc mixed data=lead3 method=REML;
class id trt t;
model y=trt time time*trt / s chisq;
repeated t / type=un subject=id r;
run;
ods graphics on;
proc mixed data=lead3 method=ml;
class id trt t;
model y=trt time time*trt / s chisq;
repeated t / type=un subject=id r;
run;
* it could be important to center time;
*quadratic with regular time interval;
proc mixed data=lead3 method=ml;
class id trt t;
model y=trt|time|time/ s chisq;
repeated t / type=un subject=id r;
run;

proc mixed data=lead3 method=ml;
class id trt t;
model y=trt|tc|tc/ s chisq;
repeated t / type=un subject=id r;
run;

*profile analysis with regular time intervals;
* note that writing time*trt and trt*time in the estimate statement makes a difference;
proc mixed data = lead3 method=ml;
class id trt time;
model y=trt time time*trt / s chisq;
repeated / type=un subject=id r;
estimate 'Trt*Time 1' time*trt -1 1 0 0 1 -1 0 0 / e;*Pt1 Pt2 Pt3 Pt4 At1 At2 At3 At4=At1-Pt1 + Pt2-At2;
estimate 'Trt*Time 1' trt*time -1 1 0 0 1 -1 0 0/e;* this also gives same estimate;
run;

*how about putting trt*time in the model statement;
proc mixed data = lead3 method=ml;
class id trt time;
model y=trt time trt*time / s chisq;
repeated / type=un subject=id r;
estimate 'Trt*Time 1' time*trt -1 1 0 0 1 -1 0 0 /e ; *Pt1 Pt2 Pt3 Pt4 At1 At2 At3 At4;
estimate 'Trt*Time 1' trt*time -1 1 0 0 1 -1 0 0/e; * this also gives same estimate;
run;

*how about putting order=data;
proc mixed data = lead3 method=ml order=data;
class id trt time;
model y=trt time trt*time / s chisq;
repeated / type=un subject=id r;
estimate 'Trt*Time 1' time*trt -1 1 0 0 1 -1 0 0 /e ; *Pt1 Pt2 Pt3 Pt4 At1 At2 At3 At4;
estimate 'Trt*Time 1' trt*time -1 1 0 0 1 -1 0 0/e; * this also gives same estimate;
run;

* spline aanalysis;
data spline;
set lead3;
st1=min(time, 2); *knot at time=2;
st2=max(0, time-2);
run;
proc mixed data = spline;
class id trt time;
model y=trt st1 st2 st1*trt st2*trt / s chisq;
repeated time/ type=un subject=id r;
run;


***** COmparing DDFM*******;
proc mixed data=lead2 noclprint=10 order=data;
class id trt time;
model y = trt time trt*time / s chisq ddfm=none; *NONE;
repeated time / type=un subject=id r;
run;
proc mixed data=lead2 noclprint=10 order=data;
class id trt time;
model y = trt time trt*time / s chisq ; *default;
repeated time / type=un subject=id r;
run;
proc mixed data=lead2 noclprint=10 order=data;
class id trt time;
model y = trt time trt*time / s chisq ddfm=residual;*Residual;
repeated time / type=un subject=id r;
run;
proc mixed data=lead2 noclprint=10 order=data;
class id trt ;
model y = trt time trt*time / s chisq ddfm=contain; *Contain;
random int time / type=un subject=id g;
run;
proc mixed data=lead2 noclprint=10 order=data;
class id trt ;
model y = trt time trt*time / s chisq ddfm=kr; *Kenward Rogers;
random int time / type=un subject=id g;
repeated  / type=AR(1) subject=id r;
run;

