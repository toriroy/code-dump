/*Table 4.2 on page 97 using the whas100 data. 
NOTE:  The calculations in the data step are necessary to obtain the confidence interval estimates.  We do not show this calculation for each example, but the procedure is the same.
*/
filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch2\2009\whas100.dat';
data main;
infile aaa;
input id ent$ end$ stay time censor age gender bmi;
gender2 = 0;
if gender eq 0 then gender2=1;
run;

proc phreg data=main;
/* check out confidence limits.  What do you think is happening?  */
model time*censor(0) = gender / rl;
title1 "Table 4.2, page 119";
run;
proc phreg data=main;
model time*censor(0)=gender2 / rl;
title1 "table 4.2 altered";
run;
