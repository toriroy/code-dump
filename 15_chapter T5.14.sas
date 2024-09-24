filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdate disdate fdate los dstat lenfol fstat;
run;

/*Table 5.14 on page 158 using the whas500 data as modified for Table 5.8.  For each step, we have formatted in bold the statistics shown in the text. 
*/
proc phreg data = table58;
model lenfol*fstat(0) = age chf hr diasbp bmi gender mitype miord sysbp cvd afb 
/ selection = forward  details slentry = 0.25 sls = 0.8;
run;
