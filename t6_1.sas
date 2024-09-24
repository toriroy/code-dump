
filename ph_score "C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch6\fromweb_2009\phreg_score_test.sas";
%include ph_score;

filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdateHospital$ disdate$ fdate$ los dstat lenfol fstat;
run;

data whas500;
set whas500;
bmifp1=(bmi/10)**2;
bmifp2=(bmi/10)**3;
ga = gender*age;
time = lenfol/365.25;
run;
%phreg_score_test(lenfol, fstat, bmifp1 bmifp2 age hr diasbp gender chf ga, data=whas500);

%phreg_score_test(lenfol, fstat, bmifp1 bmifp2 age hr diasbp gender chf ga, 
                  data=whas500, type="logtime");
%phreg_score_test(lenfol, fstat, bmifp1 bmifp2 age hr diasbp gender chf ga, 
                  data=whas500, type="km");

%phreg_score_test(lenfol, fstat, bmifp1 bmifp2 age hr diasbp gender chf ga, 
                  data=whas500, type="rank");
