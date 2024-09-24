filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdate disdate fdate los dstat lenfol fstat;
run;

/*Figure 5.3 on page 150 using the whas500 data and the data generated in the previous example from the two term model.	*/
proc print data=temp5;
run;
data temp6;
set whas500;
bmifp1=(bmi/10)**2;
bmifp2=(bmi/10)**3;
run;

proc sort data = temp5;
by id;
run;

proc means data = temp6;
var id;
run;

proc sort data = temp6;
by id;
run;

data temp7;
merge temp5 temp6;
by id;
run;

proc phreg data = whas500;
model lenfol*fstat(0) = bmifp1 bmifp2 age hr diasbp gender chf;
run;

* f is generated in the temp5 data set above;
data temp8;
set temp7;
fp_funct=-0.72476*bmifp1+0.15442*bmifp2;
diff=f-fp_funct;
run;

data temp8;
set temp7;
fp_funct=-0.725*bmifp1+0.154*bmifp2;
diff=f-fp_funct;
run;

proc means data = temp8;
var diff;
run;

data temp9;
set temp8;
fp_funct1 = fp_funct + 0.9076111;
run;

proc sort data = temp9;
by bmi;
run;

proc means data = temp9;
var bmi f fp_funct1;
run;

goptions reset=all;

axis1 order=(-1.5 to .5 by .5) label=(a=90 'Estimated Log Hazard') minor=none;
axis2 order=(10 to 50 by 10) label=('Body Mass Index (kg/m^2)') minor=none;
symbol1 v=none i=join c=red line=1;
symbol2 v=none i=join c=black line=14;
legend label=none value=('GTF Smooth' 'Two Term (2, 3) Model')
       position=(top left inside) mode=share down = 2; 

proc gplot data = temp9;
plot fp_funct1*bmi=1 f*bmi=2 / vaxis = axis1 haxis = axis2 overlay legend = legend;
run;
quit;

