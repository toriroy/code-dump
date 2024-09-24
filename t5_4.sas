filename bc "C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch5\fromweb\bcconf.sas";
filename lr "C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch5\fromweb\lrtest.sas";
%include bc;
%include lr;


filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdateHospital$ disdate$ fdate$ los dstat lenfol fstat;
run;

ods output ParameterEstimates=out3;
proc phreg data = whas500;
model lenfol*fstat(0) = age hr diasbp bmi gender afb chf miord mitype;
run;

data out4;
set out3;
z = estimate /stderr;
lb = estimate-1.96*stderr;
ub = estimate+1.96*stderr;
run;

proc print data = out4 noobs;
var Parameter estimate stderr z probchisq lb ub;
format z f8.2;
format estimate probchisq lb ub f8.3;
format stderr f8.4;
run;
