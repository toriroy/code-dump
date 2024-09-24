filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\gbcs.dat';
data gbcs;
infile aaa;
input id diagdate$ recdate$ deathdate$ age menopause hormone size grade nodes prog_recp estrg_recp rectime censrec time censor;
if hormone=1 then hormone=0;
if hormone=2 then hormone=1;

run;

/*Table 4.15 on page 119 using the gbcs data.*/
/* crude model */
ods select ParameterEstimates;
proc phreg data = gbcs;
model rectime*censrec(0) = hormone;
run;
/* adjusted model */
ods select ParameterEstimates;
proc phreg data = gbcs;
model rectime*censrec(0) = hormone nodes;
run;
/* interaction model */
ods select ParameterEstimates;
proc phreg data = gbcs;
model rectime*censrec(0) = hormone nodes hn;
hn = hormone*nodes;
run;
