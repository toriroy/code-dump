libname M1 'C:\Users\lcowan\Desktop\Spring 2020\BUSA 9332\M1';

data m1.m1;
set m1.m1;
if SBP GE 140 then Hyper = 1;
else Hyper = 0;
run;

proc sort data = m1.m1;
by descending WHRGRP;
run;

proc sort data = m1.m1;
by descending Hyper;
run;

proc freq data = m1.m1 order=data;
table WHRGRP*Hyper;
run;

proc freq data = m1.m1 order=data;
table WHRGRP*Hyper /chisq;
run;

proc freq data = m1.m1 order=data;
table WHRGRP*Hyper /chisq OR;
run;

proc freq data = m1.m1 order=data;
table GENDER*WHRGRP*Hyper /chisq OR CMH;
run;

data m1.m1;
set m1.m1;
if WHR GE 0.990741 then WHRQRT = 3;
if WHR GE 0.950980 and WHR LT 0.990741 then WHRQRT = 2;
if WHR GE 0.895349 and WHR LT 0.950980 then WHRQRT = 1;
if WHR LT 0.895349 then WHRQRT = 0;
run;

proc freq data = m1.m1;
table WHRQRT;
run;

proc freq data = m1.m1 order=data;
table WHRQRT*Hyper /chisq OR CMH;
run;

proc freq data = m1.m1 order=data;
table GENDER*WHRQRT*Hyper /chisq OR CMH;
run;

