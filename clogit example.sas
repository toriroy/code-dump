*example1 Conditional logit;
Libname lect2 "C:\Users\gebregz\Dropbox\bmtry784\sas code\binary data";
data lowbwt11;
  set lect2.lowbwt11;
  race2 = (race=2);
  race3 = (race=3);
  lwt10 = lwt/10;
  time=2-low;
run;
ods listing close;

*fully stratified analysis;
proc logisitc data=lowbwt11 desc;
class pair;
model low=pair smoke/expb;
run;

*McNemar's test;
proc freq data=lowbwt11 ;
table low*smoke/agree cl;
run;

*conditional logistic;
proc logisitc data=lowbwt11 desc;
model low= smoke/expb;
strata pair;
run;

*conditional logistic - adjsuted for ptd and ui;
proc logisitc data=lowbwt11 desc;
model low= smoke ptd ui/expb;
strata pair;
run;
*conditional logistic - stepwise regression on age lwt smoke ptd ht and ui;
*lackfit doesn't work with strata statement;
proc logistic data=lowbwt11 desc;
model low= smoke age lwt  ptd ht ui/selection=stepwise slentry=0.3 slstay=0.35 details expb ;
strata pair;
output out=pred p=phat lower=lcl upper=ucl h=hat dfbetas=_all_;
run;
* using PHREG;
proc phreg data=lowbwt11; 
model Time*low(0)= smoke/ ties=discrete; 
strata pair; 
run; 

*example 2- esophageal cancer
The dataset contains 119 observations with 3 covariates.
smoking: whether the participant smoks
rubber: whether the participant exposed to rubber industry
alcohol: whether the participant drinks alcohol ;
Data esoph;
Input Id pair case smoking rubber alcohol;
Datalines;
1 1 1 1 0 0
2 1 0 1 0 0
3 2 1 1 0 1
4 2 0 1 1 0
5 3 1 1 1 0
6 3 0 1 1 0
7 4 1 1 0 0
8 4 0 1 1 1
9 4 0 0 1 1
10 5 1 0 0
;
*conditional logit;
proc logistic data = esop;
model case (event = 1) = rubber smoking alcohol;
strata Pair;
run; 
Data esop;
Set esop;
Time=2-case;
Run;

proc phreg data=esop; 
model Time*case(0)= rubber smoking alcohol/ ties=discrete; 
strata pair; 
run; 
