libname M6 'C:\Users\lcowan\Desktop\Fall 2019\EPID 7134\SAS';

proc logistic data = m6.M1a descending;
class WHRQRT (ref='0') Diabetes (ref='0');
model WHRQRT = Diabetes;
run;

proc logistic data = m6.M1a descending;
class WHRQRT (ref='0') Diabetes (ref='0');
model WHRQRT = Diabetes /link=glogit ;
run;

proc logistic data = m6.M1a descending;
class WHRQRT (ref='0');
model WHRQRT = SBP ;
run;
proc logistic data = m6.M1a descending;
class WHRQRT (ref='0');
model WHRQRT = SBP /link=glogit ;
run;
proc logistic data = m6.M1a descending;
class WHRQRT (ref='0') diabetes (ref='0');
model WHRQRT = diabetes /link=glogit ;
run;

