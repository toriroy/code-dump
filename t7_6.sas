filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch7\grace1000.dat';
data grace1000;
infile aaa;
input id days death revasc revascdays los age sysbp stchange;

data grace1000;
set grace1000;
age_inv = (1/age)*1000;
sysbp_sqrt = sqrt(sysbp);
run;


ods output ParameterEstimates=out1;
proc phreg data = grace1000;
model days*death(0) = revasc_t age_inv sysbp_sqrt stchange;
if days <= revascdays or revasc = 0 then revasc_t = 0;
if days > revascdays and revasc = 1 then revasc_t = 1;
run;

data out2;
set out1;
z = estimate /stderr;
lb = estimate-1.96*stderr;
ub = estimate+1.96*stderr;
run;

proc print data = out2 noobs;
var parameter estimate stderr z probchisq lb ub;
format z f8.2;
format estimate probchisq lb ub f8.3;
format stderr f8.4;
run;

