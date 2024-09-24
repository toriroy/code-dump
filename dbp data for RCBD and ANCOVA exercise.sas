
********* Balanced two way ANOVA ******** ;
title 'Balanced Data from Randomized Complete Block'; 
   data data1; 
      input Trt $ @; 
      do Block = 1 to 3; 
         input Y @; 
         output; 
         end; 
      datalines; 
   A  32.7 32.3 31.5 
   B  32.1 29.7 29.1 
   C  35.7 35.9 33.1 
   D  36.0 34.2 31.2 
   E  31.8 28.0 29.2 
   F  38.2 37.8 31.9 
   G  32.5 31.1 29.7 
   ; 
 
proc glm data=data1 order=data; 
      class Block Trt; 
      model Y = Block Trt; 
   run; 
 
   proc glm data=data1 order=data; 
      class Block Trt; 
      model Y = Block Trt / solution; 
 
   /*CONTRASTS */ 
   contrast 'E vs. others'     Type   -1   -1   -1   -1    6   -1   -1; 
   contrast 'F vs. non E'      Type   -1   -1   -1   -1    0    5   -1;
   contrast '(C+D) vs. (A+G)'  Type   -1    0    1    1    0    0   -1; 
   contrast 'A vs. G'          Type   -1    0    0    0    0    0    1; 
   contrast "C vs. D"          Type    0    0    1   -1    0    0    0; 
   run; 
 
       means Trt / BON TUKEY; 
   run;

********* Unbalanced two way ANOVA ******** ;

   data a; 
      input drug disease @; 
      do i=1 to 6; 
         input y @; 
         output; 
      end; 
      datalines; 
   1 1 42 44 36 13 19 22 
   1 2 33  . 26  . 33 21 
   1 3 31 -3  . 25 25 24 
   2 1 28  . 23 34 42 13 
   2 2  . 34 33 31  . 36 
   2 3  3 26 28 32  4 16 
   3 1  .  .  1 29  . 19 
   3 2  . 11  9  7  1 -6 
   3 3 21  1  .  9  3  . 
   4 1 24  .  9 22 -2 15 
   4 2 27 12 12 -5 16 15 
   4 3 22  7 25  5 12  . 
   ; 
 title 'Unbalanced Two-Way Analysis of Variance'; 
   proc glm; 
      class drug disease; 
      model y=drug disease drug*disease / ss1 ss2 ss3 ss4; 
	  lsmeans drug / pdiff=all adjust=tukey; 
   run;

******************** ANCOVA **************;
data drugtest; 
      input Drug $ pretrt posttrt @@; 
      datalines; 
   A 11  6   A  8  0   A  5  2   A 14  8   A 19 11 
   A  6  4   A 10 13   A  6  1   A 11  8   A  3  0 
   D  6  0   D  6  2   D  7  3   D  8  1   D 18 18 
   D  8  4   D 19 14   D  8  9   D  5  1   D 15  9 
   F 16 13   F 13 10   F 11 18   F  9  5   F 21 23 
   F 16 12   F 12  5   F 12 16   F  7  1   F 12 20 
   ; 
 data drugtest;
 set drugtest;
 change=posttrt-pretrt;
 run;
 
*ANCOVA;
proc gplot data=drugtest;
symbol1 c=blue v=star i=r;
symbol2 c=red v=plus i=r;
symbol3 c=green v=star i=r;
axis1 label=(r=0 a=90);
plot posttrt*pretrt=drug/regeqn vaxis=axis1;
run;

 proc glm data=drugtest plots=diagnostics; 
      class Drug; 
      model posttrt = Drug pretrt / solution; *assumes equal slopes model;
      lsmeans Drug / stderr pdiff cov; 
output out=check1 r=residuals p=predicted;
run; 
 
  
*ANCOVA parametrization 1: yij=mu + tau_i + betaX_ij + rho_iX_ij +e_ij;
proc glm data=drugtest plots=diagnostics;
class drug ;
model posttrt=drug pretrt drug*pretrt/solution; *if interaction is not significant then equal slope;
output out=check2 r=residuals p=predicted;
run;

*ANCOVA parametrization 2: yij=tau_i + beta_i*X_ij + e_ij;
proc glm data=drugtest plots=diagnostics;
class drug ;
model posttrt=drug drug*pretrt/noint solution; *fits separate intercepts and slopes for each drug and tests if slopes for all drugs
are zero;
*are all slopes equal?;
contrast 'all slopes equal' drug*pretrt 1 -1 0,
							drug*pretrt 1 0 -1;
run;

* LSMEANS and multiple comparison;
proc glm data=drugtest plots=diagnostics;
class drug ;
model posttrt=drug pretrt drug*pretrt/solution; *if interaction is not significant then equal slope;
lsmeans drug/pdiff adjust=tukey;
lsmeans drug/at pretrt=9 pdiff adjust=tukey;
run;
