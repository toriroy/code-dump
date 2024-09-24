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
model days*death(0) = r_t0 r_t1 r_t2_3 r_t_4_7 r_t_8_10 r_t_11_14 age_inv sysbp_sqrt stchange;
if days > revascdays and revascdays = 0 and revasc = 1 then r_t0 = 1;
else r_t0 = 0;
if days > revascdays and revascdays = 1 and revasc = 1 then r_t1 = 1;
else r_t1 = 0;
if days > revascdays and 2 <= revascdays <= 3 and revasc = 1 then r_t2_3 = 1;
else r_t2_3 = 0;
if days > revascdays and 4 <= revascdays <= 7 and revasc = 1 then r_t_4_7 = 1;
else r_t_4_7 = 0;
if days > revascdays and 8 <= revascdays <= 10 and revasc = 1 then r_t_8_10 = 1;
else r_t_8_10 = 0;
if days > revascdays and 11 <= revascdays <= 14 and revasc = 1 then r_t_11_14 = 1;
else r_t_11_14 = 0;
run;
