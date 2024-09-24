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

  * spaghetti plot using Proc SGPANEL;
  TITLE 'Observed change score Data, All Subjects';
  PROC SGPANEL NOAUTOLEGEND DATA=stren;
  PANELBY trt;
  where time ne 0;
  SERIES X=t Y=cy / GROUP = id LINEATTRS = (THICKNESS=1);
  RUN;

ODS graphics on;
goptions reset=global ;
symbol1 i=join c=black r=17 ;  
symbol2 i=join c=red r=21 ;
axis1 label=( "y") ;
axis2 label=( "time") ;
legend1 label=none ;

Proc gplot data=stren;
	plot y*time=id/overlay legend=legend1  haxis=axis2 vaxis=axis1;
	by trt;
Run;
ods graphics off;

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


ods graphics on;
proc glimmix data=stren noclprint=2 ;
      class trt time id;
	  where time ne 0;
      model cy=time trt time*trt /solution covb; 
      random _residual_ / subject=id type=un;
	  lsmeans time*trt/ cl plot=meanplot(sliceby=trt join);
      label time ='time';
run;
ods graphics off;


*Visualizing correlation patterns graphically;

proc mixed data=stren;
class trt time id;
model y=trt|time;
repeated/type=un subject=id sscp rcorr;
ods output covparms=cov;
run;

*The following code sets up the dataset for producing the plot for visualizing correlation patterns;
data times;
do time1=1 to 5;
 do time2=1 to time1;
  dist=time1-time2;
  output;
  end;
  end;
  run;

data covplot;
  merge times cov;
  proc print;
run;
goptions reset=all;
axis1 value=(font=swiss2 h=2) label=(angle=90 f=swiss h=2 'Covariance of between Subj effects');
axis2 value=(font=swiss h=2) label=(f=swiss h=2 'Distance');
legend1 value=(font=swiss h=2) label=(f=swiss h=2 'From Time');
symbol1 color=black interpol=join line=1 value=square;
symbol2 color=blue interpol=join line=2 value=circle;
symbol3 color=red interpol=join line=20 value=triangle;
symbol4 color=green interpol=join line=4 value=star;
symbol5 color=blue interpol=join line=4 value=star;
proc gplot data=covplot;
plot estimate*dist=time2/vaxis=axis1 haxis=axis2 legend=legend1;
run;

* Normality test;
** run proc glm for each y;
proc sort data=stren;
by time;
run;

ods graphics on;
proc glm data=stren;
class group time;
by time;
model y=group;
output out=resid2 r=res2;
run;

proc univariate data=resid2 normal;
var res2;
by time;
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
* model3-VC for R and with random term;
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
*linear;
proc mixed data = stren empirical;
class id trt t;
model y=trt time trt*time / s chisq;
repeated t / type=sp(exp)(time) subject=id r;
run;
proc mixed data = stren empirical;
class id trt ;
model y=trt time trt*time / s chisq outp=predict;
random intercept time/s type=un subject=id g v vcorr; * s provides the solution for the Empirical Bayes predicted values;
run;

* We can plot the predicted values against the actual values of y;
proc sort data=predict;
  by time;
run;
goptions reset=all;
symbol1 c=blue  v=star   h=.8 i=j      w=10;
symbol2 c=red   v=dot    h=.8 i=j      w=10;
symbol3 c=blue  v=star   h=.8 i=j      r=10;
symbol4 c=red   v=dot    h=.8 i=j      r=10;
axis1 order=(60 to 150 by 30) label=(a=90 'Predicted and Observed resp');
proc gplot data=predict;
  plot pred*time=trt / vaxis=axis1 ;
  plot2 y*time = id   / vaxis=axis1 ;
run;
quit;

*you can also use these to checking normality***;
ods graphics on;
proc mixed data=stren plots(only)=(
          ResidualPanel(marginal box)
          StudentPanel(marginal box));
class id trt time;
model y=trt time trt*time/S outp=predict residual ddfm=kr;
repeated/type=ar(1) subject=id  rcorr;
run;
ods graphics off;


*** Analyzing equally spaced intervals***********;
* Recall that the 5 measurement occasions (0, 4, 6, 8, and 12) are unequally spaced;
data stren2;
infile 'I:\bmtry702\Resources\fitxmaurice book\exercise.txt';
     input id group y0 y2 y4 y6 y8 y10 y12;
time=0; ctime=0; y=y0; t=1; output;
time=2; ctime=2; y=y2; t=1.5; output;
time=4; ctime=4; y=y4; t=2; output;
time=6; ctime=6; y=y6; t=3; output;
time=8; ctime=8; y=y8; t=4; output;
time=10; ctime=10; y=y10; t=4.5; output;
time=12; ctime=12; y=y12; t=5; output;
drop y0 y2 y4 y6 y8 y10 y12;
run;

data stren2;
set stren2;
if time eq 2 or time eq 10 then delete;
trt=group;
run;
* PARAMETRIC CURVES;
* Empirical or robust standard error;
* compare with model based variance estimates;
*linear;
proc mixed data = stren empirical;
class id trt t;
model y=trt time trt*time / s chisq;
repeated t / type=sp(exp)(time) subject=id r;
run;
*quadratic;
proc mixed data = stren2;
class id trt t;
model y=trt time trt*time time*time time*time*trt / s chisq;
repeated t / type=sp(exp)(ctime) subject=id r rcorr;
run;

** LMM;
*testing for constant variance assumption: they are different;
proc glimmix data=stren asycov ;
class group time id;
model y=time group time*group /solution covb; 
random _residual_/type=un group=group subject= id g;
covtest 'Common Variance by time' homogeneity; * constant variance test;
run;

proc glimmix data=stren asycov ;
class group  id;
model y=time group time*group /solution covb; 
random int time/type=un group=group subject= id g;
*covtest 'Common Variance by group' homogeneity; * common covariance matrix by group;
run;

proc glimmix data=stren asycov ;
class group time id;
model y=time group time*group /solution covb; 
random int/ subject= id;
*covtest 'Common Variance by group' homogeneity;
run;
proc glimmix data=stren asycov ;
class group time id;
model y=time group time*group /solution covb; 
random _residual_/group=time ;
covtest 'Common Variance over time' homogeneity;
*nloptions technique=none;
run;

*testing whether two G matrices are equal;
proc glimmix data=stren asycov ;
class group time id;
model y=time group time*group /solution covb; 
random intercept time /type=un group=group subject= id g;
covtest 'Common Variance by time' homogeneity; * constant variance test;
run;

