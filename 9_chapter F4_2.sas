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

/*Figure 4.2 on page 117 using the data output by the interaction model from the previous example. 	*/
proc sort data = fig42;
by gender age;
run;

goptions reset=all;
legend1 label=none value=(h=1.5 justify=left 'Males' 'Females' )
        position=(top left inside) mode=protect down=2 across=1;
axis1 order=(2 to 8 by 1) label=(a=90 'Estimated Log Hazard') minor=none;
axis2 order=(20 to 100 by 20) label=('Age in Years') minor=none;
symbol1 i=join v=none c=black line=1;
symbol2 i=join v=none c=black line=14;
proc gplot data = fig42;
plot xbeta*age=gender / vaxis=axis1 haxis=axis2 legend=legend1;
run;
quit;
