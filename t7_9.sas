filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch7\grace1000.dat';
data grace1000;
infile aaa;
input id days death revasc revascdays los age sysbp stchange;

data grace1000;
set grace1000;
age_inv = (1/age)*1000;
sysbp_sqrt = sqrt(sysbp);
run;

/*NOTE:  This code does not reproduce the results shown in the text. */


ods select ParameterEstimates;
proc phreg data = grace1000;
model days*death(0) = r_t_0_1 r_t_2_14 age_inv sysbp_sqrt stchange;
if days > revascdays and 0 <= revascdays <= 1 and revasc = 1 then r_t_0_1 = 1;
else r_t_0_1 = 0;
if days > revascdays and 2 <= revascdays <= 14 and revasc = 1 then r_t_2_14 = 1;
else r_t_2_14 = 0;
run;
