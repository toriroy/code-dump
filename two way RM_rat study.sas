*  This experiment involved studying the effect of a dose of a drug on the growth of rats. The data set consists
of the growth of 15 rats, where 5 rats were randomly assigned to each of the 3 doses of the drug. The weights
were obtained each week for 4 weeks.;

OPTIONS LS=80 PS=66 NODATE;
DATA RM1;
DO A=1,2,3;
DO S=1,2,3,4,5;
DO B = 1,2,3,4;
INPUT Y @@;
OUTPUT;
END;
END;
END;
CARDS;
54 60 63 74
69 75 81 90
77 81 87 94
64 69 77 83
51 58 62 71
62 71 75 81
68 73 81 91
94 102 109 112
81 90 95 104
64 69 72 78
59 63 66 75
56 66 70 81
71 77 84 80
59 64 69 76
65 70 73 77
;
PROC SORT DATA=RM1;
BY A B S;
RUN;
QUIT;
PROC MEANS MEAN NOPRINT;
VAR Y;
BY A B;
OUTPUT OUT=OUTMEAN MEAN=YM;
RUN;
QUIT;
*MEAN PLOTS;
GOPTIONS DISPLAY;
PROC GPLOT DATA=OUTMEAN;
PLOT YM*B=A;
SYMBOL1 V=DIAMOND L=1 I=JOIN CV=BLUE;
SYMBOL2 V=TRIANGLE L=1 I=JOIN CV=BLACK;
SYMBOL3 V=CIRCLE L=1 I=JOIN CV=ORANGE;
TITLE3 'DOSE BY TIME';
RUN;
QUIT;
* MEAN PLOTS;
PROC GLIMMIX DATA=RM1;
CLASS A B S;
MODEL Y= A B A*B S(A);
RANDOM S(A);
LSMEANS A*B/PLOT=MEANPLOT(SLICEBY=A JOIN);
RUN;
* PROFILE PLOTS;
PROC SORT DATA=RM1;
BY A;
RUN;
QUIT;
Symbol1 I = join v = none r = 5;
Proc gplot data = RM1;
Plot y*B = S/ nolegend;
By A;
Run;

TITLE1 'RAT BODY WEIGHT DATA';
PROC GLM DATA=RM1;
CLASS A B S;
MODEL Y = A S(A) B A*B B*S(A);
TEST H=A E=S(A);
TEST H=B A*B E=B*S(A);
LSMEANS A/PDIFF E=S(A);
LSMEANS B/PDIFF E=B*S(A);
RUN;
QUIT;

* when S condition does not hold;
* We will revisit the body weight of rats data considered above. The following SAS code is used to get the
tests for B and AB effects.;
OPTIONS LS=80 PS=66 NODATE;
DATA RM3;
INPUT A Y1 Y2 Y3 Y4;
CARDS;
1 54 60 63 74
1 69 75 81 90
1 77 81 87 94
1 64 69 77 83
1 51 58 62 71
2 62 71 75 81
2 68 73 81 91
2 94 102 109 112
2 81 90 95 104
2 64 69 72 78
3 59 63 66 75
3 56 66 70 81
3 71 77 84 80
3 59 64 69 76
3 65 70 73 77
;
TITLE1 'RAT BODY WEIGHT DATA : 2';
PROC GLM DATA=RM3;
CLASS A;
MODEL Y1-Y4 = A;
REPEATED B 4/ PRINTE;
RUN;
QUIT;
* Mauchly’s test for the (S) condition is significant indicating that the analyses run earlier may not be the appropriate ones.
* We now run one-way RM analyses of B within each level of A.;
PROC SORT DATA=RM3;
BY A;
RUN;
QUIT;
PROC GLM DATA=RM3;
MODEL Y1-Y4=/NOUNI;
REPEATED B 4/PRINTE;
BY A;
RUN;
QUIT;
* trend;
TITLE 'ONE-WAY RM TREND'; 
PROC GLM DATA=RM3;
MODEL Y1-Y4 = / NOUNI;
REPEATED TIME 4 (1 2 4 8) POLYNOMIAL / PRINTM SUMMARY;
RUN; QUIT;
