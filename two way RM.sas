* two way RM;
* An experiment involving a=3 drugs was conducted to study each drug effect on the heart rate of humans. After
the drug was administered, the heart rate was measured every five minutes for a total of b=4 times. At the start
of the study, n=8 female human subjects were randomly assigned to each drug. The following table contains
results from one such study.;
OPTIONS LS=80 PS=66 NODATE;
DATA RM;
INPUT S @;
DO A=1,2,3;
DO B = 1,2,3,4;
INPUT Y @@;
OUTPUT;
END;
END;
CARDS;
1 72 86 81 77 85 86 83 80 69 73 72 74
2 78 83 88 81 82 86 80 84 66 62 67 73
3 71 82 81 75 71 78 70 75 84 90 88 87
4 72 83 83 69 83 88 79 81 80 81 77 72
5 66 79 77 66 86 85 76 76 72 72 69 70
6 74 83 84 77 85 82 83 80 65 62 65 61
7 62 73 78 70 79 83 80 81 75 69 69 68
8 69 75 76 70 83 84 78 81 71 70 65 65
;
PROC SORT DATA=RM;
BY A B S;
RUN;
QUIT;
PROC MEANS MEAN NOPRINT;
VAR Y;
BY A B;
OUTPUT OUT=OUTMEAN MEAN=YM;
RUN;
QUIT;
*profile plots;
Symbol1 I = join v = none r = 8;
Proc gplot data = RM;
Plot y*B = S/ nolegend;
By A;
Run;
* you can do PLOTS using proc GLIMMIX LSMEANS ;
ods graphics on;
proc glimmix data=RM;
CLASS A B S;
MODEL Y = A B A*B ;
random S(A);
lsmeans A*B/plot=meanplot(sliceby=A join);
run;
ods graphics off;
GOPTIONS DISPLAY;
PROC GPLOT DATA=OUTMEAN;
PLOT YM*B=A;
SYMBOL1 V=DIAMOND L=1 I=JOIN CV=BLUE;
SYMBOL2 V=TRIANGLE L=1 I=JOIN CV=BLACK;
SYMBOL3 V=CIRCLE L=1 I=JOIN CV=ORANGE;
TITLE3 'DRUG BY TIME';
RUN;
QUIT;
TITLE1 'HEART RATE DATA';
PROC GLM DATA=RM;
CLASS A B S;
MODEL Y = A S(A) B A*B B*S(A); * once you include B*S(A) then the error dfs and SS are zero;
TEST H=A E=S(A);
TEST H=B A*B E=B*S(A);* assumes CS stucture;
LSMEANS A*B;
RUN;
QUIT;
* using MSE as denominator for B and A*B;
TITLE1 'HEART RATE DATA';
PROC GLM DATA=RM;
CLASS A B S;
MODEL Y = A S(A) B A*B ; 
RANDOM S(A)/TEST;* assumes CS stucture;
*TEST H=A E=S(A);
LSMEANS A*B;
RUN;
QUIT;

* creating short data;
data RM1 (keep=A S Y1-Y4);
array xx[4] Y1-Y4;
do i= 1 to 4;
 set RM;
xx[i]=Y;
 end;
 run;
