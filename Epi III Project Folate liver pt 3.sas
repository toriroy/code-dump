PROC IMPORT OUT= WORK.comb 
            DATAFILE= "C:\Users\royv\OneDrive - Medical University of So
uth Carolina\Desktop\combdata.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data folate;
set work.comb;
if 30 <= LBDRFO < 140 then fo=1;
if 140 <= LBDRFO <=310 then fo=2;
if 311 <= LBDRFO <=481 then fo=3;
if 482 <= LBDRFO <=628 then fo=4;
if 629 <= LBDRFO <= 800 then fo=5;
if 801 <= LBDRFO then fo=6;
run;

proc print data=folate;
run;

data folateandout;
set folate;
if 0 <= LUXSMED <= 2 then ls=1;
if 2 < LUXSMED <= 4 then ls=2;
if 4< LUXSMED <= 6 then ls=3;
if 6 < LUXSMED <=8 then ls=4;
if 8< LUXSMED <=12.4 then ls=6;
if 12.5 <= LUXSMED <=19 then ls=6;
if 19 < LUXSMED <= 75 then ls=7;
run;

proc freq data = folateandout;
table fo*ls /OR;
run;

PROC SGPLOT DATA = folateandout;
VBAR fo;
RUN;
PROC SGPLOT DATA = folateandout;
VBAR ls;
RUN;
PROC SGPLOT DATA = folateandout;
VBAR LUXSMED;
RUN;
PROC SGPLOT DATA = folateandout;
VBAR LBDRFO;
RUN;

proc sgplot data = folateandout;
scatter x=LBDRFO y=LUXSMED;
run;

PROC GLM data = folateandout;
Model LUXSMED=LBDRFO /solution;
run;

proc freq data = folateandout;
table fo*ls /chisq OR CMH;
run;

proc logistic data = folateandout;
class fo (ref='1') ls (ref='1' param=ref);
model ls=fo;
run;
