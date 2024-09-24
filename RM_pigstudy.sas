/*******************************************************************
Analysis of the vitamin E data by univariate repeated
measures analysis of variance using PROC GLM
- the repeated measurement factor is week (time)
- there is one "treatment" factor, dose
*******************************************************************/
*column 1 pig number
*columns 2-7 body weights at weeks 1, 3, 4, 5, 6, 7
*column 8 dose group (1=zero, 2 = low, 3 = high dose
/******************************************************************/;
options ls=80 ps=59 nodate; run;
data pigs1;
input pig week1 week3 week4 week5 week6 week7 dose;
datalines;
1 455 460 510 504 436 466 1
2 467 565 610 596 542 587 1
3 445 530 580 597 582 619 1
4 485 542 594 583 611 612 1
5 480 500 550 528 562 576 1
6 514 560 565 524 552 597 2
7 440 480 536 484 567 569 2
8 495 570 569 585 576 677 2
9 520 590 610 637 671 702 2
10 503 555 591 605 649 675 2
11 496 560 622 622 632 670 3
12 498 540 589 557 568 609 3
13 478 510 568 555 576 605 3
14 545 565 580 601 633 649 3
15 472 498 540 524 532 583 3
;

/*******************************************************************
Create a data set with one data record per pig/week -- this
repeated measures data are often recorded in this form.
Create a new variable "weight" containing the body weight
at time "week."
The second data step fixes up the "week" values, as the weeks
of observations were not equally spaced but rather have the
values 1, 3, 4, 5, 6, 7.
*******************************************************************/
data pigs2; 
set pigs1;
array wt(6) week1 week3 week4 week5 week6 week7;
do week = 1 to 6;
weight = wt(week);
output;
end;
drop week1 week3-week7;
run;
data pigs2; 
set pigs2;
if week>1 then week=week+1; * to make week 3 4 5 6 7;
run;
proc print; run;
/*******************************************************************
Find the means of each dose-week combination and plot mean
vs. week for each dose;
*******************************************************************/
proc sort data=pigs2; by dose week; run;
proc means data=pigs2; by dose week;
var weight;
output out=mpigs mean=mweight; run;
proc plot data=mpigs; 
plot mweight*week=dose; run;

* you can also do PLOTS using proc GLIMMIX LSMEANS ;
proc glimmix data=pigs2;
class week dose pig;
model weight = dose week week*dose;
random pig(dose);
lsmeans week*dose/plot=meanplot(sliceby=dose join);
run;
/*******************************************************************
Note that the F ratio that PROC GLM prints out automatically for the dose effect (averaged across week) will use the
MSE in the denominator. This is not the correct F ratio for testing this effect.
The RANDOM statement asks SAS to compute the expected mean squares for each source of variation. 
The TEST option asks SAS to compute the test for the dose effect (averaged across
week), treating the pig(dose) effect as random, giving the correct F ratio. Other F-ratios are correct.
This can also be done using:
test h=dose e=pig(dose)
*******************************************************************/
proc glm data=pigs2;
class week dose pig;
model weight = dose pig(dose) week week*dose;
random pig(dose) / test; * assumes CS stucture;
run;
proc glm data=pigs2;
class week dose pig;
model weight = dose pig(dose) week week*dose;
test h=dose e=pig(dose); *assumes independence;
run;
/*******************************************************************
Now carry out the same analysis using the REPEATED statement in
PROC GLM. This requires that the data be represented in the form of data set pigs1.
The option NOUNI suppresses individual analyses of variance at each week value from being printed.
The PRINTE option asks for the test of sphericity to be performed.
The NOM option means "no multivariate," which means univariate tests under the assumption that the compound symmetry model
is correct.
*******************************************************************/
proc glm data=pigs1;
class dose;
model week1 week3 week4 week5 week6 week7 = dose / nouni;
repeated week / printe nom; * considers correlation via HF structure;
run;
/*******************************************************************
In the REPEATED statement, The SUMMARY option asks that PROC GLM to print tests corresponding to the contrasts.
The NOU option asks that printing of the univariate analysis of variance be suppressed
THE PRINTM option prints out the matrix corresponding to the contrasts being used . SAS calls this matrix M, and
actually prints out its transpose.
*******************************************************************/
proc glm data=pigs1;
class dose;
model week1 week3 week4 week5 week6 week7 = dose / nouni;
repeated week 6 (1 3 4 5 6 7) polynomial /summary printm nom; *generates orthogonal polynomial contrasts. 
Level values, if provided, are used as spacings in the construction of the polynomials, otherwise, equal spacing is assumed;
run;
proc glm data=pigs1;
class dose;
model week1 week3 week4 week5 week6 week7 = dose / nouni;
repeated week 6 (1 3 4 5 6 7) profile /summary printm nom ; *generates contrasts between adjacent levels of the factor;
run;
proc glm data=pigs1;
class dose;
model week1 week3 week4 week5 week6 week7 = dose / nouni;
repeated week 6 (1 3 4 5 6 7) helmert /summary printm nom ; *HELMERT-generates contrasts between each level of the factor and 
the mean of subsequent levels. ;
run;
* type3 analysis using proc Mixed;
proc mixed data=pigs2 method=type3 covtest;
class week dose pig;
model weight = dose week week*dose;
random pig(dose);
lsmeans dose week*dose/adjust=tukey; * correct standard error estimates;
run;

*** LINEAR MIXED MODELS CHAPTER ******;
* we can also use the /subject=option but we can only use REML or ML methods;
proc mixed data=pigs2 method=reml covtest;
class week dose pig;
model weight = dose week week*dose;
random pig(dose)/subject=pig(dose) type=VC; * we can specify different types of covariance structures;
*lsmeans week*dose/adjust=tukey;
run;
