filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\gbcs.dat';
data gbcs;
infile aaa;
input id diagdate$ recdate$ deathdate$ age menopause hormone size grade nodes prog_recp estrg_recp rectime censrec time censor;
run;
/*Table 4.11 on page 113 using the gbcs data. */

data gbcs;
set gbcs;
hormone = hormone - 1; /* coding the variable hormone 0/1 instead of coded 1/2 */
run;

/* crude model */
ods select ParameterEstimates;
proc phreg data = gbcs;
model rectime*censrec(0) = hormone;
run;

/* adjusted model */
ods select ParameterEstimates;
proc phreg data = gbcs;
model rectime*censrec(0) = hormone size;
run;

/* interaction model */
ods select ParameterEstimates;
proc phreg data = gbcs;
model rectime*censrec(0) = hormone size hs;
hs=hormone*size;
run;
