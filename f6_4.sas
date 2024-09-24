

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
proc print data=f64m;
var bmifp1_r bmi hr_r;
run;
goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-10 to 15 by 5) label=(a=90 'Score Residuals') minor=none;
axis2 order=(10 to 50 by 10) label=('Body Mass Index (kg/m^2)') minor=none;
title 'Figure 6.4a';
proc gplot data = f64m;
plot bmifp1_r*bmi / vaxis = axis1 haxis = axis2 name = "f64a" noframe;
run;
quit;

goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-40 to 60 by 20) label=(a=90 'Score Residuals') minor=none;
axis2 order=(10 to 50 by 10) label=('Body Mass Index (kg/m^2)') minor=none;
title 'Figure 6.4b';
proc gplot data = f64m;
plot bmifp2_r*bmi / vaxis = axis1 haxis = axis2 name = "f64b" noframe;
run;
quit;

goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-100 to 150 by 50) label=(a=90 'Score Residuals') minor=none;
axis2 order=(0 to 200 by 50) label=('Heart Rate (Beats/Min)') minor=none;
title 'Figure 6.4c';
proc gplot data = f64;
plot hr_r*hr / vaxis = axis1 haxis = axis2 name = "f64c" noframe;
run;
quit;

goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-100 to 150 by 50) label=(a=90 'Score Residuals') minor=none;
axis2 order=(0 to 200 by 50) label=('Diastolic Blood Pressure (mmHg)') minor=none;
title 'Figure 6.4d';
proc gplot data = f64;
plot diasbp_r*diasbp / vaxis = axis1 haxis = axis2 name = "f64d" noframe;
run;
quit;

goptions reset=all;
proc greplay igout=work.gseg tc=sashelp.templt template=l2r2 nofs;
treplay 1:f64a 2:f64c 3:f64b 4:f64d;
run;
quit;
