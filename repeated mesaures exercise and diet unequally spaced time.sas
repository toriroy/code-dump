****************************************************************************************** ;
* Unequally Spaced Time Points ;
* Parametric Modeling of Time and Pulse relationship (linear and quadratic);
/*
This study is similar to the exercise-diet-pulse study discussed earlier except that in this new study the pulse 
measurements were not taken at regular time points.  In this study a baseline pulse measurement was obtained at 
time = 0 for every individual in the study. However, subsequent pulse measurements were taken at less regular 
time intervals.  The second pulse measurements were taken at approximately 2 minutes (time = 120 seconds); 
the pulse measurement was obtained at approximately 5 minutes (time = 300 seconds); 
and the fourth and final pulse measurement was obtained at approximately 10 minutes (time = 600 seconds). 
*/;
data study2;
  input id timec exertype diet pulse time;
cards;
1 1 1 1 90 0
1 2 1 1 92 228
1 3 1 1 93 296
1 4 1 1 93 639
2 1 1 1 90 0
2 2 1 1 92 56
2 3 1 1 93 434
2 4 1 1 93 538
3 1 1 1 97 0
3 2 1 1 97 150
3 3 1 1 94 295
3 4 1 1 94 541
4 1 1 1 80 0
4 2 1 1 82 121
4 3 1 1 83 256
4 4 1 1 83 575
5 1 1 1 91 0
5 2 1 1 92 161
5 3 1 1 91 252
5 4 1 1 91 526
6 1 1 2 83 0
6 2 1 2 83 73
6 3 1 2 84 320
6 4 1 2 84 570
7 1 1 2 87 0
7 2 1 2 88 40
7 3 1 2 90 325
7 4 1 2 90 730
8 1 1 2 92 0
8 2 1 2 94 205
8 3 1 2 95 276
8 4 1 2 95 761
9 1 1 2 97 0
9 2 1 2 99 57
9 3 1 2 96 244
9 4 1 2 96 695
10 1 1 2 100 0
10 2 1 2 97 143
10 3 1 2 100 296
10 4 1 2 100 722
11 1 2 1 86 0
11 2 2 1 86 83
11 3 2 1 84 262
11 4 2 1 84 566
12 1 2 1 93 0
12 2 2 1 103 116
12 3 2 1 104 357
12 4 2 1 104 479
13 1 2 1 90 0
13 2 2 1 92 191
13 3 2 1 93 280
13 4 2 1 93 709
14 1 2 1 95 0
14 2 2 1 96 112
14 3 2 1 100 219
14 4 2 1 100 367
15 1 2 1 89 0
15 2 2 1 96 96
15 3 2 1 95 339
15 4 2 1 95 639
16 1 2 2 84 0
16 2 2 2 86 92
16 3 2 2 89 351
16 4 2 2 89 508
17 1 2 2 103 0
17 2 2 2 109 196
17 3 2 2 114 213
17 4 2 2 120 634
18 1 2 2 92 0
18 2 2 2 96 117
18 3 2 2 101 227
18 4 2 2 101 614
19 1 2 2 97 0
19 2 2 2 98 70
19 3 2 2 100 295
19 4 2 2 100 515
20 1 2 2 102 0
20 2 2 2 104 165
20 3 2 2 103 302
20 4 2 2 103 792
21 1 3 1 93 0
21 2 3 1 98 100
21 3 3 1 110 396
21 4 3 1 115 498
22 1 3 1 98 0
22 2 3 1 104 104
22 3 3 1 112 310
22 4 3 1 117 518
23 1 3 1 98 0
23 2 3 1 105 148
23 3 3 1 118 208
23 4 3 1 121 677
24 1 3 1 87 0
24 2 3 1 122 171
24 3 3 1 127 320
24 4 3 1 133 633
25 1 3 1 94 0
25 2 3 1 110 57
25 3 3 1 116 268
25 4 3 1 119 657
26 1 3 2 95 0
26 2 3 2 126 163
26 3 3 2 143 382
26 4 3 2 147 501
27 1 3 2 100 0
27 2 3 2 126 70
27 3 3 2 140 347
27 4 3 2 148 737
28 1 3 2 103 0
28 2 3 2 124 61
28 3 3 2 140 263
28 4 3 2 143 588
29 1 3 2 94 0
29 2 3 2 135 164
29 3 3 2 130 353
29 4 3 2 137 560
30 1 3 2 99 0
30 2 3 2 111 114
30 3 3 2 140 362
30 4 3 2 148 501
;
run;

ods rtf file="I:\bmtry702\BMTRY702\Fall 2010\data and sas code\Unequally Spaced Time Points.rtf ";

** to compare the different models use LRT after fitting each model with method=ML;
** to select covariance model after identifying the correct mean model, use AIC/BIC with REML;

* 2. overall scatterplot of everyone ;
proc sort data=study2;
  by id time;