*rANOVA with test of sphericity (the unadjsuted test results are rANOVA under the S or HF condition;
PROC GLM DATA=RM1; * RM1 is horizontal or short data;
CLASS A;
MODEL Y1-Y4 = A/NOUNI;
REPEATED B 4 / NOM PRINTE;
RUN;
QUIT;
* trend test;
TITLE1 'HEART RATE DATA : TREND over time in each group';
PROC SORT DATA=RM1;
BY A;
RUN;
QUIT;
PROC GLM DATA=RM1;
CLASS A;
MODEL Y1-Y4 = /NOUNI; * note that there is no A here since we are computing trend for each group;
REPEATED B 4 POLYNOMIAL/ NOM PRINTM SUMMARY;
BY A;
RUN;
QUIT;
* MANOVA: Multivariate test for within subject effects*;
PROC GLM DATA=RM1;
CLASS A;
MODEL Y1-Y4 = A/NOUNI;
REPEATED B 4 POLYNOMIAL/ NOU PRINTM SUMMARY;
RUN;
QUIT;

************************************************************************;
** ALTERNATIVE AND MORE MODERN ANALYSIS: using random statement***;
***********************************************************************;
PROC SORT DATA=RM;
BY A;
RUN;
QUIT;
*profile plots;
Symbol1 I = join v = none r = 8;
Proc gplot data = RM;
Plot y*B = S/ nolegend;
By A;
Run;
* you can do PLOTS using proc GLIMMIX LSMEANS ;
proc glimmix data=RM;
CLASS A B S;
MODEL Y = A B A*B ;
random S(A);
lsmeans A*B/plot=meanplot(sliceby=A join);
run;
/*******************************************************************
Note that the F ratio that PROC GLM prints out automatically for the dose effect (averaged across time) will use the
MSE in the denominator. This is not the correct F ratio for testing this effect.
The RANDOM statement asks SAS to compute the expected mean squares for each source of variation. 
The TEST option asks SAS to compute the test for the A effect (averaged across
B), treating the S(A) effect as random, giving the correct F ratio. Other F-ratios are correct.
*******************************************************************/
TITLE1 'HEART RATE DATA';
PROC GLM DATA=RM;
CLASS A B S;
MODEL Y = A S(A) B A*B ;
RANDOM S(A)/test; * assumes CS stucture;
LSMEANS A*B;
RUN;
QUIT;

/*******************************************************************
Now carry out the same analysis using the REPEATED statement in
PROC GLM. This requires that the data be represented in the form of data set RM1.
The option NOUNI suppresses individual analyses of variance at each week value from being printed.
The PRINTE option asks for the test of sphericity to be performed.
The NOM option means "no multivariate," which means univariate tests under the assumption that the compound symmetry model
is correct.
*******************************************************************/
PROC GLM DATA=RM1;
CLASS A;
MODEL Y1-Y4 = A/NOUNI;
REPEATED B 4 POLYNOMIAL/ PRINTE NOM SUMMARY;*generates orthogonal polynomial contrasts. 
 if you Level values B 4 (1 3 7 9), they are used as spacings in the construction of the polynomials, otherwise, equal spacing is assumed;
RUN;
/*******************************************************************
In the REPEATED statement, The SUMMARY option asks that PROC GLM to print tests corresponding to the contrasts.
The NOU option asks that printing of the univariate analysis of variance be suppressed
THE PRINTM option prints out the matrix corresponding to the contrasts being used . 
PRINTE TESTS SPHERICITY
*******************************************************************/
PROC GLM DATA=RM1;
CLASS A;
MODEL Y1-Y4 = A/NOUNI;
REPEATED B 4 PROFILE/ PRINTE PRINTM NOM SUMMARY;*generates contrasts between adjacent levels of the factor;
RUN;

PROC GLM DATA=RM1;
CLASS A;
MODEL Y1-Y4 = A/NOUNI;
REPEATED B 4 HELMERT/ PRINTE PRINTM NOM SUMMARY;*HELMERT-generates contrasts between each level of the factor and 
the mean of subsequent levels. ;
RUN;

* type3 analysis using proc Mixed;
PROC MIXED DATA=RM method=type3 covtest;
CLASS A B S;
MODEL Y = A B A*B ;
RANDOM S(A);
LSMEANS A A*B/adjust=tukey; * correct standard error estimates;
RUN;


*** LINEAR MIXED MODELS CHAPTER ******;
* we can also use the /subject=option but we can only use REML or ML methods;
PROC MIXED DATA=RM method=REML covtest;
CLASS A B S;
MODEL Y = A B A*B ;
RANDOM S(A)/SUBJECT=S(A) TYPE=VC;* we can specify different types of covariance structures SUCH AS: HF, UN,CS and compare models via AIC;
LSMEANS A A*B/adjust=tukey; * correct standard error estimates;
RUN;

