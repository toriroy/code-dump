filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\uissurv.dat';
data uis;
infile aaa;
input id age bectota hercoc ivhx ndrugtx race
      treat site los time censor;
	  agec=age-30;
	  ndrugtx_c=ndrugtx-3;
	  drug=1;
	  if ivhx = 1 then drug=0;
run;
data uis1;
set uis;
if ivhx ne . then drug = (ivhx ne 1);
run;

/* crude model */
ods select ParameterEstimates;
proc phreg data = uis1;
model time*censor(0) = drug;
where ivhx ne . and age ne . ;
run;
/* adjusted model */
ods select ParameterEstimates;
proc phreg data = uis1;
model time*censor(0) = drug age;
where ivhx ne . and age ne . ;
run;
/* interaction model */
ods select ParameterEstimates;
proc phreg data = uis1;
model time*censor(0) = drug age da;
da = drug*age;
where ivhx ne . and age ne . ;
run;
