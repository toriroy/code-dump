filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdate disdate fdate los dstat lenfol fstat;
run;

/*Table 5.15 on page 161 using the whas500 data as modified for Table 5.8.
NOTE:  Lines 3 and 4 are reversed from what is shown in the text. */

proc phreg data = table58;
model lenfol*fstat(0) = age chf hr diasbp bmi gender mitype miord sysbp cvd afb 
/ selection=score best=3;
ods output BestSubsets = bestsub;
run;

* last is 0/1 temporary variable;
data _null_;
  set bestsub end=last;
  if last then call symput('s11', scorechisq);
run;

data bestsub_a;
  set bestsub;
  sq = &s11 - scorechisq;
  c = sq - (11 - 2*numberinmodel);
run;

proc sort data = bestsub_a;
by c;
run;

proc print data = bestsub_a (obs = 5) noobs label;
var VariablesInModel c sq;
format c sq f8.2;
label VariablesInModel = "Model Covariates";
run;
