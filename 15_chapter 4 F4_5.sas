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