run;
goptions reset=all;
symbol1 c=blue v=star h=.8 i=j r=10;
symbol2 c=red v=dot h=.8 i=j r=10;
symbol3 c=green v=square h=.8 i=j r=10;
axis1 order=(60 to 150 by 30) label=(a=90 'Pulse');
proc gplot data=study2;
  plot pulse*time=id  / vaxis=axis1;
run;

* 3. Fit data with linear model ;
proc mixed data=study2 covtest noclprint;
  class id timec exertype ;
  model pulse = time exertype time*exertype time*time time*time*exertype / solution  outpm = pred1f;
  repeated timec/ subject = id type=un;
run;

* The output file pred1f contains the predicted values based on the fixed part of the model.  
* we can illustrate what the predicted values of pulse look like using plot below. ;
goptions reset=all;
symbol1 c=blue v=star h=.8 i=j;
symbol2 c=red v=dot h=.8 i=j;
symbol3 c=green v=square h=.8 i=j;
axis1 order=(60 to 150 by 30) label=(a=90 'Predicted Pulse');
proc gplot data=pred1f;
  plot pred*time=exertype  /vaxis=axis1;
run;
quit;

* We can include the observed pulse as well and see that this model is not fitting very well at all.  ;
* The green line is fitting curved data with a straight line. ;
proc sort data=pred1f;
  by time;
run;
goptions reset=all;
symbol1 c=blue  v=star   h=.8 i=j      w=10;
symbol2 c=red   v=dot    h=.8 i=j      w=10;
symbol3 c=green v=square h=.8 i=j      w=10;
symbol4 c=blue  v=star   h=.8 i=j      r=10;
symbol5 c=red   v=dot    h=.8 i=j      r=10;
symbol6 c=green v=square h=.8 i=j      r=10;
axis1 order=(60 to 150 by 30) label=(a=90 'Predicted and Observed Pulse');
proc gplot data=pred1f;
  plot pred*time=exertype / vaxis=axis1 ;
  plot2 pulse*time = id   / vaxis=axis1 ;;
run;
quit;

* Modeling Time as a Quadratic Predictor of Pulse

* quadratic model ;
proc mixed data=study2 covtest noclprint;
  class id timec exertype;
  model pulse = time exertype time*exertype time*time / solution outpm=pred2f ;
  repeated timec/ subject = id type=un;
run;

* Below we see the predicted values from this model with the quadratic effect of time.;
proc sort data=pred2f;
  by time;
run;
goptions reset=all;
symbol1 c=blue v=star h=.8 i=j ;
symbol2 c=red v=dot h=.8 i=j ;
symbol3 c=green v=square h=.8 i=j ;
axis1 order=(60 to 150 by 30) label=(a=90 'Predicted Pulse');
proc gplot data=pred2f;
  plot pred*time=exertype      /vaxis=axis1 ;
run;
quit;

* Again, we can plot the predicted values against the actual values of pulse.;
* We see that this model fits better, but it appears that the predicted values ;
* for the green group have too little curvature and the red and blue group have too much curvature.;
proc sort data=pred2f;
  by time;
run;
goptions reset=all;
symbol1 c=blue  v=star   h=.8 i=j      w=10;
symbol2 c=red   v=dot    h=.8 i=j      w=10;
symbol3 c=green v=square h=.8 i=j      w=10;
symbol4 c=blue  v=star   h=.8 i=j      r=10;
symbol5 c=red   v=dot    h=.8 i=j      r=10;
symbol6 c=green v=square h=.8 i=j      r=10;
axis1 order=(60 to 150 by 30) label=(a=90 'Predicted and Observed Pulse');
proc gplot data=pred2f;
  plot pred*time=exertype / vaxis=axis1 ;
  plot2 pulse*time = id   / vaxis=axis1 ;;
run;
quit;

* Modeling Time as a Quadratic Predictor of Pulse, Interacting by Exertype ;
* quadratic model , model 3 ;
proc mixed data=study2 covtest noclprint;
  class id timec exertype;
  model pulse = time exertype time*exertype time*time time*time*exertype / solution  outpm=pred3f ;
  repeated timec/ subject = id type=un;
run;

* predicted vs. actual  ;
proc sort data=pred3f;
  by time;
run;
goptions reset=all;
symbol1 c=blue  v=star   h=.8 i=j      w=10;
symbol2 c=red   v=dot    h=.8 i=j      w=10;
symbol3 c=green v=square h=.8 i=j      w=10;
symbol4 c=blue  v=star   h=.8 i=j      r=10;
symbol5 c=red   v=dot    h=.8 i=j      r=10;
symbol6 c=green v=square h=.8 i=j      r=10;
axis1 order=(60 to 150 by 30) label=(a=90 'Predicted and Observed Pulse');
proc gplot data=pred3f;
  plot pred*time=exertype / vaxis=axis1 ;
  plot2 pulse*time = id   / vaxis=axis1 ;;
run;
quit;

ods rtf close;


* we could also compare the fit of the models using AIC/BIC criterion;

* how about using other covariance structures?;

***** Random Coefficient Models *********;
ods rtf file="I:\bmtry702\BMTRY702\Fall 2010\data and sas code\Unequally Spaced Time Points RE models.rtf ";
* 2. overall scatterplot of everyone ;
proc sort data=study2;
  by id time;
