/*******************************************************************
Analysis of the dental study data by fitting a random coefficient model in time using PROC MIXED.
- the repeated measurement factor is age (time)
- there is one "treatment" factor, gender
The model for each child is assumed to be a straight line. The intercepts and slopes may have different means depending on
gender, with the same covariance matrix G for each gender.
We use the RANDOM and REPEATED statements to fit models that make several different assumptions about the forms of the matrices Ri and G.
*******************************************************************/
options ls=80 ps=59 nodate; run;
/******************************************************************
Read in the data set 
*******************************************************************/
data dent1; infile 'I:\bmtry702\bmtry702\resources\davidian\dental.dat';
input obsno child age distance gender;
run;
/*******************************************************************
Use PROC MIXED to fit the random coefficient model via the RANDOM statement. For all of the fits, we use usual normal
ML rather than REML (the default). In all cases, we use the usual parameterization for the mean model. 
The G and GCORR options in the RANDOM statement asks that the G matrix and the corresponding correlation matrix it implies be printed. 
The V and VCORR options ask that the overall Sigma matrix be printed (for the first subject or particular subjects).
To fit a random coefficient model, we must specify that either intercept or slope are random in the RANDOM statement.
If no REPEATED statement appears, then PROC MIXED assumes that Ri = sigma^2*I. Otherwise, we use a REPEATED statement to set a structure for Ri with the TYPE = option.
*******************************************************************/

* MODEL (0);
* Ri = diagonal with constant variance sigma^2 same in both genders;
* No REPEATED statement necessary to fit this Ri (default);
* G = (1x1) unstructured matrix same for both genders;
* Specified in the RANDOM statement;
title 'RANDOM INTERCEPT MODEL WITH DIAGONAL WITHIN-CHILD';
title2 'COVARIANCE MATRIX WITH CONSTANT VARIANCE SAME FOR EACH GENDER';
title3 'SAME G MATRIX FOR BOTH GENDERS';
proc mixed method=ml data=dent1;
class gender child;
model distance = age gender gender*age / solution;
random intercept / type=un subject=child g gcorr v vcorr;
estimate 'diff in mean slope'  gender 0 0 gender*age 1 -1;
contrast 'overall gender diff' gender 1 -1, gender*age 1 -1 /chisq;
run;

* MODEL (i);
* Ri = diagonal with constant variance sigma^2 same in both genders;
* No REPEATED statement necessary to fit this Ri (default);
* G = (2x2) unstructured matrix same for both genders;
* Specified in the RANDOM statement;
title 'RANDOM COEFFICIENT MODEL WITH DIAGONAL WITHIN-CHILD';
title2 'COVARIANCE MATRIX WITH CONSTANT VARIANCE SAME FOR EACH GENDER';
title3 'SAME G MATRIX FOR BOTH GENDERS';
proc mixed method=ml data=dent1;
class gender child;
model distance = age gender gender*age / solution;
random intercept age / type=un subject=child g gcorr v vcorr;
estimate 'diff in mean slope' gender 0 0 gender*age 1 -1;
contrast 'overall gender diff' gender 1 -1, gender*age 1 -1 /chisq;
run;
* MODEL (ii-a);
* Fit the same model but with a separate diagonal Ri matrix for each gender.;
* Thus, there are 2 separate variances sigma^2_(G and B);
* G  = (1x1) unstructured matrix same for both genders;
* Specified in the RANDOM statement;
title 'RANDOM COEFFICIENT MODEL WITH DIAGONAL WITHIN-CHILD';
title2 'COVARIANCE MATRIX WITH SEPARATE CONSTANT VARIANCE FOR EACH GENDER';
title3 'SAME G MATRIX FOR BOTH GENDERS';
ods graphics on;
proc mixed method=ml data=dent1 plots=all;
class child gender;
model distance = age gender gender*age / solution;
repeated / group=gender subject=child; * allows for heterogenous R side variance for each gender;
random intercept / type=un subject=child g gcorr v vcorr;
estimate 'diff in mean slope' gender 0 0 gender*age 1 -1;
contrast 'overall gender diff' gender 1 -1, gender*age 1 -1 /chisq;
run;
ods graphics off;

