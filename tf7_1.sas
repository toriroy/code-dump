filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\actg320.dat';
data actg320;
infile aaa;
input id time censor time_d censor_d tx txgrp strat2 sex raceth ivdrug hemophil karnof cd4 priorzdv age;
run;


data actg320_t71;
set actg320;
ivdrug_d = ivdrug>1;
karnof_70=(karnof=70);
karnof_80=(karnof=80);
karnof_90=(karnof=90);
karnof_70_80=(karnof=70 or karnof=80);
* create stratified cd4 variable based on the output of the proc means above;
cd4_q = 1;
if cd4>23 & cd4<=74.5 then cd4_q=2;
if cd4>74.5 & cd4<=136.5 then cd4_q=3;
if cd4>136.5 then cd4_q=4;
run;


data cov0;
  tx =0;
  ivdrug_d =0;
  karnof_70_80 =0;
  karnof_90 = 0;
  age = 0;
run;
proc phreg data = actg320_t71;
model time*censor(0) = tx ivdrug_d karnof_70_80 karnof_90 age;
strata cd4_q;
output out=fig71_a xbeta=p;
baseline covariates = cov0 out = b0 survival = surv / nomean;
run;
data t;
  set fig71_a;
  p1 = p - tx*(-0.66777);
run;
proc means data = t median;
  class cd4_q;
  var p1;
  output out=tcd4 (where = (_type_=1)) median = median;
run;
proc sql;
  select median into  :md1 -:md4
from tcd4;
quit;

data fig71;
  set b0;
  s10 = surv**exp(&md1); /*cd4=1 and tr=0*/
  s20 = surv**exp(&md2); /*cd4=2 and tr=0*/
  s30 = surv**exp(&md3); /*cd4=3 and tr=0*/
  s40 = surv**exp(&md4); /*cd4=4 and tr=0*/

  s11 = surv**exp(&md1 -0.66777); /*cd4=1 and tr=1*/
  s21 = surv**exp(&md2 -0.66777); /*cd4=2 and tr=1*/
  s31 = surv**exp(&md3 -0.66777); /*cd4=3 and tr=1*/
  s41 = surv**exp(&md4 -0.66777); /*cd4=4 and tr=1*/
 run;
proc sort data = fig71;
 by cd4_q time;
run;

goptions reset=all htext = 2 htitle = 3;
axis1 order=(.8 to 1 by .05) label=(a=90 'Adjusted Survival Function') minor=none;
axis2 order=(0 to 400 by 100) label=('Time') minor=none;
symbol1 i=stepjll v=none c=black line=14;
symbol2 i=stepjll v=none c=black line=1;
proc gplot data = fig71 ;
   where cd4_q=1;
   plot(s10 s11)*time /overlay vaxis=axis1 haxis=axis2 name="q1" noframe;
   title "CD4 Quartile 1";
run;
quit;

goptions reset=all htext = 2 htitle = 3;
axis1 order=(.8 to 1 by .05) label=(a=90 'Adjusted Survival Function') minor=none;
axis2 order=(0 to 400 by 100) label=('Time') minor=none;
symbol1 i=stepjll v=none c=black line=14;
symbol2 i=stepjll v=none c=black line=1;
proc gplot data = fig71;
   where cd4_q=2;
   plot(s10 s11)*time /overlay vaxis=axis1 haxis=axis2 name="q2" noframe;
   title "CD4 Quartile 2";
run;
quit;

goptions reset=all htext = 2 htitle = 3;
axis1 order=(.9 to 1 by .025) label=(a=90 'Adjusted Survival Function') minor=none;
axis2 order=(0 to 400 by 100) label=('Time') minor=none;
symbol1 i=stepjll v=none c=black line=14;
symbol2 i=stepjll v=none c=black line=1;
proc gplot data = fig71;
   where cd4_q=3;
   plot(s10 s11)*time /overlay vaxis=axis1 haxis=axis2 name="q3" noframe;
   title "CD4 Quartile 3";
run;
quit;

* quantile 4 htext = 2 htitle = 3;
goptions reset=all htext = 2 htitle = 3;
axis1 order=(.9 to 1 by .025) label=(a=90 'Adjusted Survival Function') minor=none;
axis2 order=(0 to 400 by 100) label=('Time') minor=none;
symbol1 i=stepjll v=none c=black line=14;
symbol2 i=stepjll v=none c=black line=1;
proc gplot data = fig71;
   where cd4_q=4;
   plot(s10 s11)*time /overlay vaxis=axis1 haxis=axis2 name="q4" noframe;
   title "CD4 Quartile 4";
run;
quit;


proc greplay igout=work.gseg tc=sashelp.templt template=l2r2 nofs;
treplay 1:q1 2:q3 3:q2 4:q4;
run;
quit;
