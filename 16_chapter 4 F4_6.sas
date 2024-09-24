filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\gbcs.dat';
data gbcs;
infile aaa;
input id diagdate$ recdate$ deathdate$ age menopause hormone size grade nodes prog_recp estrg_recp rectime censrec time censor;
if hormone=1 then hormone=0;
if hormone=2 then hormone=1;

run;

/*Figure 4.6 on page 125 using the gbcs data.*/

proc phreg data = gbcs;
model rectime*censrec(0) = hormone size_c;
size_c = size - 25;
output out=fig46 survival=survival;
run;

data cov;
  hormone = 0;
  size_c=0;
run;

data gbcs1;
set gbcs;
time = rectime/30;
run;

proc phreg data = gbcs1;
model time*censrec(0) = hormone size_c;
size_c = size - 25;
baseline out=fig46 survival=survival covariates =cov /nomean;
run;

proc sort data = fig46;
  by hormone time;
run;

data fig46_a;
  set fig46;
  survival1 = survival**(exp(-0.37347));
  hormone = 1;
  output;
  set fig46;
  survival1 = survival;
  hormone = 0;
  output;
run;

goptions reset = all;
symbol1 i=join v=none c=black line=33;
symbol2 i=join v=none c=black line=1;
axis1 label=(h=2 a=90 'Covariate Adjusted Survival Function')  minor=none order=(0 to 1 by .2);
axis2  label=(h=2 'Recurrance Time (Months)') minor=none order=(0 to 80 by 20);
legend label=none value=(h=2 'Hormone Therapy' 'No Hormone Therapy')
       position=(bottom inside) mode=share cborder=black; 
proc gplot data = fig46_a;
plot survival1*time = hormone /vaxis=axis1 haxis=axis2 legend = legend;
run;
quit;

