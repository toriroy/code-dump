/*******************************************************************
CHAPTER 5, EXAMPLE 1
Analysis of the dental study data by repeated
measures analysis of variance using PROC GLM
- the repeated measurement factor is age (time)
- there is one "treatment" factor, gender
*******************************************************************/
options ls=80 ps=59 nodate; run;
/******************************************************************
The data set looks like
1 1 8 21 0
2 1 10 20 0
3 1 12 21.5 0
4 1 14 23 0
5 2 8 21 0
...
column 1 observation number
column 2 child id number
column 3 age
column 4 response (distance)
column 5 gender indicator (0=girl, 1=boy)
The second data step changes the ages from 8, 10, 12, 14
to 1, 2, 3, 4 so that SAS can count them when it creates a
different data set later
*******************************************************************/
data dent1; infile 'dental.dat';
input obsno child age distance gender;
run;
data dent1; set dent1;
if age=8 then age=1;
if age=10 then age=2;
if age=12 then age=3;
if age=14 then age=4;
drop obsno;
run;
/*******************************************************************
Create an alternative data set with the data record for each child
on a single line.
*******************************************************************/
proc sort data=dent1;
by gender child;
data dent2(keep=age1-age4 gender);
array aa{4} age1-age4;
do age=1 to 4;
set dent1;
by gender child;
aa{age}=distance;
if last.child then return;
end;
run;
proc print;
/*******************************************************************
Find the means of each gender-age combination and plot mean
vs. age for each gender
*******************************************************************/
proc sort data=dent1; by gender age; run;
proc means data=dent1; by gender age;
var distance;
output out=mdent mean=mdist; run;
proc plot data=mdent; plot mdist*age=gender; run;
/*******************************************************************
Construct the analysis of variance using PROC GLM
via a "split plot" specification. This requires that the
data be represented in the form they are given in data set dent1.
Note that the F ratio that PROC GLM prints out automatically
for the gender effect (averaged across age) will use the
MSE in the denominator. This is not the correct F ratio for
testing this effect.
The RANDOM statement asks SAS to compute the expected mean
squares for each source of variation. The TEST option asks
SAS to compute the test for the gender effect (averaged across
age), treating the child(gender) effect as random, giving the
correct F ratio. Other F-ratios are correct.
In older versions of SAS that do not recognize this option,
this test could be obtained by removing the TEST option
from the RANDOM statement and adding the statement
test h=gender e = child(gender);
to the call to PROC GLM.
*******************************************************************/
proc glm data=dent1;
class age gender child;
model distance = gender child(gender) age age*gender;
random child(gender) / test;
run;
/*******************************************************************
Now carry out the same analysis using the REPEATED statement in
PROC GLM. This requires that the data be represented in the
form of data set dent2.
The option NOUNI suppresses individual analyses of variance
for the data at each age value from being printed.
The PRINTE option asks for the test of sphericity to be performed.
The NOM option means "no multivariate," which means just do
the univariate repeated measures analysis under the assumption
that the exchangable (compound symmetry) model is correct.
*******************************************************************/
proc glm data=dent2;
class gender;
model age1 age2 age3 age4 = gender / nouni;
repeated age / printe nom;
/*******************************************************************
This call to PROC GLM redoes the basic analysis of the last.
However, in the REPEATED statement, a different contrast of
the parameters is specified, the POLYNOMIAL transformation.
The levels of "age" are equally spaced, and the values are
specified. The transformation produced is orthogonal polynomials
for polynomial trends (linear, quadratic, cubic).
The SUMMARY option asks that PROC GLM print out the results of
tests corresponding to the contrasts in each column of the U
matrix.
The NOU option asks that printing of the univariate analysis
of variance be suppressed (we already did it in the previous
PROC GLM call).
THE PRINTM option prints out the U matrix corresponding to the
orthogonal polynomial contrasts. SAS calls this matrix M, and
actuallly prints out its transponse (our U').
For the orthogonal polynomial transformation, SAS uses the
normalized version of the U matrix. Thus, the SSs from the
individual ANOVAs for each column will add up to the Gender by
Age interaction SS (and similarly for the within-unit error SS).
*******************************************************************/
proc glm data=dent2;
class gender;
model age1 age2 age3 age4 = gender / nouni;
repeated age 4 (8 10 12 14) polynomial /summary nou nom printm;
run;
/*******************************************************************
For comparison, we do the same analysis as above, but use the
Helmert matrix instead.
SAS does NOT use the normalized version of the Helmert
transformation matrix. Thus, the SSs from the individual ANOVAs
for each column will NOT add up to the Gender by Age interaction
SS (similarly for within-unit error). However, the F ratios
are correct.
********************************************************************/
proc glm data=dent2;
class gender;
model age1 age2 age3 age4 = gender / nouni;
repeated age 4 (8 10 12 14) helmert /summary nou nom printm;
run;
/*******************************************************************
Here, we manually perform the same analysis, but using the
NORMALIZED version of the Helmert transformation matrix.
We get each individual test separately using the PROC GLM
MANOVA statement.
********************************************************************/
proc glm data=dent2;
model age1 age2 age3 age4 = gender /nouni;
manova h=gender
m=0.866025404*age1 - 0.288675135*age2- 0.288675135*age3 - 0.288675135*age4;
manova h=gender m= 0.816496581*age2-0.40824829*age3-0.40824829*age4;
manova h=gender m= 0.707106781*age3- 0.707106781*age4;
run;
/*******************************************************************
To compare, we apply the contrasts (normalized version) to each
child's data. We thus get a single value for each child corresponding
to each contrast. These are in the variables AGE1P -- AGE3P.
We then use PROC GLM to perform each separate ANOVA. It may be
verified that the separate gender sums of squares add up to
the interaction SS in the analysis above.
********************************************************************/
data dent3; set dent2;
age1p = sqrt(0.75)*(age1-age2/3-age3/3-age4/3);
age2p = sqrt(2/3)*(age2-age3/2-age4/2);
age3p = sqrt(1/2)*(age3-age4);
run;
proc glm; class gender; model age1p age2p age3p = gender;
run;
