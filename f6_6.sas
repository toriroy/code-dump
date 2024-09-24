

filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdateHospital$ disdate$ fdate$ los dstat lenfol fstat;
bmi12 = bmi**(-2);
bmifp1 = (bmi/10)**2;
bmifp2 = (bmi/10)**3;
ga=gender*age;
run;
* requires scaled score residuals which you can get from SAS with the dfbeta option on the output statement;
proc phreg data = whas500;
model lenfol*fstat(0) = bmifp1 bmifp2 age hr diasbp gender chf ga;
id id;
output out=fig66 resmart = mgale dfbeta = ssbmifp1_r ssbmifp2_r ssage_r sshr_r ssdiasbp_r ssgender_r sschf_r ssga_r;
run;


***EMPTY GRAPHICS CATALOG;
proc greplay nofs igout=gseg;
delete _all_;
run;
quit;

goptions reset = all htext = 2 htitle = 3;
data bmi;
set fig66;
bmi = sqrt(bmifp1)*10;
run;

* f6.6(a);
goptions reset=all; 
symbol v = dot;
axis1 order=(-.1 to .1 by .05) label=(a=90 'Scaled Score Residuals') minor=none;
axis2 order=(10 to 50 by 10) label=('Body Mass Index (kg/m^2)') minor=none;
title 'Figure 6.6a';
proc gplot data = bmi;
plot ssbmifp1_r*bmi / vaxis = axis1 haxis = axis2 name = "f66a" noframe;
run;
quit;

* f6.6(b);
goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-.02 to .02 by .01) label=(a=90 'Scaled Score Residuals') minor=none;
axis2 order=(10 to 50 by 10) label=('Body Mass Index (kg/m^2)') minor=none;
title 'Figure 6.6b';
proc gplot data = bmi;
plot ssbmifp2_r*bmi / vaxis = axis1 haxis = axis2 name = "f66b" noframe;
run;
quit;

* f6.6(c);
goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-.0008 to .0006 by .0002) label=(a=90 'Scaled Score Residuals') minor=none;
axis2 order=(0 to 200 by 50) label=('Heart Rate (Beats/Min)') minor=none;
title 'Figure 6.6c';
proc gplot data = bmi;
plot sshr_r*hr / vaxis = axis1 haxis = axis2 name = "f66c" noframe;
run;
quit;

* f6.6(d);
goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-.001 to .0015 by .0005) label=(a=90 'Scaled Score Residuals') minor=none;
axis2 order=(0 to 200 by 50) label=('Diastolic Blood Pressure (mmHg)') minor=none;
title 'Figure 6.6d';
proc gplot data = bmi;
plot ssdiasbp_r*diasbp / vaxis = axis1 haxis = axis2 name = "f66d" noframe;
run;
quit;
title;

goptions reset=all;
proc greplay igout=work.gseg tc=sashelp.templt template=l2r2 nofs;
treplay 1:f66a 2:f66c 3:f66b 4:f66d;
run;
quit;
