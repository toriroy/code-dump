
* Example with interaction;
options ls=64 ps=40;

data ancova2;
 input trt $ x y;
cards;
C 400 1.91
C 413 2.55
C 435 2.03
C 403 1.88
C 432 2.33
C 439 2.11
C 407 2.54
C 399 1.86
1 330 1.55
1 340 1.92
1 353 2.31
1 384 2.26
1 325 1.48
1 374 2.54
1 323 1.3
1 345 2.21
2 321 2.64
2 379 1.81
2 391 2.09
2 371 2.36
2 355 1.62
2 364 2.08
2 389 2.44
2 373 1.69
3 345 1.46
3 380 1.26
3 337 1.4
3 314 2.31
3 368 2.08
3 345 1.56
3 372 1.77
3 410 1.77
;

proc sgplot data=ancova2;
  title "Box plot";
  vbox y / category=trt;
run;

proc sgplot data=ancova2;
    title "Scatter plot to see correlation of y and x";
    scatter x=x y=y / group=trt;
run;

* This plot does not agree with the ANCOVA plot from Proc gLM;
proc sgplot data=ancova2;
    title "Scatter plot to see correlation of y and x in each group";
    reg x=x y=y /  group=trt;
run;
**** using gplot to depict ANCOVA plots**********;
title1 'Plot of the data with lines';
symbol1 v='1' i=rl c=black;	*rl=regression line;
symbol2 v='2' i=rl c=black;
symbol3 v='3' i=rl c=black;
symbol4 v='4' i=rl c=black;
proc gplot data=ancova2;
plot y*x=trt;
run;

proc glm data=ancova2;
 class trt;
 model x=trt/solution;
 *lsmeans trt/diff;
run;

* Here we could use centered x;
proc means data=ancova2;
 var x;
run;

data ancova2;
set ancova2;
x_c=x- 372.375;
run;

proc glm data=ancova2;
 class trt;
 model y=trt x/solution;
 lsmeans trt/diff;
run;

proc glm data=ancova2;
 class trt;
 model y=trt x trt*x/solution;
 lsmeans trt/diff;
run;

* This provides all the plots needed for checking constancy of slopes and diffdigram;
ods graphics on;
proc glm data=ancova2 plot=meanplot(cl);
 class trt;
 model y=trt x trt*x/solution clparm;
 lsmeans trt/ stderr pdiff cov out=adjmeans;
   run;
ods graphics off;

proc glm data=ancova2;
 class trt;
 model y=trt x(trt)/ solution;
 contrast 'slope 1 vs C' x(trt) 1 0 0 -1;
 contrast 'slope 2 vs C' x(trt) 0 1 0 -1;
 contrast 'slope 3 vs C' x(trt) 0 0 1 -1;
 contrast 'equal slopes' x(trt) 1 0 0 -1,
                         x(trt) 0 1 0 -1,
                         x(trt) 0 0 1 -1;
run;

proc means data=ancova2;
class trt;
 var x;
run;

* since interaction is significant, we might try to report the cell means at mean value of X for each trt;
proc glm data=ancova2;
 class trt;
 model y=trt x/solution clparm;
 lsmeans trt/diff;
 lsmeans trt/at x=0;
 estimate 'intcpt t=1' intercept 1 trt 1 0 0 0;
 estimate 'intcpt t=2' intercept 1 trt 0 1 0 0;
 estimate 'intcpt t=3' intercept 1 trt 0 0 1 0;
 estimate 'intcpt t=c' intercept 1 trt 0 0 0 1;
 estimate 'mean at t=1' intercept 1 trt 1 0 0 0 x 346.75;
 estimate 'mean at t=2' intercept 1 trt 0 1 0 0 x 367.88;
 estimate 'mean at t=3' intercept 1 trt 0 0 1 0 x 358.88;
 estimate 'mean at t=c' intercept 1 trt 0 0 0 1 x 416.00;

run;

* here it won't change since there is no interaction;
proc glm data=ancova2;
 class trt;
 model y=trt x/solution clparm;
 lsmeans trt/diff;
 lsmeans trt/diff at x=0;
 lsmeans trt/ diff at x=346.75;
run;

*here it will change with the interwction;
proc glm data=ancova2;
 class trt;
 model y=trt x trt*x/solution clparm;
 lsmeans trt/diff;
 lsmeans trt/diff at x=0;
 lsmeans trt/ diff at x=346.75;
run;

* comparing the three types of sum of squares;
* result in same values for balanced designs but differ for unbalanced;
proc glm data=ancova2;
 class trt;
 model y=trt /ss1 ss2 ss3;
run;
proc glm data=ancova2;
 class trt;
 model y=trt x /ss1 ss2 ss3;
run;
proc glm data=ancova2;
 class trt;
 model y=trt x trt*x/ss1 ss2 ss3;
run;

