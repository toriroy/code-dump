

filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdateHospital$ disdate$ fdate$ los dstat lenfol fstat;
bmi12 = bmi**(-2);
bmifp1 = (bmi/10)**2;
bmifp2 = (bmi/10)**3;
ga=gender*age;
run;
proc phreg data = whas500;
model lenfol*fstat(0) = bmifp1 bmifp2 age hr diasbp gender chf ga;
output out=f68 resmart = martres ld = ld;
run;

goptions reset=all; 
symbol v = dot;
axis1 order=(0 to .8 by .2) label=(a=90 'Likelihood Dispacement') minor=none;
axis2 order=(-4 to 1 by 1) label=('Martingale Residuals') minor=none;

proc gplot data = f68;
plot ld*martres / vaxis = axis1 haxis = axis2;
run;
quit;
