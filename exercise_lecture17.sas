/*
Subset of Data from Exercise Therapy Study.

Source: Adapted from Table (Output) 6.1 (page 176) of Freund, Littell and Spector (1986). 
Reproduced with permission of SAS Institute, Inc., Cary, NC.

Reference: Freund, R.J., Littell, R.C. and Spector, P.C. (1986). 
SAS Systems for Linear Models, Cary, NC: SAS Institute Inc.

Description:

The data are from a study of exercise therapies, where 37 patients 
were assigned to one of two weightlifting programs. In the first program (treatment 1), 
the number of repetitions was increased as subjects became stronger. In the
second program (treatment 2), the number of repetitions was fixed but the amount 
of weight was increased as subjects became stronger. Measures of strength were taken
at baseline (day 0), and on days 2, 4, 6, 8, 10, and 12.

Variable List:

ID, PROGRAM (1=Repetitions Increase; 2=Weights Increase), Response at Time 1,
Response at Time 2, Response at Time 3, Response at Time 4, Response at Time 5,
Response at Time 6, Response at Time 7.

     
*/;

*focus only on measures of strength taken at baseline (day 0) and on days 4, 6, 8, and 12;
data stren;
infile 'I:\bmtry702\bmtry702\Resources\fitxmaurice book\exercise.txt';
     input id group y0 y2 y4 y6 y8 y10 y12;
time=0; y=y0; t=1; output;
time=2; y=y2; t=1.5; output;
time=4; y=y4; t=2; output;
time=6; y=y6; t=3; output;
time=8; y=y8; t=4; output;
time=10; y=y10; t=4.5; output;
time=12; y=y12; t=5; output;
drop y2 y4 y6 y8 y10 y12;
run;


data forglm2(keep=id group y0 y2 y4 y6 y8 y10 y12)
formixed2(keep=id group time t y y0);
infile 'I:\bmtry702\bmtry702\Resources\fitxmaurice book\exercise.txt';
input id group y0 y2 y4 y6 y8 y10 y12;
output forglm2;
time=0; y=y0; t=1; output formixed2;
time=2; y=y2; t=1.5; output formixed2;
time=4; y=y4; t=2; output formixed2;
time=6; y=y6; t=3; output formixed2;
time=8; y=y8; t=4; output formixed2;
time=10; y=y10; t=4.5; output formixed2;
time=12; y=y12; t=5; output formixed2;
run;

proc corr data=forglm2;
var y0 y4 y6 y10 y12;
run;

data stren;
set stren;
if time eq 2 or time eq 10 then delete;
trt=group;
cy=y-y0;
timec=time;
run;
*** Three plots ********;
proc sort data=stren;
by trt;
run;

* spaghetti plot using Proc SGPANEL;
  TITLE 'Observed Data, All Subjects';
  PROC SGPANEL NOAUTOLEGEND DATA=stren;
  PANELBY trt;
  * observed trends;
  SERIES X=t Y=y / GROUP = id LINEATTRS = (THICKNESS=1);
  RUN;

*plot of means;
ods graphics on;
proc glimmix data=stren noclprint=2 ;
      class trt time id;
      model y=time trt time*trt /solution covb; 
      random _residual_ / subject=id type=un;
	  lsmeans time*trt/ cl plot=meanplot(sliceby=trt join);
      label time ='time';
run;
ods graphics off;

*covariance pattern models: number of covariance parameters increase with time points and could lead to inefficieny;
* fitting models under UN, AR(1), ARH(1) and SP(1);
proc mixed data = stren;
class id trt time ;
model y=trt time trt*time / s chisq;
repeated time / type=un subject=id r rcorr;
run;

proc mixed data = stren;
class id trt time ;
model y=trt time trt*time / s chisq;
repeated time / type=ar(1) subject=id r rcorr;
run;

proc mixed data = stren;
class id trt time;
model y=trt time trt*time / s chisq;
repeated time / type=arh(1) subject=id r rcorr;
run;

proc mixed data = stren;
class id trt time;
model y=trt time trt*time / s chisq;
repeated time / type=sp(exp)(timec)  subject=id r rcorr;
run;

** effect of DDFM - defult is between-within;
proc mixed data = stren;
class id trt time;
model y=trt time trt*time / s chisq ddfm=kr;
repeated time / type=sp(exp)(timec)  subject=id r rcorr;
run;

proc mixed data = stren;
class id trt time;
model y=trt time trt*time / s chisq ddfm=kr(firstorder);
repeated time / type=sp(exp)(timec)  subject=id r rcorr;
run;

