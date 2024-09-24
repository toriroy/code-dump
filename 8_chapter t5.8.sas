filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdate disdate fdate los dstat lenfol fstat;
run;

/*Table 5.8 on page 147 using the whas500 data. For each fitted model, we use the ods output statement to save the fit statistics as a dataset. These datasets are then combined and compared using a likelihood ratio tests.  
*/
data table58;
set whas500;
bmi12 = bmi**(-2);
bmi2 = (bmi/10)**2;
bmi3 = (bmi/10)**3;
run;

* not in the model;
ods output FitStatistics = not;
proc phreg data = whas500;
model lenfol*fstat(0) = age hr diasbp gender chf;
run;

* linear;
ods output FitStatistics = linear;
proc phreg data = whas500;
model lenfol*fstat(0) = age hr diasbp bmi gender chf;
run;

* j = 1 (2 df);
ods output FitStatistics = j1;
proc phreg data = table58;
model lenfol*fstat(0) = age hr diasbp  bmi12 gender chf;
run;

* j = 2 (4 df);
ods output FitStatistics = j2;
proc phreg data = table58;
model lenfol*fstat(0) = age hr diasbp  bmi2 bmi3 gender chf;
run;

data _null_;
set not;
if _n_ = 1 then call symput('not', withcovariates);
set linear;
if _n_ = 1 then call symput('linear', withcovariates);
set j1;
if _n_ = 1 then call symput('j1', withcovariates);
set j2;
if _n_ = 1 then call symput('j2', withcovariates);
run;

data table5_8;
  length power $8;
  loglikelihood = &not;
  gstat  = .;
  pvalue = .;
  power = "";
  output;
  loglikelihood = &linear;
  gstat = &linear-&linear;
  pvalue = 1- probchi(&not - &linear ,1);
  power = "1";
  output;
  loglikelihood = &j1;
  gstat = &linear - &j1;
  pvalue = 1- probchi(&linear - &j1 ,1);
  power = "-2";
  output;
  loglikelihood = &j2;
  gstat = &linear - &j2;
  pvalue = 1- probchi(&j1 - &j2 ,2);
  power = "(2,3)";
  output;
run;

proc print data = table5_8 noobs;
var loglikelihood gstat pvalue power;
format loglikelihood gstat pvalue f8.3;
run;
