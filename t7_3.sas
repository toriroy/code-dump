filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch5\uissurv.dat';
data uis;
infile aaa;
input id age becktota hercoc ivhx ndrugtx race
      treat site lot time censor;
   ivhx1 = (ivhx=1);
   ivhx2 = (ivhx=2);
   ivhx3 = (ivhx=3);
   ndrugfp1=1/((ndrugtx+1)/10);
   ndrugfp2=(1/((ndrugtx+1)/10))*log((ndrugtx+1)/10);

   /* the interactions - using age, becktota, ndrugfp1, ndrugfp2,
                            ivhx3 race treat site*/
   agexsite=age*site;
   racexsite=race*site;

/* Lines 1 and 3 of table */ 
ods select ParameterEstimates;
proc phreg data = uis;
model time*censor(0) = treat off_trt tot / risklimits;
if time <= lot then off_trt = 0;
else off_trt = 1;
tot = treat*off_trt;
run;

/* Line 2 of table */
ods select ParameterEstimates;
proc phreg data = uis;
model time*censor(0) = treat off_trt tot / risklimits;
if time <= lot then off_trt = 1;
else off_trt = 0;
tot = treat*off_trt;
run;

/* Line 4 of table */
ods select ParameterEstimates;
proc phreg data = uis;
model time*censor(0) = treat2 off_trt tot / risklimits;
treat2 = 1 - treat;
if time <= lot then off_trt = 0;
else off_trt = 1;
tot = treat2*off_trt;
run;
