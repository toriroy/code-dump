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
model days*death(0) = revasc_t0_1 revasc_t2_14 age_inv sysbp_sqrt stchange / risklimits;
if revasc = 0 or (revasc = 1 and revascdays >= 15) then do;
revasc_t0_1 = 0;
revasc_t2_14 = 0;
end;
if revasc = 1 and (revascdays <2) then do;
revasc_t0_1 = 1;
revasc_t2_14 = 0;
end;
if revasc = 1 and 2 <= revascdays <= 14 then do;
revasc_t0_1 = 0;
revasc_t2_14 = 1;
end;
run;
