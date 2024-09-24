/*******************************************************************
CHAPTER 9, EXAMPLE 2
Analysis of the ultrafiltration data by fitting a random
coefficient model in transmembrane pressure (mmHg)
- the repeated measurement factor is transmembrane pressure (tmp)
- there is one "treatment" factor, center
- the response is ultrafiltration rate (ufr, ml/hr)
The model for each dialyzer is a straight line. The intercepts
and slopes have different means for each center. The covariance
matrix D is the same for each center. The matrix Ri is taken
to be diagonal with variance sigma^2 for all units.
We use the RANDOM statement to fit the random coefficient model.
These data are unbalanced both in the sense that the pressures
under which each dialyzer is observed are different.
*******************************************************************/
options ls=80 ps=59 nodate; run;
/******************************************************************
Read in the data set
*******************************************************************/
data ultra; infile 'ultra.dat';
input subject tmp ufr center;
* rescale the pressures -- see Chapter 8;
tmp=tmp/1000;
run;
/*******************************************************************
Use PROC MIXED to fit the random coefficient model via the
RANDOM statement. For all of the fits, we use REML.
The SOLUTION option in the MODEL statement requests that the
estimates of the regression parameters be printed.
In all cases, we take the (2 x 2) matrix D to be unstructured
(TYPE=UN) in the RANDOM statement.
The G and GCORR options in the RANDOM statement asks that
the D matrix and its corresponding correlation matrix
be printed. The V and VCORR options ask that the overall
Sigma matrix be printed (for the first subject or particular
subjects).
To fit a random coefficient model, we must specify that both
intercept and slope are random in the RANDOM statement.
No REPEATED statement is used because we assume Ri = sigma^2 I,
which is the default.
*******************************************************************/
* "Full" model with different intercept, slope for each center;
title 'FULL MODEL, FIT BY REML';
proc mixed data=ultra;
class center subject;
model ufr = center center*tmp / noint solution ;
random intercept tmp / type=un subject=subject g gcorr v vcorr;
contrast 'diff in slope' center 0 0 0 center*tmp 1 -1 0,
center 0 0 0 center*tmp 1 0 -1 / chisq;
contrast 'diff in int' center 1 -1 0 center*tmp 0 0 0 ,
center 1 0 -1 center*tmp 0 0 0 / chisq;
estimate 'slope 1 vs 2' center 0 0 0 center*tmp 1 -1 0 ;
estimate 'slope 1 vs 3' center 0 0 0 center*tmp 1 0 -1 ;
estimate 'slope 2 vs 3' center 0 0 0 center*tmp 0 1 -1 ;
run;
title 'FULL MODEL, FIT BY ML';
proc mixed method=ml data=ultra;
class center subject;
model ufr = center center*tmp / noint solution ;
random intercept tmp / type=un subject=subject g gcorr v vcorr;
contrast 'diff in slope' center 0 0 0 center*tmp 1 -1 0,
center 0 0 0 center*tmp 1 0 -1 / chisq;
contrast 'diff in int' center 1 -1 0 center*tmp 0 0 0 ,
center 1 0 -1 center*tmp 0 0 0 / chisq;
estimate 'slope 1 vs 2' center 0 0 0 center*tmp 1 -1 0 ;
estimate 'slope 1 vs 3' center 0 0 0 center*tmp 1 0 -1 ;
estimate 'slope 2 vs 3' center 0 0 0 center*tmp 0 1 -1 ;
run;
* "Reduced" model with different intercepts but same slope for all;
* centers;
title 'REDUCED MODEL WITH DIFF INTERCEPTS, COMMON SLOPE, FIT BY ML';
proc mixed method=ml data=ultra;
class center subject;
model ufr = center tmp / noint solution ;
random intercept tmp / type=un subject=subject g gcorr v vcorr;
run;
