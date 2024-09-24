/*Table 3.2, page 83 using the actg320 dataset. 
NOTE:  The formula for z is on page 79 and the formula for CI is on page 80.
NOTE:  The standard error for age is different than that shown in the text.

*/


filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\actg320.dat';
data actg320;
infile aaa;
input id time censor timed censord tx txgrp strat2 sex raceth ivdrug hemophil karnof cd4 priorzdv age;


ods output ParameterEstimates=out1;
proc phreg data = actg320;
model time*censor(0) = tx age sex cd4 priorzdv;
run;

data out2;
set out1;
z = sqrt(chisq);
z2 = estimate /stderr;
lb = estimate-1.96*stderr;
ub = estimate+1.96*stderr;
run;

proc print data = out2;
var Parameter estimate stderr z z2 probchisq lb ub;
format estimate z z2 probchisq lb ub f8.3;
format stderr f8.4;
run;
