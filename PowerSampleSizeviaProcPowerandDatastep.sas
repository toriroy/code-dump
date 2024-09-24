*** Examples: calculating power and sample size using SAS***;
* lambda^2= r(sum(tau_i*tau_i))/sigma^2;

*Input data to compute Fcritical value and power;
DATA power1;
input alpha g r;
cards;
0.05 4 6
0.05 4 7
0.05 4 16
0.05 4 17
0.05 4 20
0.05 4 22
0.05 4 24
;
run;
*compute critical value under non-central F with g=4 for different values of r;
*global F test when delta=k*sigma for k=1;
data power2;
set power1;
nu1 = g-1;;
nu2 = g*(r - 1);
nc = r/2;
fcr = finv(.95,nu1,nu2); * cenral F value;
power = 1 - probf(fcr,nu1,nu2,nc);
run;
proc print ; run ;
*global F test when delta=k*sigma for k=1;
data power2;
set power1;
nu1 = g-1;
nu2 = g*(r - 1);
nc = 10/36*r;
fcr = finv(.95,nu1,nu2);
power = 1 - probf(fcr,nu1,nu2,nc);
run;
proc print ; run ;

*(ii);
data power3;
set power2;
where replicate = 18;
lambda = 5/9*replicate;
fcr = finv(.95,nu1,nu2);
power = 1 - probf(fcr,nu1,nu2,lambda);
run;
proc print ; run ;

** Consider a CRD with g=4, alpha=0.05,CSS=0.05;

* a: using global F test;
data power;
do r=18 to 30;
nu1=4-1; *df for MStr;
nu2=4*(r-1); * df for MSE;
alpha=0.05;
Fcrit=finv(1-alpha,nu1,nu2);
sigma2=1;
css=0.05;
nc=r*(css)/sigma2; * non centrality parameter or lambda square;
power=1-probf(Fcrit,nu1,nu2,nc);
output;
end;
keep r nu1 nu2 nc power;
run;
proc print;
run;

*b - using linear trend: you need 15 instead of 21 in (b) to achieve 80% power;
data power;
do r=10 to 24;
nu1=1; *df for MStr;
nu2=4*(r-1); * df for MSE;
alpha=0.05;
Fcrit=finv(1-alpha,nu1,nu2);
sigma2=1;
css=5/9;
nc=r*(css)/sigma2; * non centrality parameter or lambda square;
power=1-probf(Fcrit,nu1,nu2,nc);
output;
end;
keep r nu1 nu2 nc power;
run;
proc print;
run;



* Using proc power;
*i;
proc power;
      onewayanova
         groupmeans = -2 | 0 | 0 | 2
         stddev = 4
         /*groupweights = (1 1 1 1)	*/
         alpha = 0.05
		 /*ntotal = .*/
         npergroup = .
         power = 0.8;
   run;
* i. for those testing contrast;
   proc power;
      onewayanova
	     test=contrast
         groupmeans = -0.5 | 0 | 0 | 0.5
         stddev = 1
         /*groupweights = (1 1 1 1)	*/
         alpha = 0.05
         npergroup = .
         power = 0.8
         contrast = (-3 -1 1 3) ;
   run;
*ii: global F test;
proc power;
      onewayanova
         groupmeans = -3 | -1 | 1 | 3
         stddev = 6
         /*groupweights = (1 1 1 1)	*/
         alpha = 0.05
		 /*ntotal = .*/
         npergroup = 23
         power = .;
   run;
   * iii. linear trend under the ii configuration;
   proc power;
      onewayanova
	     test=contrast
         groupmeans = -3 | -1 | 1 | 3
         stddev = 6
         /*groupweights = (1 1 1 1)	*/
         alpha = 0.05
         npergroup = 23
         power = .
         contrast = (-3 -1 1 3) ;
   run;
   * iii. linear trend under the i configuration;
   proc power;
      onewayanova
	     test=contrast
         groupmeans = -1 | 0 | 0 | 1
         stddev = 2
         /*groupweights = (1 1 1 1)	*/
         alpha = 0.05
         npergroup = 23
         power = .
         contrast = (-3 -1 1 3) ;
   run;


** Examples from Text Book-JL *************;
   /* Example 13 page 40                                        */
*Example power computation in SAS data step using Bread Example;
data Power;
do r=2 to 6;
   nu1=3-1; * df for numerator;
   nu2=3*(r-1); * df for denomonator;
   alpha=.05;
   Fcrit=finv(1-alpha,nu1,nu2); *F critical value;
   sigma2=2.1;
   css=4.5;
   nc=r*(css)/sigma2;*noncentrality parameter for noncentral F;
   power=1-probf(Fcrit,nu1,nu2,nc);
   output;
end;
keep r nu1 nu2 nc power;
title Power Calculation in Data Step;
proc print; run;
* linear trend in bread rise expt;
data Power;
do r=2 to 6;
   nu1=1; * df for numerator;
   nu2=3*(r-1); * df for denomonator;
   alpha=.05;
   Fcrit=finv(1-alpha,nu1,nu2); *F critical value;
   sigma2=2.1;
   css=4.5;
   nc=r*(css)/sigma2;*noncentrality parameter for noncentral F;
   power=1-probf(Fcrit,nu1,nu2,nc);
   output;
end;
keep r nu1 nu2 nc power;
title Power Calculation in Data Step;
proc print; run;
/* Example 14 page 41                                         */
* Eample Power Calculation Using proc power;
proc power;
   OneWayANOVA
      Alpha = 0.05
      GroupMeans = (-1.5 0 1.5) /*differences from the grand mean*/
      StdDev = 1.449
      Power = .
      NPerGroup = 2 to 6 by 1;
run;


/* Example 15 page 41                                        */
*Example Power Calculation Using proc glmpower;
/* data step reads in expected cell means 
ntotal is number of replicates per treatment factor level
times the number of levels                                */
data Breadm;
  input time meanht;
datalines;
1  -1.5
2    0
3  1.5
proc glmpower;
  class time;
  model meanht=time;
  power
  stddev=1.449
  ntotal=6 to 18 by 1
  power = .;
run;
