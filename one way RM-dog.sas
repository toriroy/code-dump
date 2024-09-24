* Dog heart rate example;
OPTIONS LS=80 PS=66 NODATE;
DATA RM1;
INPUT DOG DRUG Y @@;
CARDS;
1 1 2.6 1 2 4.6 1 3 5.2 1 4 4.2
2 1 3.9 2 2 5.1 2 3 6.3 2 4 5.0
3 1 4.2 3 2 5.8 3 3 7.1 3 4 5.8
4 1 2.4 4 2 3.9 4 3 5.1 4 4 4.0
5 1 3.3 5 2 5.2 5 3 6.3 5 4 3.8
6 1 3.9 6 2 5.5 6 3 5.2 6 4 4.5
;
PROC GLM DATA=RM1;
CLASS DRUG DOG;
MODEL Y=DRUG DOG;
LSMEANS DRUG/PDIFF ADJUST=TUKEY;
RUN;
QUIT;
* Equivalent analysis with random statment;
PROC GLM DATA=RM1;
CLASS DRUG DOG;
MODEL Y=DRUG DOG;
RANDOM DOG/TEST;
LSMEANS DRUG/PDIFF ADJUST=TUKEY;
RUN;
QUIT;
* We will reconsider the dogs’ heart-rate example once more. The following SAS code produces Mauchly’s
test as well as the G-G e-adjusted F-test.
* arrange data as multivariate;
OPTIONS LS=80 PS=66 NODATE;
DATA RM2;
INPUT D1 D2 D3 D4;
CARDS;
2.6 4.6 5.2 4.2
3.9 5.1 6.3 5.0
4.2 5.8 7.1 5.8
2.4 3.9 5.1 4.0
3.3 5.2 6.3 3.8
3.9 5.5 5.2 4.5
;
PROC GLM DATA=RM2;
MODEL D1-D4 = /NOUNI;
REPEATED DRUG/PRINTE NOM;
RUN;
QUIT;
* Follow-up t-tests may be performed without assuming equality of variances. This is done using PROC
MEANS in SAS to get pairwise t-test statistics.;
OPTIONS LS=80 PS=66 NODATE;
DATA RM2;
INPUT D1 D2 D3 D4;
D12 = D2-D1;
D13 = D3-D1;
D14 = D4-D1;
D23 = D3-D2;
D24 = D4-D2;
D34 = D4-D3;
CARDS;
2.6 4.6 5.2 4.2
3.9 5.1 6.3 5.0
4.2 5.8 7.1 5.8
2.4 3.9 5.1 4.0
3.3 5.2 6.3 3.8
3.9 5.5 5.2 4.5
;
PROC MEANS DATA=RM2 N MEAN STDERR T PRT;
VAR D12 D13 D14 D23 D24 D34;
RUN;
QUIT;

*polynomial trend;
TITLE 'ONE-WAY RM TREND'; 
PROC GLM DATA=RM1;
MODEL D1-D4 = / NOUNI;
REPEATED TIME 4 (1 2 4 8) POLYNOMIAL / PRINTM SUMMARY;
RUN; QUIT;
