filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch7\grace1000.dat';
data grace1000;
infile aaa;
input id days death revasc revascdays los age sysbp stchange;

data grace1000;
set grace1000;
age_inv = (1/age)*1000;
sysbp_sqrt = sqrt(sysbp);
run;


proc freq data = grace1000;
tables revascdays;
where revasc = 1;
run;
