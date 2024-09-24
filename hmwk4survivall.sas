filename aaa 'C:\Users\vr02477\Desktop\whas500.dat';
data main;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admit$ discharge$ fdate$ los dstat lenfol fstat;
run;

ods select ParameterEstimates;
proc phreg data = main;
model lenfol*fstat(0) = gender /risklimits alpha=0.1;
run;

ods select ParameterEstimates;
proc phreg data = main;
model lenfol*fstat(0) = gender bmi /risklimits alpha=0.1;
run;

