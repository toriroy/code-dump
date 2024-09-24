filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\actg320.dat';
data main;
infile aaa;
input id time censor timed censord tx txgrp strat2 sex raceth ivdrug hemophil karnof cd4 priorzdv age;

proc phreg data = main;
model time*censor(0) = tx;
run;

