libname M1 'C:\Users\lcowan\Desktop\Fall 2019\EPID 7134\SAS';
data m1.M1a;
set M1.M1;
if WHR GE 0.99 then WHRQRT = 4;
if WHR LT 0.99 and WHR GE 0.95 then WHRQRT = 3;
if WHR LT 0.95 and WHR GE 0.89 then WHRQRT = 2;
if WHR LT 0.89 then WHRQRT = 1;
if SBP GE 140 then HYPER = 1;
else Hyper = 0;
run;

proc means data = M1.M1;
var age bmi pack_yrs;
run;

proc sort data = m1.m1a;
by descending  hyper;
run;
proc sort data = m1.m1a;
by descending WHRGRP;
run;

proc freq data = m1.m1a order=data;
table WHRGRP*HYPER /OR;
run;

PROC TTEST data = m1.m1a;
CLASS WHRGRP;
VAR SBP;
run;

PROC TTEST data = m1.m1a;
CLASS HYper;
VAR WHR;
run;

PROC GLM data = M1.M1a;
MODEL SBP=WHR;
run;


* Class 2;
proc sgplot data = M1.M1a;
histogram age;
density age;
run; 

proc sgplot data = m1.m1a;
scatter x=WHR y=SBP;
run;

PROC GLM data = M1.M1a;
MODEL SBP=WHR /solution;
run;

* Class 3;

PROC GLM data = M1.M1a;
class gender;
MODEL SBP=WHR gender /solution;
run;

PROC GLM data = M1.M1a;
class gender;
MODEL SBP=WHR gender WHR*Gender /solution;
run;


PROC TTEST data = m1.m1a;
CLASS WHRGRP;
VAR SBP;
run;

PROC GLM data = M1.M1a;
class gender;
MODEL SBP=WHRGRP /solution;
run;

* Testing assumptions;

proc sgplot data = m1.m1;
scatter x=WHR y=SBP;
run;
PROC GLM DATA=M1.M1 PLOTS=residuals;
model SBP=WHR ;
run;
proc sgplot data = M1.M1;
histogram WHR;
density WHR;
run; 
proc sgplot data = M1.M1;
histogram SBP;
density SBP;
run; 
* quadratic terms;
PROC GLM data = M1.M1a;
MODEL SBP=WHR WHR*WHR /solution;
run;

* 4-Level Exposure Variable;
proc glm data = m1.m1a;
class WHRQRT (Ref='1');
model SBP = WHRQRT;
lsmeans WHRQRT  / stderr pdiff;
run;
