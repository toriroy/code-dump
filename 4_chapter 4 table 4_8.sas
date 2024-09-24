/*Table 4.4 on page 99 using the whas100 data.*/
filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch2\2009\whas100.dat';
data whas100;
infile aaa;
input id ent$ end$ stay time censor age gender bmi;
gender2 = 0;
if gender eq 0 then gender2=1;
run;

/*Table 4.8 on page 105 using the whas100 data.*/

data whas100dm;
set whas100;
age_2 = 0;
age_3 = 0;
age_4 = 0;
if age < 60 then do;
age_2 = -1;
age_3 = -1;
age_4 = -1;
end;
if 60 <= age <=69 then age_2 = 1;
if 70 <= age <=79 then age_3 = 1;
if age => 80 then age_4 = 1;
run;

ods select ParameterEstimates;
proc phreg data = whas100dm;
model time*censor(0) = age_2 age_3 age_4;
run;