* MODEL (ii-b);
* Fit the same diagonal Ri matrix;
* G  = (1x1) unstructured matrix different by gender;
* Specified in the RANDOM statement;
title 'RANDOM COEFFICIENT MODEL WITH DIAGONAL WITHIN-CHILD';
title2 'COVARIANCE MATRIX WITH SAME R MATRIX FOR EACH GENDER';
title3 'DIFFERENT G MATRIX FOR BOTH GENDERS';
proc mixed method=ml data=dent1;
class child gender;
model distance = age gender gender*age / solution;
random intercept / group=gender type=un subject=child g gcorr v vcorr;
estimate 'diff in mean slope' gender 0 0 gender*age 1 -1;
contrast 'overall gender diff' gender 1 -1, gender*age 1 -1 /chisq;
run;
* MODEL (ii-c);
* Fit the same diagonal Ri matrix;
* Fit the same model but with a separate diagonal Ri matrix for each gender.;
* Thus, there are 2 separate variances sigma^2_(G and B);
* Specified in the RANDOM statement;
title 'RANDOM COEFFICIENT MODEL WITH DIAGONAL WITHIN-CHILD';
title2 'COVARIANCE MATRIX WITH VARYING R MATRIX FOR EACH GENDER';
title3 'DIFFERENT G MATRIX FOR BOTH GENDERS';
proc mixed method=ml data=dent1;
class child gender;
model distance = age gender gender*age / solution;
repeated / group=gender subject=child; * allows for heterogenous R side variance for each gender;
random intercept / group=gender type=un subject=child g gcorr v vcorr;
estimate 'diff in mean slope' gender 0 0 gender*age 1 -1;
contrast 'overall gender diff' gender 1 -1, gender*age 1 -1 /chisq;
run;
* MODEL (iii);
* Fit the same model but with a separate diagonal Ri matrix for each gender.;
* Thus, there are 2 separate variances sigma^2_(G and B);
* G still = (2x2) unstructured matrix same for both genders;
* Specified in the RANDOM statement;
title 'RANDOM COEFFICIENT MODEL WITH DIAGONAL WITHIN-CHILD';
title2 'COVARIANCE MATRIX WITH SEPARATE CONSTANT VARIANCE FOR EACH GENDER';
title3 'SAME G MATRIX FOR BOTH GENDERS';
proc mixed method=ml data=dent1;
class child gender;
model distance = age gender gender*age / solution;
repeated / group=gender subject=child; * allows for heterogenous R side variance for each gender;
random intercept age / type=un subject=child g gcorr v vcorr;
estimate 'diff in mean slope' gender 0 0 gender*age 1 -1;
contrast 'overall gender diff' gender 1 -1, gender*age 1 -1 /chisq;
run;
* MODEL (iv);
* Fit the same model but with a separate diagonal Ri matrix for each gender, where Ri is AR(1).;
* Thus, there are 2 separate variances sigma^2_(G and B);
* G still = (2x2) unstructured matrix differs across genders;
* Specified in the RANDOM statement by the GROUP=GENDER option;
title 'RANDOM COEFFICIENT MODEL WITH DIAGONAL WITHIN-CHILD';
title2 'COVARIANCE MATRIX WITH SEPARATE CONSTANT VARIANCE FOR EACH GENDER';
title3 'DIFFERENT G MATRIX FOR BOTH GENDERS';
proc mixed method=ml data=dent1;
class child gender;
model distance = age gender gender*age / solution;
repeated / type=AR(1) group=gender subject=child; * allows for AR(1) R-side for each gender;
random intercept age / type=un group=gender subject=child g gcorr v vcorr;
estimate 'diff in mean slope' gender 0 0 gender*age 1 -1;
contrast 'overall gender diff' gender 1 -1, gender*age 1 -1 /chisq;
run;
* MODEL (v);
* Ri = diagonal with constant variance sigma^2 same in both genders;
* Specified in the REPEATED statement;
* G still = (2x2) unstructured matrix same for both genders;
* Specified in the RANDOM statement;
title 'RANDOM COEFFICIENT MODEL WITH AR(1) WITHIN-CHILD';
title2 'CORRELATION MATRIX WITH CONSTANT VARIANCE SAME FOR EACH GENDER';
title3 'SAME G MATRIX FOR BOTH GENDERS';
proc mixed method=ml data=dent1;
class gender child ;
model distance = age gender gender*age / solution ;
random intercept age / type=un subject=child g gcorr v vcorr;
repeated /  subject=child rcorr; 
estimate 'diff in mean slope' gender 0 0 gender*age 1 -1;
contrast 'overall gender diff' gender 1 -1, gender*age 1 -1 /chisq;
run;

