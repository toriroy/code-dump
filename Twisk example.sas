data short;
input id group $ time1 time2 time3 time4;
datalines;
1  A 31 29 15 26
2  A 24 28 20 32
3  A 14 20 28 30
4  B 38 34 30 34
5  B 25 29 25 29
6  B 30 28 16 34
;

data short;
set short;
meany=mean(of time1 time2 time3 time4);
run;

data long (keep=id group time score meany);
set short;
time=1; score=time1; output;
time=2; score=time2; output;
time=3; score=time3; output;
time=4; score=time4; output;
run;

goptions reset=global ;
symbol i=join  ; 
axis1 label=( "score") c=black;
axis2 label=( "time") c=black;
legend1 label=none ;
Proc gplot data=long;
	plot (score)*time=id/overlay legend=legend1  haxis=axis2 vaxis=axis1;
Run;


proc mixed data=long;
class id time;
model score=time;
repeated/type=un subject=id sscp rcorr;
ods output covparms=cov;
ods output rcorr=corr;
run;

data times;
do time1=1 to 4;
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

axis1 value=(font=swiss2 h=2) label=(angle=90 f=swiss h=2 'Covariance of between Subj effects');
axis2 value=(font=swiss h=2) label=(f=swiss h=2 'Distance');
legend1 value=(font=swiss h=2) label=(f=swiss h=2 'From Time');
symbol1 color=black interpol=join line=1 value=square;
symbol2 color=black interpol=join line=2 value=circle;
symbol3 color=black interpol=join line=20 value=triangle;
symbol4 color=black interpol=join line=4 value=star;

proc gplot data=covplot;
plot estimate*dist=time2/vaxis=axis1 haxis=axis2 legend=legend1;
run;


*** Strategy4: summary approach;
* simple mean;
proc glm data=short;
class group;
model meany=group;
LSMEANS group;
run;

* polynomial approach;
proc glm data=short;
class group;
model time1 time2 time3 time4=group/nouni;
repeated time 4 (1 2 3 4) polynomial/printe summary;
LSMEANS group;
run;

* strategy5: Mixed models approach;
* comparing linear trend with quadratic trend and looking whether that changes by group;
* first creat a duplicate of time variable;
data long;
set long;
timec=time;
run;

proc mixed data=long;
class id timec group;
model score=group time group*time;
repeated timec /subject=id type=UN;
run;

proc mixed data=long;
class id timec group;
model score=group time group*time time*time time*time*group;
repeated timec/subject=id type=UN;
run;

*ploting LSmeans;
proc glimmix data=long method=quad;
class id time group;
model score=group time group*time;
random _residual_/subject=id;
LSMEANS group*time/diff=anom plot=anom; *requests an analysis of means display in which least squares means are compared to an average least squares mean.;
LSMEANS group*time/plot=meanplot(sliceby=group join) CL; *requests a plot in which the levels of time are on horizontal axis and means of same group are joined by lines;
run;

*testing UN versus independent covariance structures;
/* The null LRT, if significant indicates that the unstructured covariance matrix is preferred to the diagonal matrix of the ordinary least squares null model. 
The degrees of freedom for this test is difference between 10 (sigma2 and 9 covariances) and the 1 parameter for the null model’s diagonal matrix. 
*/
proc mixed data=long covtest asycov;
class id time group;
model score=group time group*time;
repeated time/type=UN subject=id;
run;
