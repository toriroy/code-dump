filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdate disdate fdate los dstat lenfol fstat;
run;
/*Table 4.14 on page 118 using the whas500 data. */

ods output covb = covb;
proc phreg data = whas500;
model lenfol*fstat(0) = gender age ga / covb;
ga = gender*age;
run;
data _null_;
  set covb;
  if _n_= 1 then
    call symput('vgender', gender);
  if _n_ = 3 then do;
    call symput('vga', ga);
    call symput('covga_age', gender);
   end;
run;
* see equation 4.20 on page 112;
data fig43;
  do age =30 to 100 by 5;
   hz = 2.32852 -0.03043*age;
   ul = hz + 1.96*sqrt(&vgender+ age**2*&vga +2*age*&covga_age);
   ll = hz - 1.96*sqrt(&vgender+ age**2*&vga +2*age*&covga_age);
   exphz=exp(hz);
   expul = exp(ul);
   expll =exp(ll);
   output;
  end;
run;

proc print data = fig43 noobs label;
var age exphz expll expul;
where age in (40, 50, 60, 65, 85, 90);
format exphz f8.2;
format expul expll f8.3;
label age='Age' exphz='HR' expll='Lower Limit' expul='Upper Limit';
run;

/*Figure 4.3  on page 118 using the data generated in the previous example.
NOTE:  We were unable to include the right-hand axis because the ticks on the left and right sides of the graph must be at exactly the same height in SAS. We create an annotated legend in order to label both the upper and lower limits of our confidence interval with the same description.  
*/
data annolegend;
  length function style color $8 text $20;  
  retain xsys ysys '1' when 'a' color 'black';
                 
  function='move';
    x=1;  y=3;  output;
  function='draw';
    x=6;  y=3;  line=33;  output;
  function='label';
    x=7;  y=3;  position='6';
    text='Confidence Limits'; 
    output;   
 
  function='move';
    x=1;  y=6;  output;
  function='draw';
    x=6;  y=6;  line=1;  output;
  function='label';
    x=7;  y=6;  position='6';
    text='Log Hazard Ratio';
    output;
run;      

data fig43;
 set fig43;
 logexphz=log(exphz);
 logexpul=log(expul);
 logexpll=log(expll);
 run;

symbol1 i=join v=none c=black line=1;
symbol2 i=join v=none c=black line=33;
symbol3 i=join v=none c=black line=33;
symbol4 i=none v=none c=black;

axis1 order=(-1 to 2.5 by .5) label=(a=90 'Estimated Log Hazard Ratio');
axis2 order=(20 to 100 by 20) label=('Age in Years') minor=none;

proc gplot data = fig43;
  plot (logexphz logexpul logexpll)*age / vaxis=axis1 haxis=axis2 overlay vref=0
nolegend annotate=annolegend;
run;
quit;
