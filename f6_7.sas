

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

***EMPTY GRAPHICS CATALOG;
proc greplay nofs igout=gseg;
delete _all_;
run;
quit;

* f6.7(a);
goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-.003 to .001 by .001) label=(a=90 'Scaled Score Residuals') minor=none;
axis2 order=(20 to 120 by 20) label=('Age (Years)') minor=none;
title 'Figure 6.7a';
proc gplot data = bmi;
plot ssage_r*age / vaxis = axis1 haxis = axis2 name = "f67a" noframe;
run;
quit;

* f6.7(b);
goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-.004 to .004 by .002) label=(a=90 'Scaled Score Residuals') minor=none;
axis2 order=(20 to 120 by 20) label=('Age (Years)') minor=none;
title 'Figure 6.7b';
proc gplot data = bmi;
plot ssga_r*age / vaxis = axis1 haxis = axis2 name = "f67b" noframe;
run;
quit;

* f6.7(c);
goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-.04 to .04 by .02) label=(a=90 'Scaled Score Residuals') minor=none;
axis2 offset=(4 cm, 4 cm) value=('No' 'Yes') order=(0 1) label=('Congestive Heart Complications') minor=none;
title 'Figure 6.7c';
proc gplot data = bmi;
plot sschf_r*chf / vaxis = axis1 haxis = axis2 name = "f67c" noframe;
run;
quit;

* f6.7(d);
goptions reset=all htext = 2 htitle = 3; 
symbol v = dot;
axis1 order=(-.2 to .3 by .1) label=(a=90 'Scaled Score Residuals') minor=none;
axis2 offset=(4 cm, 4 cm) value=('Male' 'Female') order=(0 1) label=('Gender') minor=none;
title 'Figure 6.7d';
proc gplot data = bmi;
plot ssgender_r*gender / vaxis = axis1 haxis = axis2 name = "f67d" noframe;
run;
quit;

goptions reset=all;
proc greplay igout=work.gseg tc=sashelp.templt template=l2r2 nofs;
treplay 1:f67a 2:f67c 3:f67b 4:f67d;
run;
quit;
