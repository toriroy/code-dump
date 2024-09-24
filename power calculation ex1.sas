
* example of power computation assuming worst case scenario (page 39 text book);

data power;
do r=2 to 6;
nu1=3-1; *df for MStr;
nu2=3*(r-1); * df for MSE;
alpha=0.05;
Fcrit=finv(1-alpha,nu1,nu2);
sigma2=2.1;
css=4.5;
nc=r*(css)/sigma2; * non centrality parameter or lambda square;
power=1-probf(Fcrit,nu1,nu2,nc);
output;
end;
keep r nu1 nu2 nc power;
run;

proc print;
run;


* using proc power;
proc power;
OneWayANOVA
 alpha=0.05
 groupmeans=(-1.5 0 1.5)
 stdDev=1.449
 power=.
 NperGroup=2 to 6 by 1;
run;


*using glm power;
data breadm;
 input time meanht;
 datalines;
 1 -1.5
 2 0
 3 1.5
 proc glmpower;
 class time;
 model meanht=time;
 power
 stddev=1.449
 ntotal=6 to 18 by 1
 power=. ;
 run;

 * for a contrast with numerator degrees of freedom 1;
 data power2;
do r=2 to 6;
nu1=1; *df for MStr;
nu2=3*(r-1); * df for MSE;
alpha=0.05;
Fcrit=finv(1-alpha,nu1,nu2);
sigma2=2.1;
css=4.5;
nc=r*(css)/sigma2; * non centrality parameter or lambda square;
power=1-probf(Fcrit,nu1,nu2,nc);
output;
end;
keep r nu1 nu2 nc power;
run;

proc print data=power2;
run;
* Using Proc Power fpr contrast;

proc power;
      onewayanova
        alpha=0.05
 		groupmeans=(-1.5 0 1.5)
 		stdDev=1.449
 		power=.
 		NperGroup=2 to 6 by 1
        contrast = (-1 0 1) (1 -2 1);
   run;