run;
goptions reset=all;
symbol1 c=blue v=star h=.8 i=j r=10;
symbol2 c=red v=dot h=.8 i=j r=10;
symbol3 c=green v=square h=.8 i=j r=10;
axis1 order=(60 to 150 by 30) label=(a=90 'Pulse');
proc gplot data=study2;
  plot pulse*time=id  / vaxis=axis1;
run;

* 3. Fit data with linear model ;
proc mixed data=study2 covtest noclprint;
  class id exertype ;
  model pulse = time exertype time*exertype / solution outp=pred1r outpm = pred1f;
  random intercept time / subject = id;
run;

* The output file pred1f contains the predicted values based on the fixed part of the model.  
* we can illustrate what the predicted values of pulse look like using plot below. ;
goptions reset=all;
symbol1 c=blue v=star h=.8 i=j;
symbol2 c=red v=dot h=.8 i=j;
symbol3 c=green v=square h=.8 i=j;
axis1 order=(60 to 150 by 30) label=(a=90 'Predicted Pulse');
proc gplot data=pred1f;
  plot pred*time=exertype  /vaxis=axis1;
run;
quit;

* We can include the observed pulse as well and see that this model is not fitting very well at all.  ;
* The green line is fitting curved data with a straight line. ;
proc sort data=pred1f;
  by time;
run;
goptions reset=all;
symbol1 c=blue  v=star   h=.8 i=j      w=10;
symbol2 c=red   v=dot    h=.8 i=j      w=10;
symbol3 c=green v=square h=.8 i=j      w=10;
symbol4 c=blue  v=star   h=.8 i=j      r=10;
symbol5 c=red   v=dot    h=.8 i=j      r=10;
symbol6 c=green v=square h=.8 i=j      r=10;
axis1 order=(60 to 150 by 30) label=(a=90 'Predicted and Observed Pulse');
proc gplot data=pred1f;
  plot pred*time=exertype / vaxis=axis1 ;
  plot2 pulse*time = id   / vaxis=axis1 ;;
run;
quit;

* Modeling Time as a Quadratic Predictor of Pulse

* quadratic model ;
proc mixed data=study2 covtest noclprint;
  class id exertype;
  model pulse = time exertype time*exertype time*time / solution outp=pred2r outpm=pred2f ;
  random intercept time / subject = id;
run;

* Below we see the predicted values from this model with the quadratic effect of time.;
proc sort data=pred2f;
  by time;
run;
goptions reset=all;
symbol1 c=blue v=star h=.8 i=j ;
symbol2 c=red v=dot h=.8 i=j ;
symbol3 c=green v=square h=.8 i=j ;
axis1 order=(60 to 150 by 30) label=(a=90 'Predicted Pulse');
proc gplot data=pred2f;
  plot pred*time=exertype      /vaxis=axis1 ;
run;
quit;

* Again, we can plot the predicted values against the actual values of pulse.;
* We see that this model fits better, but it appears that the predicted values ;
* for the green group have too little curvature and the red and blue group have too much curvature.;
proc sort data=pred2f;
  by time;
run;
goptions reset=all;
symbol1 c=blue  v=star   h=.8 i=j      w=10;
symbol2 c=red   v=dot    h=.8 i=j      w=10;
symbol3 c=green v=square h=.8 i=j      w=10;
symbol4 c=blue  v=star   h=.8 i=j      r=10;
symbol5 c=red   v=dot    h=.8 i=j      r=10;
symbol6 c=green v=square h=.8 i=j      r=10;
axis1 order=(60 to 150 by 30) label=(a=90 'Predicted and Observed Pulse');
proc gplot data=pred2f;
  plot pred*time=exertype / vaxis=axis1 ;
  plot2 pulse*time = id   / vaxis=axis1 ;;
run;
quit;

* Modeling Time as a Quadratic Predictor of Pulse, Interacting by Exertype ;
* quadratic model with interaction;
proc mixed data=study2 covtest noclprint;
  class id exertype;
  model pulse = time exertype time*exertype time*time time*time*exertype / solution outp=pred3r outpm=pred3f ;
  random intercept time / subject = id;
run;

* predicted vs. actual  ;
proc sort data=pred3f;
  by time;
run;
goptions reset=all;
symbol1 c=blue  v=star   h=.8 i=j      w=10;
symbol2 c=red   v=dot    h=.8 i=j      w=10;
symbol3 c=green v=square h=.8 i=j      w=10;
symbol4 c=blue  v=star   h=.8 i=j      r=10;
symbol5 c=red   v=dot    h=.8 i=j      r=10;
symbol6 c=green v=square h=.8 i=j      r=10;
axis1 order=(60 to 150 by 30) label=(a=90 'Predicted and Observed Pulse');
proc gplot data=pred3f;
  plot pred*time=exertype / vaxis=axis1 ;
  plot2 pulse*time = id   / vaxis=axis1 ;;
run;
quit;

ods rtf close;











