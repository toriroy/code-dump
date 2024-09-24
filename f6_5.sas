

filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdateHospital$ disdate$ fdate$ los dstat lenfol fstat;
bmi12 = bmi**(-2);
bmifp1 = (bmi/10)**2;
bmifp2 = (bmi/10)**3;
ga=gender*age;
run;
proc print data=whas500;
var lenfol bmi;
run;

proc phreg data = whas500 ;
model lenfol*fstat(0) = bmifp1 bmifp2 age hr diasbp gender chf ga;
id id;
output out=f64 ressco = bmifp1_r bmifp2_r age_r hr_r diasbp_r gender_r chf_r ga_r;
run;
proc print data=f64;
var bmifp1;
run;
proc sort data = whas500;
by id;
run;

proc sort data = f64;
by id;
run;

data f64m;
merge whas500 f64;
by id;
run;
***EMPTY GRAPHICS CATALOG;
proc greplay nofs igout=gseg;
delete _all_;
run;
quit;

goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-80 to 20 by 20) label=(a=90 'Score Residuals') minor=none;
axis2 order=(20 to 100 by 20) label=('Age (Years)') minor=none;
title 'Figure 6.5a';
proc gplot data = f64;
plot age_r*age / vaxis = axis1 haxis = axis2 name = "f65a" noframe;
run;
quit;

goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-200 to 200 by 100) label=(a=90 'Score Residuals') minor=none;
axis2 order=(20 to 100 by 20) label=('Age (Years)') minor=none;
title 'Figure 6.5b';
proc gplot data = f64;
plot ga_r*age / vaxis = axis1 haxis = axis2 name = "f65b" noframe;
run;
quit;

goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-3 to 2 by 1) label=(a=90 'Score Residuals') minor=none;
axis2 offset=(4 cm, 4 cm) value=('No' 'Yes') order=(0 1) label=('Congestive Heart Complications') minor=none;
title 'Figure 6.5c';
proc gplot data = f64;
plot chf_r*chf / vaxis = axis1 haxis = axis2 name = "f65c" noframe;
run;
quit;

goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-2 to 2 by 1) label=(a=90 'Score Residuals') minor=none;
axis2 offset=(4 cm, 4 cm) value=('Male' 'Female') order=(0 1) label=('Gender') minor=none;
title 'Figure 6.5d';
proc gplot data = f64;
plot gender_r*gender / vaxis = axis1 haxis = axis2 name = "f65d" noframe;
run;
quit;

goptions reset=all;
proc greplay igout=work.gseg tc=sashelp.templt template=l2r2 nofs;
treplay 1:f65a 2:f65c 3:f65b 4:f65d;
run;
quit;