proc mixed data = stren;
class id trt time;
model y=trt time trt*time / s chisq ddfm=satterth;
repeated time / type=sp(exp)(t)  subject=id r rcorr;
run;
proc mixed data = stren;
class id trt time;
model y=trt time trt*time / s chisq ddfm=residual;
repeated time / type=sp(exp)(time)  subject=id r rcorr;
run;

*** Parametric curves and random coefficient models****;
* model1-random intercept;
proc mixed data = stren;
class id trt ;
model y=trt time trt*time / s chisq;
random intercept / type=UN subject=id g v vcorr;
run;
* model2-random slope and intercept;
proc mixed data = stren;
class id trt ;
model y=trt time trt*time / s chisq;
random intercept time/ type=un subject=id g v vcorr;
run;
proc mixed data = stren;
class id trt ;
model y=trt time trt*time / s chisq;
random intercept time/ group=trt type=un subject=id g v vcorr;
run;
* model3-VC for R and with random term;\
proc mixed data = stren;
class id trt t;
model y=trt time trt*time / s chisq;
random intercept time/  subject=id g v vcorr;
run;
proc mixed data = stren;
class id trt t;
model y=trt time trt*time / s chisq;
repeated t / type=vc subject=id r; * it may not fit with Type=UN;
random intercept time/  subject=id g v vcorr;
run;

proc mixed data = stren;
class id trt t;
model y=trt time trt*time / s chisq;
repeated t / type=cs subject=id r; * it may not fit with Type=UN;
random intercept time/  subject=id g v vcorr;
run;

* model4-CS for R and no random term is equivalent to model1;
proc mixed data = stren;
class id trt t;
model y=trt time trt*time / s chisq;
repeated t / type=cs subject=id r;
run;

* model5-random slope and intercept wih repeated statement;
proc mixed data = stren;
class id trt t ;
model y=trt time trt*time / s chisq;
repeated t / type=cs subject=id r;
random intercept time/ type=un subject=id g v vcorr;
run;
* prediction: random slope and intercept;
proc mixed data = stren;
class id trt ;
model y=trt time trt*time / s chisq outp=predict;
random intercept time/s type=un subject=id g v vcorr; * s provides the solution for the Empirical Bayes predicted values;
run;

proc print data=predict;
var id trt time y Pred StdErrPred Resid;
run;

* Empirical or robust standard error;
* compare with model based variance estimates;
* model based variance;
proc mixed data = stren ;
class id trt timec;
model y=trt time trt*time / s chisq;
repeated timec / type=sp(exp)(timec) subject=id r;
run;
* empirical variance;
proc mixed data = stren empirical;
class id trt timec;
model y=trt time trt*time / s chisq;
repeated timec / type=sp(exp)(timec) subject=id r;
run;

*random intercept and slope;
* model based variance;
proc mixed data = stren ;
class id trt ;
model y=trt time trt*time / s chisq outp=predict;
random intercept time/type=un subject=id g v vcorr; * s provides the solution for the Empirical Bayes predicted values;
run;
* empirical variance;
proc mixed data = stren empirical;
class id trt ;
model y=trt time trt*time / s chisq outp=predict;
random intercept time/type=un subject=id g v vcorr; * s provides the solution for the Empirical Bayes predicted values;
run;


* influence and residual analysis for the best model;
* Cooks D and PRESS statistics;
proc mixed data=stren method=ml
           plots(only)=InfluenceEstPlot plots=Influencestatpanel;
   class id trt ;
model y=trt time trt*time/
                    influence(iter=5 effect=person est);
random intercept time / type=un group=trt subject=id;
run;

* residual analysis;
ods graphics on;
proc mixed data=stren method=ml
      plot=boxplot(observed marginal conditional subject)
       plots=(ResidualPanel(marginal) ResidualPanel(conditional) StudentPanel(marginal) StudentPanel(conditional));
   class id trt ;
   model y=trt time trt*time/s outpm=residoutput outp=meanpredvalues ;
   random intercept time / type=un group=trt subject=id g;
   *ods output gmatrix=g;
run;

ods graphics on;
PROC MIXED DATA=stren METHOD=reml covtest ;
  class id trt ;
  model y=trt time trt*time/s outpm=residoutput ;
   random intercept time / s type=un subject=id G V;
   ods output SolutionR=RandomEst;
RUN; 

proc sort data=RandomEst;
by Effect;
run;
ods rtf style=journal;
proc univariate data = RandomEst;
	var estimate;
	histogram/normal;
   	qqplot estimate/normal(mu=0 sigma=1);
	by Effect;
	run;
ods rtf close;

ods rtf style=journal;
proc univariate data = RandomEst;
	var estimate;
	histogram/normal(mu=0 sigma=est);
   	qqplot estimate/normal(mu=0 sigma=est); * uses estimated variance;
	by Effect;
	run;
ods rtf close;

