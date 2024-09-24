filename aaa 'C:\Users\varoy\Desktop\whas100.dat';
data main;
infile aaa;
input id adddate$ foldate$ hosstay foltime folsta age gender bmi;
run;


ods graphics on;
proc lifetest data = main plot=(s) censoredsymbol=none;
time foltime*folsta(0);
label foltime = "Follow up time";
run;
ods select ProductLimitEstimates;
proc lifetest data = main plot=(s) censoredsymbol=none;
time foltime*folsta(0);
label foltime = "Follow up time";
test gender bmi age;
run;



ods graphics on;
proc phreg data=main plot(overlay)=survival;
   model foltime*folsta(0)= gender age bmi;
   baseline covariates=main out=_null_;
run;
proc phreg data=main plot(overlay)=survival;
   model foltime*folsta(0)= ;
   baseline covariates=main out=_null_;
run;
proc phreg data=main plot(overlay)=survival;
   model foltime*folsta(0)= ;
   baseline covariates=main out=_null_;
run;
proc phreg data=main plot(overlay)=survival;
   model foltime*folsta(0)= ;
   baseline covariates=main out=_null_;
run;
proc phreg data=main plot(overlay)=survival;
   model foltime*folsta(0)= ;
   baseline covariates=main out=_null_;
run;
