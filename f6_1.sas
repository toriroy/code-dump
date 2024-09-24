

filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdateHospital$ disdate$ fdate$ los dstat time fstat;
bmifp1=bmi*bmi;
bmifp2=bmi*bmi*bmi;
ga=gender*age;
time=time/365.25;
run;


proc sql noprint;
  select sum(fstat) into :total
  from whas500;
quit;

proc phreg data = whas500 outest=est61 covout;
model time*fstat(0) = bmifp1 bmifp2 age hr diasbp gender chf ga;
id id;
output out=t61 ressch = bmifp1_r bmifp2_r age_r hr_r diasbp_r gender_r chf_r ga_r;
run;
proc means data = t61;
var bmifp1_r bmifp2_r age_r hr_r diasbp_r gender_r chf_r ga_r;
run;

ods output ProductLimitEstimates=d61;
proc lifetest data = t61;
time time*fstat(0);
id bmifp1_r bmifp2_r age_r hr_r diasbp_r gender_r chf_r ga_r;
run;
data d61_a;
  set d61;
  if censor = 0;
  logtime = log(time);
run;

proc iml;
  use d61_a;
  read all variables {bmifp1_r bmifp2_r age_r hr_r diasbp_r gender_r chf_r ga_r} into L;
  read all variables {time logtime survival censor } into X;
  use est61;
  read all  var {bmifp1 bmifp2 age hr diasbp gender chf ga} into V
      where (_type_ = "COV");
  ssr =  (&total)*L*V;
  W = X || ssr;
  create fig61_b var {time logtime survival censor  sbmifp1_r sbmifp2_r sage_r shr_r sdiasbp_r sgender_r schf_r sga_r};
  append from W;
quit;
***EMPTY GRAPHICS CATALOG;
proc greplay nofs igout=gseg;
delete _all_;
run;
quit;
proc print data=fig61_b;
run;
* figure 6.1 (a);
goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-.1 to .15 by .05) label=(a=90 'Scaled Schonefeld Residuals') minor=none;
axis2 order=(-6 to 2 by 2) label=('Log Time') minor=none;
title 'Figure 6.1a';
proc gplot data = fig61_b;
plot shr_r*logtime / vaxis = axis1 haxis = axis2 name = "fig61a" noframe;
run;
quit;

* figure 6.1 (b);
goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-.1 to .15 by .05) label=(a=90 'Scaled Schonefeld Residuals') minor=none;
axis2 order=(0 to 8 by 2) label=('Time') minor=none;
title 'Figure 6.1b';
proc gplot data = fig61_b;
plot shr_r*time / vaxis = axis1 haxis = axis2 name = "fig61b" noframe;
run;
quit;

* figure 6.1 (c);
goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-.1 to .15 by .05) label=(a=90 'Scaled Schonefeld Residuals') minor=none;
axis2 order=(0 to 1 by .2) label=('Kaplan-Meier Estimate') minor=none;
title 'Figure 6.1c';
proc gplot data = fig61_b;
plot shr_r*survival / vaxis = axis1 haxis = axis2 name = "fig61c" noframe;
run;
quit;

* figure 6.1 (d);
proc rank data = fig61_b out=fig61_b_ranked;
var time;
run;

goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-.1 to .15 by .05) label=(a=90 'Scaled Schonefeld Residuals') minor=none;
axis2 order=(0 to 250 by 50) label=('Rank of Time') minor=none;
title 'Figure 6.1d';
proc gplot data = fig61_b_ranked;
plot shr_r*time / vaxis = axis1 haxis = axis2 name = "fig61d" noframe;
run;
quit;
title;

goptions reset=all;
proc greplay igout=work.gseg tc=sashelp.templt template=l2r2 nofs;
treplay 1:fig61a 2:fig61c 3:fig61b 4:fig61d;
run;
quit;
