filename aaa 'C:\Users\varoy\Desktop\whas500.dat';
data main;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admit$ discharge$ fdate$ los dstat lenfol fstat;
run;


ods select ParameterEstimates;
proc phreg data = main;
class gender;
model lenfol*fstat(0) = gender bmi /risklimits alpha=0.1; hazardratio gender / at (bmi=5); 
run;

proc phreg data = main;
model lenfol*fstat(0) = gender bmi /risklimits alpha=0.1; 
run;


proc phreg data = main;
model lenfol*fstat(0) = gender bmi1 /risklimits alpha=0.1; 
if bmi ge 15 le 16 then bmi1=1;
else bmi1=0;
run;
proc phreg data = main;
model lenfol*fstat(0) = gender bmi1 /risklimits alpha=0.1; 
if bmi ge 20 le 21 then bmi1=1;
else bmi1=0;
run;
proc phreg data = main;
model lenfol*fstat(0) = gender bmi1 /risklimits alpha=0.1; 
if bmi ge 25 le 26 then bmi1=1;
else bmi1=0;
run;
proc phreg data = main;
model lenfol*fstat(0) = gender bmi1 /risklimits alpha=0.1; 
if bmi ge 30 le 31 then bmi1=1;
else bmi1=0;
run;
proc phreg data = main;
model lenfol*fstat(0) = gender bmi1 /risklimits alpha=0.1; 
if bmi ge 35 le 36 then bmi1=1;
else bmi1=0;
run;


proc phreg data = main;
class gender;
model lenfol*fstat(0) = gender bmi gb / alpha=0.1; 
hazardratio gender / at (bmi=5);   
gb = gender*bmi;
run;
