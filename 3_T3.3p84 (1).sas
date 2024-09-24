/*Table 3.3, page 84 using the actg320 dataset.	*/
filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\actg320.dat';
data actg320;
infile aaa;
input id time censor timed censord tx txgrp strat2 sex raceth ivdrug hemophil karnof cd4 priorzdv age;

proc phreg data = actg320;
model time*censor(0) = tx age cd4;
run;
