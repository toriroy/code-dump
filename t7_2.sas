filename aaa 'G:\My Drive\yulili\course\survival data\2019\SAS used\ch5\uissurv.dat';
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

ods select ParameterEstimates;
proc phreg data = uis;
model time*censor(0) = treat / risklimits;
run;

ods output ParameterEstimates=out1;
proc phreg data = uis;
model time*censor(0) = treat off_trt tot/ risklimits covb;
if time <= lot then off_trt = 0;
else off_trt = 1;
tot = treat*off_trt;
run;

data out2;
set out1;
z = estimate /stderr;
lb = estimate-1.96*stderr;
ub = estimate+1.96*stderr;
run;

proc print data=out2;
run;

proc print data = out2 noobs;
var parameter estimate stderr z ProbChiSq lb ub;
format z f8.2;
format estimate probchisq lb ub f8.3;
format stderr f8.4;
run;
