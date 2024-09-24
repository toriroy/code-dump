data twokexample;
input rep A $ B $ y;
datalines;
1 n n 28
2 n n 25
3 n n 27
4 p n 36
5 p n 32
6 p n 32
7 n p 18
8 n p 19
9 n p 23
10 p p 31
11 p p 30
12 p p 29
;
run;

ods graphics on;
proc glm data=twokexample;
class A B;
model y = A B A*B/clparm;
contrast 'main effect of A' A -1 1 ; 
contrast 'main effect of B' B -1 1;	
contrast 'interaction  AB ' A*B 0.5 -0.5 -0.5 0.5; 

estimate 'main effect of A' A  -1 1; 
estimate 'main effect of B' B  -1 1;	
estimate 'interaction  AB ' A*B 0.5 -0.5 -0.5 0.5; 
run;
ods graphics off;

*sample size and power;
/* interaction with worst case sccenario;                               */
data Power;
do r=2 to 8;
   nu1=9; * df for numerator=(a-1)(b-1);
   nu2=16*(r-1); * df for denomonator;
   alpha=.05;
   Fcrit=finv(1-alpha,nu1,nu2); *F critical value;
   sigma2=.1024;
   css=0.5;
   nc=r*(css)/sigma2;*noncentrality parameter for noncentral F;
   power=1-probf(Fcrit,nu1,nu2,nc);
   output;
end;
keep r nu1 nu2 nc power;
title Power Calculation in Data Step;
proc print; run;



/*main effect with worst case sccenario;                                    */
data Power;
  do r=2 to 4;
   nu1=4-1; * df for numerator;
   nu2=16*(r-1); * df for denomonator;
   alpha=.05;
   Fcrit=finv(1-alpha,nu1,nu2); *F critical value;
   sigma2=.1024;
   css=0.5;
   nc=4*r*(css)/sigma2;*noncentrality parameter for noncentral F;
   power=1-probf(Fcrit,nu1,nu2,nc);
   output;
  end;
  keep r nu1 nu2 nc power;
title Power Calculation in Data Step;
proc print; run;
