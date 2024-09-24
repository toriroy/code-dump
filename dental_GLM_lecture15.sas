/*******************************************************************
Analysis of the dental study data by fitting a general linear regression model in time and gender structures using PROC MIXED.
- the repeated measurement factor is age (time)
- there is one "treatment" factor, gender
For each gender, the "full" mean model is a straight line in time.
We use the REPEATED statement of PROC MIXED with the
TYPE= options to fit the model assuming several different covariance structures.
*******************************************************************/
options ls=80 ps=59 nodate; run;
/******************************************************************
Read in the data set (See Example 1 of Chapter 4)
*******************************************************************/
data dent1; infile 'I:\bmtry702\bmtry702\resources\davidian\dental.dat';
input obsno child age distance gender;
ag = age*gender;
run;
/*******************************************************************
Sort the data so we can do gender-by-gender fits.
*******************************************************************/
proc sort data=dent1; by gender; run;
/*******************************************************************
First the straight line model separately for each gender and
simultaneously for both genders assuming that the covariance
structure of a data vector is diagonal with constant variance; that
is, use ordinary least squares for each gender separately and
then together.
*******************************************************************/
title "ORDINARY LEAST SQUARES FITS BY GENDER";
proc reg data=dent1; by gender;
model distance = age;
run;
title "ORDINARY LEAST SQUARES FIT WITH BOTH GENDERS";
proc reg data=dent1;
model distance = gender age ag;
run;
/*******************************************************************
Now use PROC MIXED to fit the more general regression model with
assumptions about the covariance matrix of a data vector. For all
of the fits, we use usual normal maximum likelihood (ML) rather
than restricted maximum likelihood (REML), which is the default.
We do this for each gender separately first using the unstructured
assumption. The main goal is to get insight into whether it might
be the case that the covariance matrix is different for each gender
(e.g. variation is different for each).
The SOLUTION option in the MODEL statement requests that the
estimates of the regression parameters be printed.
The R option in the REPEATED statement as used here requests that
the covariance matrix estimate be printed in matrix form. The
RCORR option requests that the corresponding correlation matrix
be printed.
*******************************************************************/
* unstructured covariance matrix;
title "FIT WITH UNSTRUCTURED COVARIANCE FOR EACH GENDER";
proc mixed method=ml data=dent1; by gender;
class child;
model distance = age / solution;
repeated / type = un subject=child r rcorr;
run;
/*******************************************************************
Now do the same analyses with both genders simultaneously.
Consider several models, allowing the covariance matrix to
be either the same or different for each gender using the
GROUP = option, which allows for different covariance
parameters for each GROUP (genders here).
For the fit using TYPE = CS (Compound symmetry) assumed the
same for each group, we illustrate how to fit the two
different parameterizations of the full model. For all other
fits, we just use the second parameterization.
The CHISQ option in the MODEL statement requests that the Wald chi-square
test statistics be printed for certain contrasts of the regression
parameters (see the discussion of the OUTPUT). We only use this for
the second parameterization -- the TESTS OF FIXED EFFECTS are tests
of interest (different intercepts, slopes) in this case.
*******************************************************************/
* compound symmetry with separate intercept and slope for;
* each gender;
title "COMMON COMPOUND SYMMETRY STRUCTURE";
proc mixed method=ml data=dent1;
class gender child;
model distance = gender gender*age / noint solution ;
repeated / type = cs subject = child r rcorr;
run;
* compound symmetry with the "difference" parameterization;
* same for each gender;
title "COMMON COMPOUND SYMMETRY STRUCTURE";
proc mixed method=ml data=dent1;
class gender child;
model distance = gender age gender*age / solution chisq;
repeated / type = cs subject = child r rcorr;
run;
* ar(1) same for each gender;
title "COMMON AR(1) STRUCTURE";
proc mixed method=ml data=dent1;
class gender child ;
model distance = gender age age*gender / solution chisq;
repeated / type = ar(1) subject=child r rcorr;
run;
* one-dependent same for each gender;
title "COMMON ONE-DEPENDENT STRUCTURE";
proc mixed method=ml data=dent1;
class gender child ;
model distance = gender age age*gender / solution chisq;
repeated / type = toep(2) subject=child r rcorr;
run;
* compound symmetry, different for each gender;
title "SEPARATE COMPOUND SYMMETRY FOR EACH GENDER";
proc mixed method=ml data=dent1;
class gender child ;
model distance = gender age age*gender / solution chisq;
repeated / type = cs subject=child r rcorr group=gender;
run;
* ar(1), different for each gender;
title "SEPARATE AR(1) FOR EACH GENDER";
proc mixed method=ml data=dent1;
class gender child ;
model distance = gender age age*gender / solution chisq;
repeated / type = ar(1) subject=child r rcorr group=gender;
run;
* one-dependent, different for each gender;
title "SEPARATE ONE-DEPENDENT FOR EACH GENDER";
proc mixed method=ml data=dent1;
class gender child;
model distance = gender age age*gender / solution chisq;
repeated / type = toep(2) subject=child r rcorr group=gender;
run;
/*******************************************************************
Examination of the AIC, BIC, and loglikelihood ratios from the
above fits indicates that
- a model that allows a separate covariance matrix of the same
type for each gender is preferred
- the compound symmetry structure for each gender is preferred
Thus, for this model, we fit
- the full model again, now asking for the covariance matrix
of beta-hat to be printed using the COVB option;
- the reduced model (equal slopes)
- the full model using REML
This will allow a "full" vs. "reduced" likelihood ratio test of
equal slopes to be performed (by hand from the output).
We fit the first parameterization this time, so that the estimates
are interpreted as the gender-specific intercepts and slopes.
Thus, the TESTS OF FIXED EFFECTS in the output should be disregarded.
*******************************************************************/
* full model again with covariance matrix of betahat printed;
title "FULL MODEL WITH COMPOUND SYMMETRY FOR EACH GENDER";
proc mixed method=ml data=dent1;
class gender child;
model distance = gender gender*age / noint solution covb;
repeated / type=cs subject=child r rcorr group=gender;
run;
* reduced model;
title "REDUCED MODEL WITH COMPOUND SYMMETRY FOR EACH GENDER";
proc mixed method=ml data=dent1;
class gender child;
model distance = gender age / noint solution covb;
repeated / type=cs subject=child r rcorr group=gender;
run;
* full model using REML (the default, so no METHOD= is specified);
* use ESTIMATE statement to estimate the mean for a boy of age 11;
title "FULL MODEL WITH COMPOUND SYMMETRY FOR EACH GENDER, REML";
proc mixed data=dent1;
class gender child;
model distance = gender gender*age / noint solution covb;
repeated / type=cs subject=child r rcorr group=gender;
estimate 'boy at 11' gender 0 1 gender*age 0 11;
run;
* also fit full model in first parameterization to get chi-square tests;
title "FULL MODEL, DIFFERENCE PARAMETERIZATION";
proc mixed method=ml data=dent1;
class gender child;
model distance = gender age gender*age / solution chisq covb;
repeated / type=cs subject=child r rcorr group=gender;
run;

* spline aanalysis;
data spline;
set formixed;
st1=min(age, 10); *knot at time=2;
st2=max(0, age-10);
run;
proc mixed data = spline;
class person age gender;
model y=gender st1 st2 st1*gender st2*gender / s chisq; * chisq provides likelihood ratio test in addition to F test;
repeated age/ type=un subject=person r;
run;

proc mixed data = spline method=ml;
class person age gender;
model y=gender st1 st2 st1*gender st2*gender / s chisq; * chisq provides likelihood ratio test in addition to F test;
repeated age/ type=cs subject=person r;
run;
