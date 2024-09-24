

filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdateHospital$ disdate$ fdate$ los dstat lenfol fstat;
bmi12 = bmi**(-2);
bmifp1 = (bmi/10)**2;
bmifp2 = (bmi/10)**3;
ga=gender*age;
run;
proc phreg data = whas500 ;
model lenfol*fstat(0) = bmifp1 bmifp2 age hr diasbp gender chf ga;
where diasbp ne 198;
output out = t64 xbeta = xb resmart = martres;
run;

proc sort data = t64 (where=(diasbp ne 198)) out=t64s;
by xb;
run;

data t64a;
set t64s;
if _n_ <= 100 then quin = 1;
if 101 <= _n_ <= 200 then quin = 2;
if 201 <= _n_ <= 300 then quin = 3;
if 301 <= _n_ <= 400 then quin = 4;
if _n_ >= 401 then quin = 5;
run;

proc sql;
  create table t64b as
  select quin, max(xb) as cut_point, count(quin) as count, 
         sum(fstat) as observed, sum(fstat-martres) as expected
  from t64a
  group by quin;
quit;

data t64c;
  set t64b;
  z = (observed-expected)/sqrt(expected);
  p = 2*(1-PROBNORM(abs(z)));
run;

proc print data = t64c noobs label;
label quin = "Quintile" cut_point = "Cut Point" count = "Count" observed = "Observed" expected = "Expected";
format cut_point expected z f8.2 p f8.3;
run;
  
