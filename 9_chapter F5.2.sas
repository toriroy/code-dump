filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdate disdate fdate los dstat lenfol fstat;
run;

/*Figure 5.2 on page 149 using the whas500 data.  */

proc phreg data = whas500;
model lenfol*fstat(0) = age hr diasbp gender chf;
id id;
output out=fig52ar resmart=mart;
run;

proc sort data = whas500;
by id;
run;

proc sort data = fig52ar;
by id;
run;

data fig52a;
merge fig52ar whas500;
by id;
run;

proc loess data = fig52a;
model mart = bmi ;
ods output OutputStatistics=results_fig52a;
run;

proc sort data=results_fig52a;
by bmi;
run;

goptions reset=all;
axis1 order=(-4 to 1 by 1) label=(a=90 'Martingale Residuals from Model Without BMI') minor=none;
axis2 order=(10 to 50 by 10) label=('Body Mass Index (kg/m^2)') minor=none;
symbol1 v=dot i=none c=black;
symbol2 v=none i=join c=black;
proc gplot data = results_fig52a;
plot DepVar*bmi=1 pred*bmi=2 / overlay vaxis = axis1 haxis = axis2;
run;
quit;
proc phreg data = whas500;
model lenfol*fstat(0) = age hr diasbp gender chf bmi;
id id;
output out=fig52br resmart=mart_full;
run;

data temp1;
set fig52br;
hat = fstat - mart_full;
run;

proc loess data = temp1;
model fstat = bmi / smooth = .4 bucket = 20;
ods output OutputStatistics=results_fig52b1;
run;

data temp2;
set results_fig52b1;
rename DepVar = depvar_fstat;
rename Pred = pred_fstat;
run;

proc loess data = temp1;
model hat = bmi / smooth = .4 bucket = 20;
ods output OutputStatistics=results_fig52b2;
run;

data temp3;
set results_fig52b2;
rename DepVar = depvar_hat;
rename Pred = pred_hat;
run;

proc sort data = temp2;
by obs;
run;

proc sort data = temp3;
by obs;
run;

data temp4;
merge temp2 temp3;
by obs;
run;

data temp5;
set temp4;
f = log(pred_fstat/pred_hat)-.0451558*bmi;
id = obs;
run;

proc sort data = temp5;
by bmi;
run;

goptions reset=all;
axis1 order=(-1.5 to .5 by .5) label=(a=90 'ln(csmoothed/Hsmoothed)+beta*x') minor=none;
axis2 order=(10 to 50 by 10) label=('Body Mass Index (kg/m^2)') minor=none;
symbol1 v=none i=join c=black;
proc gplot data = temp5;
plot f*bmi / vaxis = axis1 haxis = axis2;
run;
quit;
