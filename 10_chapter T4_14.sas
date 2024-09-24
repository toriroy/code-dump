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