* MODEL (vi)
* Ri is the sum of two components, an AR(1) component for fluctuations;
* and a diagonal component with variance sigma^2 common to both genders;
* The LOCAL option adds the diagonal component to the AR(1) structure;
* specified in the REPEATED statement;
* G still = (2x2) unstructured matrix same for both genders;
* Specified in the RANDOM statement;
title 'RANDOM COEFFICIENT MODEL WITH AR(1) + COMMON MEAS ERROR WITHIN-CHILD';
title2 'CORRELATION MATRIX WITH CONSTANT VARIANCE SAME FOR EACH GENDER';
title3 'SAME G MATRIX FOR BOTH GENDERS';
proc mixed method=ml data=dent1;
class gender child ;
model distance = age gender gender*age / solution ;
random intercept age / type=un subject=child g gcorr v vcorr;
repeated / type=ar(1) local subject=child rcorr; *The LOCAL option adds the diagonal component to the AR(1) structure;
estimate 'diff in mean slope' gender 0 0 gender*age 1 -1;
contrast 'overall gender diff' gender 1 -1, gender*age 1 -1 /chisq;
run;

* MODEL (vii): model (v) USING PROC GLIMMIX;
title 'RANDOM COEFFICIENT MODEL WITH AR(1) R-side matrix';
title2 'CORRELATION MATRIX WITH CONSTANT VARIANCE SAME FOR EACH GENDER';
title3 'SAME G MATRIX FOR BOTH GENDERS';
proc glimmix method=quad data=dent1;
class gender child ;
model distance = age gender gender*age / solution ;
random intercept age / type=un subject=child g gcorr v vcorr;
random _residual_ / type=ar(1) subject=child ; *The LOCAL option adds the diagonal component to the AR(1) structure;
estimate 'diff in mean slope' gender 0 0 gender*age 1 -1;
contrast 'overall gender diff' gender 1 -1, gender*age 1 -1 /chisq;
run;

* MODEL (viii): model (iv) USING GLIMMIX;
* Fit the same model but with a separate diagonal Ri matrix for;
* each gender. Thus, there are 2 separate variances sigma^2_(G and B);
* G still = (2x2) unstructured matrix differs across genders;
* Specified in the RANDOM statement by the GROUP=GENDER option;
title 'RANDOM COEFFICIENT MODEL WITH DIAGONAL WITHIN-CHILD';
title2 'COVARIANCE MATRIX WITH SEPARATE CONSTANT VARIANCE FOR EACH GENDER';
title3 'DIFFERENT G MATRIX FOR BOTH GENDERS';
proc GLIMMIX method=quad data=dent1;
class child gender;
model distance = age gender gender*age / solution;
random _residual_ / group=gender subject=child;
random intercept age / type=un group=gender subject=child g gcorr v vcorr;
estimate 'diff in mean slope' gender 0 0 gender*age 1 -1;
contrast 'overall gender diff' gender 1 -1, gender*age 1 -1 /chisq;
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
