filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\gbcs.dat';
data gbcs;
infile aaa;
input id diagdate$ recdate$ deathdate$ age menopause hormone size grade nodes prog_recp estrg_recp rectime censrec time censor;
if hormone=1 then hormone=0;
if hormone=2 then hormone=1;

run;

/*Figure 4.5 on page 123 using the gbcs data.*/

data gbcs1;
set gbcs;
time = rectime/30;
run;

proc phreg data = gbcs1;
model time*censrec(0) = hormone;
output out = fig45 survival=survival;
run;

proc sort data = fig45;
by hormone time;
run;

goptions reset=all;
axis1 order=(0 to 1 by .2) label=(a=90 'Covariate Adjusted Survival Function') minor=none;
axis2 order=(0 to 80 by 20) label=('Recurrence Time (Months)') minor=none;
symbol1 i=stepjll v=none c=black line=33;
symbol2 i=stepjll v=none c=black line=1;
legend label=none value=('No Hormone Therapy' 'Hormone Therapy')
       position=(bottom inside) mode=share cborder=black; 

proc gplot data = fig45;
plot survival*time = hormone /vaxis=axis1 haxis=axis2 legend = legend;
run;
quit;

/*Table 4.19 on page 126 using the modified gbcs data from Figure 4.5.*/

data gbcs_t419;
set gbcs1;
grade_2 = 0;
grade_3 = 0;
if grade = 2 then grade_2 = 1;
if grade = 3 then grade_3 = 1;
ln_prg = log(prog_recp+1);
run;
ods select ParameterEstimates;
proc phreg data = gbcs_t419;
model rectime*censrec(0) = hormone grade_2 grade_3 size ln_prg;
run;
     
/*Figure 4.7 on page 127 using the modified version of gbcs from the previous example.*/

data c47;
  hormone = 0;
  grade_2 = 0;
  grade_3 = 0;
     size = 0;
   ln_prg = 0;
run;
proc phreg data = gbcs_t419;
model time*censrec(0) = hormone grade_2 grade_3 size ln_prg;
output out = fig47 xbeta=xbeta;
baseline out=fig47_base covariates=c47 survival=survival /nomean;* method = ch;
run;
proc univariate data = fig47;
  var xbeta;
  output out = fig47_a p10=p10 q1=q1 median=q2 q3=q3 p90=p90;
run;
data _null_;
  set fig47_a;
  call symput('p10', p10);
  call symput('p25', q1);
  call symput('p50', q2);
  call symput('p75', q3);
  call symput('p90', p90);
run;
data fig47_base_a;
  set fig47_base;
  s10 = survival**(exp(&p10));
  s25 = survival**(exp(&p25));
  s50 = survival**(exp(&p50));
  s75 = survival**(exp(&p75));
  s90 = survival**(exp(&p90));
run;


goptions reset = all;
symbol1 i=stepjl v=none c=black line=33;
symbol2 i=stepjl v=none c=black line=2;
symbol3 i=stepjl v=none c=black line=1;
symbol4 i=stepjl v=none c=black line=39;
symbol5 i=stepjl v=none c=black line=46;
axis1 label=(h=2 a=90 'Covariate Adjusted Survival Function')  minor=none order=(0 to 1 by .2);
axis2  label=(h=2 'Recurrance Time (Months)') minor=none order=(0 to 100 by 20);
legend label=none value=(h=2 '10th Pctl. of Risk' 'First Quartile of Risk'
						'Second Quartile of Risk' 'Third Quartile of Risk' '90th Pctl. of Risk')
       position=(bottom inside) mode=share cborder=black; 
proc gplot data = fig47_base_a;
plot (s10 s25 s50 s75 s90)*time / overlay vaxis = axis1 haxis = axis2 legend = legend;
run;
quit;
