proc import datafile = 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\hw2_q2.csv'
out=ques3
dbms=csv;
run;
proc print data=ques3;
run;
proc glm data=ques3;
    class Diet;
    model cal = Weight Diet / solution;
	run;
proc glm data=ques3;
    class diet;
    model weight = cal diet cal*diet / solution;
    test h=cal*diet cal*diet;
run;
/* Perform ANCOVA */
title 'three b';
PROC GLM DATA=ques3;
    CLASS Diet;
    MODEL Weight = Cal Diet / SOLUTION;
    LSMEANS Diet / ADJUST=TUKEY;
RUN;
QUIT;

/* Check the assumptions */
PROC UNIVARIATE DATA=ques3 NORMAL;
    VAR Weight;
RUN;

PROC PLOT DATA=;
    PLOT Weight*Cal;
RUN;
title '3c';
PROC MEANS DATA=ques3;
    VAR Cal;
    OUTPUT OUT=mean_calorie MEAN=mean_calorie_intake;
RUN;

PROC MEANS DATA=ques3;
    CLASS Diet;
    VAR Cal;
    OUTPUT OUT=treatment_means MEAN=mean_calorie_intake;
RUN;
/* Perform ANCOVA */
PROC GLM DATA=ques3;
    CLASS Diet;
    MODEL Weight = Cal Diet / SOLUTION;
    LSMEANS Diet / PDIF=ALL CL AT MEANS MEAN(0);
    LSMEANS Diet / PDIF=ALL CL AT (Cal=35) AT (Cal=44) AT (Cal=51) AT (Cal=48);
RUN;
QUIT;

PROC GLM DATA=ques3;
    CLASS Diet (ref='4');
    MODEL Weight = Cal Diet / SOLUTION ;
    LSMEANS Diet / PDIF=ALL CL AT MEANS MEAN(0);
    LSMEANS Diet / PDIF=ALL CL AT (Cal=35) AT (Cal=44) AT (Cal=51) AT (Cal=48);
RUN;
QUIT;

PROC GLM DATA=ques3;
    CLASS Diet;
    MODEL Weight = Cal Diet/ SOLUTION;
    LSMEANS Diet/ PDIFF=CONTROL('4') ADJUST=DUNNETT CL;
RUN;
QUIT;
PROC GLM DATA=ques3;
    CLASS Diet;
    MODEL Weight = Cal Diet/ SOLUTION;
    LSMEANS Diet/ PDIFF=CONTROL('4') ADJUST=DUNNETT CL;
RUN;
QUIT;
