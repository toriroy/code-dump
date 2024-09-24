/*Table 3.4, page 87 using the whas100 dataset. We convert time to from years to quarters to increase the number of ties and 
better display the differences in methods for handling ties. These do not match the book exactly.

*/
filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch2\2009\whas100.dat';
data whas100;
infile aaa;
input id ent$ end$ stay foltime folstatus age gender bmi;
gender2 = 0;
if gender eq 0 then gender2=1;
run;

data whas100_q; set whas100;
time=foltime/30.44 	/* divide by days per month */;
time=round(time/3) 	/* divide by months per quarter */;
if time=0 then time=.5 /* event can't occur at time zero */;
run;

title "Exact";
proc phreg data = whas100_q;
model foltime*folstatus(0) = bmi gender / ties = exact;
run;

title "Breslow";
proc phreg data = whas100_q;
model foltime*folstatus(0) = bmi gender / ties = breslow;
run;

title "Efron";
proc phreg data = whas100_q;
model foltime*folstatus(0) = bmi gender / ties = efron;
run;
title;
