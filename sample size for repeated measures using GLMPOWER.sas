data WellnessMult;
input Treatment $1-7 WellScore1 WellScore3 WellScore6 Alloc;
datalines;
Placebo 32 36 39 2
SGF     35 40 48 1
;
run;
%let nRep=10;
data WellnessUni;
set WellnessMult;
retain Subject 1;
do iRep = 1 to &nRep;
do iSubj = 1 to Alloc;
Time = 1; WellScore = WellScore1; output;
Time = 3; WellScore = WellScore3; output;
Time = 6; WellScore = WellScore6; output;
Subject = Subject + 1;
end;
end;
keep Treatment Time Subject WellScore;
run;
*ignoring correlation;
*You based your first power analysis, however, on the standard F test in a univariate model without any
within-subject correlation, as represented by the following statements:;
proc mixed;
class Treatment Time Subject;
model WellScore = Treatment|Time Subject / ddfm=satterthwaite;
run;
*This is equivalent to the following analysis in PROC GLM:;
proc glm;
class Treatment Time Subject;
model WellScore = Treatment|Time Subject;
run;

*nRep value times 3 (to obtain the number of subjects) times 3 (the number of time points).;
proc glmpower data=WellnessUni;
class Treatment Time Subject;
model WellScore = Treatment|Time Subject;
power
effects=(Treatment*Time)
alpha = 0.05
ntotal = %sysevalf(&nRep * 3 * 3)
power = .
stddev = 3.2;
run;
*accounting for correlation;
*Your planned PROC MIXED analysis is as follows:;
proc mixed;
class Treatment Time Subject;
model WellScore = Treatment|Time / ddfm=kr;
repeated Time / subject=Subject type=un;
run;
*This is equivalent to the following PROC GLM analysis:;
proc glm;
class Treatment;
model WellScore1 WellScore3 WellScore6 = Treatment;
repeated Time;
run;

*with AR(1) type correlation structure: 
linear exponent AR(1) or LEAR model that has a base correlation of 0.85 and a decay rate of 1 over one-month;
proc glmpower data=WellnessMult;
class Treatment;
weight Alloc;
model WellScore1 WellScore3 WellScore6 = Treatment;
repeated Time;
power
effects=(Treatment)
mtest = hlt
alpha = 0.05
power = .9
ntotal = .
stddev = 3.2
matrix ("WellCorr") = lear(0.85, 1, 3, 1 3 6)
corrmat = "WellCorr";
run;
