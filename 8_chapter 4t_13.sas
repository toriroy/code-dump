filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdate disdate fdate los dstat lenfol fstat;
run;
data cat;
   set whas500;
   age2=(age ge 60 and age le 69);
   age3=(age ge 70 and age le 79);
   age4=(age ge 80);
/* crude model */
ods select ParameterEstimates;
proc phreg data = whas500;
model lenfol*fstat(0) = gender;
run;
/* adjusted model */
ods select ParameterEstimates;
proc phreg data = whas500;
model lenfol*fstat(0) = gender age;
run;
/* interaction model */
ods select ParameterEstimates;
proc phreg data = whas500;
model lenfol*fstat(0) = gender age ga;
ga = gender*age;
output out=fig42 xbeta=xbeta;
run;
