filename actg 'C:\Users\varoy\Desktop\actg320.dat';
data actg;
infile actg;
input id time censor time_d censor_d tx txgrp strata2 sexF raceth ivdrug hemophil karnof cd4 priorzdv age;
run;

ods select CensoredSummary HomTests; 
proc lifetest data = actg;
time time*censor(0);
run;

proc lifetest data = actg;
strata tx / test=(logrank) nodetail;
time time*censor(0);
run;
proc lifetest data = actg;
strata txgrp / test=(logrank) nodetail;
time time*censor(0);
run;

proc lifetest data = actg;
strata txgrp / test=(logrank) nodetail;
time time*censor(0);
run;
proc phreg data = actg;
model time*censor(0) = censor_d / risklimits;
run;

proc phreg data = actg;
model time*censor(0) = time_d / risklimits;
run;

proc phreg data = actg;
model time*censor(0) = tx / risklimits;
run;
proc phreg data = actg;
model time*censor(0) = txgrp / risklimits;
run;
proc phreg data = actg;
model time*censor(0) = age / risklimits;
run;
proc phreg data = actg;
model time*censor(0) = ivdrug / risklimits;
run;
proc phreg data = actg;
model time*censor(0) = raceth / risklimits;
run;
proc phreg data = actg;
model time*censor(0) = karnof / risklimits;
run;
proc phreg data = actg;
model time*censor(0) = cd4 / risklimits;
run;
proc phreg data = actg;
model time*censor(0) = strata2 / risklimits;
run;
proc phreg data = actg;
model time*censor(0) = sexF / risklimits;
run;
*proc phreg data = actg;
*model time*censor(0) = time_d / risklimits;
*run;
*proc phreg data = actg;
*model time*censor(0) = censor_d / risklimits;
*run;
*proc phreg data = actg;
*model time_d*censor_d(0) = hemophil / risklimits;
*run;
proc phreg data = actg;
model time*censor(0) = hemophil / risklimits;
run;
proc phreg data = actg;
model time*censor(0) = priorzdv / risklimits;
run;

proc phreg data = actg;
model time*censor(0) = tx txgrp strata2 sexF raceth ivdrug hemophil karnof cd4 priorzdv age;
run;

proc phreg data = actg;
model time*censor(0) = txgrp strata2 sexF raceth ivdrug hemophil karnof cd4 priorzdv age;
run;

proc phreg data = actg;
model time*censor(0) = txgrp sexF raceth ivdrug hemophil karnof cd4 priorzdv age;
run;

proc phreg data = actg;
model time*censor(0) = txgrp sexF raceth ivdrug hemophil karnof cd4 age;
run;

proc phreg data = actg;
model time*censor(0) = txgrp sexF raceth ivdrug karnof cd4 age;
run;

proc phreg data = actg;
model time*censor(0) = txgrp raceth ivdrug karnof cd4 age;
run;

proc phreg data = actg;
model time*censor(0) = txgrp ivdrug karnof cd4 age;
run;

proc phreg data = actg;
model time*censor(0) = txgrp karnof cd4 age ivdrug aiv;
aiv = age*ivdrug;
run;

