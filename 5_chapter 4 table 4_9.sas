/*Table 4.4 on page 99 using the whas100 data.*/
filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch2\2009\whas100.dat';
data whas100;
infile aaa;
input id ent$ end$ stay time censor age gender bmi;
gender2 = 0;
if gender eq 0 then gender2=1;
run;

/*Table 4.9 on page 107 using the whas100 data.	*/

ods select ParameterEstimates;
proc phreg data = whas100;
model time*censor(0) = age;
run;
