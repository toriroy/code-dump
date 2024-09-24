/* EXAMPLE 2 { DIALYZER DATA: In the following program, we consider the model that assumes that
the mean response is a straight line as a function of time for each center. */;

/*******************************************************************
CHAPTER 8, EXAMPLE 2
Analysis of the ultrafiltration data by fitting a general linear
regression model in transmembrane pressure (mmHg)
- the repeated measurement factor is transmembrane pressure (tmp)
- there is one "treatment" factor, center
- the response is ultrafiltration rate (ufr, ml/hr)
For each center, the mean model is a straight line in time.
We use the REPEATED statement of PROC MIXED with the
TYPE= options to fit the model assuming various covariance structures.
These data are unbalanced both in the sense that the pressures
under which each dialyzer is observed are different.
*******************************************************************/
options ls=80 ps=59 nodate; run;
/******************************************************************
Read in the data set
*******************************************************************/
data ultra; infile 'ultra.dat';
input subject tmp ufr center;
* rescale the pressures;
tmp=tmp/100;
run;
/*******************************************************************
Fit the straight line model assuming that the covariance
structure of a data vector is diagonal with constant variance;
i.e. using ordinary least squares.
We use PROC GLM with the SOLUTION and NOINT options to fit
the three separate intercepts/slopes parameterization.
*******************************************************************/
title "FIT USING ORDINARY LEAST SQUARES";
proc glm data=ultra;
class center;
model ufr = center center*tmp / noint solution;
run;
/*******************************************************************
Now use PROC MIXED to fit the more general regression model with
assumptions about the covariance matrix of a data vector. We show
two, assuming the covariance is similar across centers.
The SOLUTION option in the MODEL statement requests that the
estimates of the regression parameters be printed.
The R option in the REPEATED statement as used here requests that
the covariance matrix estimate be printed in matrix form. We also
print the correlation matrix using the RCORR option.
*******************************************************************/
* compound symmetry;
title "FIT WITH COMPOUND SYMMETRY";
proc mixed data=ultra method=ml;
class subject center ;
model ufr = center center*tmp / noint solution covb;
repeated / type = cs subject=subject r rcorr;
run;
* Markov;
title "FIT WITH MARKOV STRUCTURE";
proc mixed data=ultra method=ml;
class subject center ;
model ufr = center center*tmp / noint solution covb;
repeated / type = sp(pow)(tmp) subject=subject r rcorr;
run;
* using the alternative parameterization to get the chi-square tests;
title "FIT WITH MARKOV STRUCTURE AND DIFFERENCE PARAMETERIZATION";
proc mixed data=ultra method=ml;
class subject center ;
model ufr = center tmp center*tmp / solution covb chisq;
repeated / type = sp(pow)(tmp) subject=subject r rcorr;
run;
