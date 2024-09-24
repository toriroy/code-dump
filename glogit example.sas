*multinomial logit;
data mi;
input x mi count;
datalines;
1 1 18
1 2 171
1 3 10845
0 1 5
0 2 99
0 3 10933
;
run;
ods graphics on;
proc logistic data=mi;
class mi;
model mi=x/link=glogit;
freq count;
run;
ods graphics off;

*Example2-The dataset, mlogit, was collected on 200 high school students and are scores on various tests, 
including a video game and a puzzle. The outcome measure in this analysis is the preferred flavor of 
ice cream – vanilla, chocolate or strawberry- from which we are going to see what relationships exists 
with video game scores (video), puzzle scores (puzzle) and gender (female). Our response variable, ice_cream, 
is going to be treated as categorical under the assumption that the levels of ice_cream have no natural ordering, 
and we are going to allow SAS to choose the referent group. In our example, this will be strawberry. 
By default, SAS sorts the outcome variable alphabetically or numerically and selects the last group 
to be the referent group. The variable ice_cream is a numeric variable in SAS, so we will add value labels 
using proc format below.; 

options nofmterr;
libname lect3 "C:\Users\gebregz\Dropbox\bmtry784\sas code";

data mlogit;
set lect3.mlogit;
run;

proc format;
value ice_cream_l 
  1="chocolate"
  2="vanilla" 
  3="strawberry";
run;

proc freq data = mlogit;
  format ice_cream ice_cream_l.;
  table ice_cream;
run;

ods graphics on;
proc logistic data = mlogit;
  model ice_cream = video puzzle female / link = glogit;
run;

proc logistic data = mlogit;
  model ice_cream = video  female video*female/ link = glogit;
  oddsratio video;
run;
ods graphics off;


proc logistic data=mlogit;
   model ice_cream = video  female  / link=glogit;
   effectplot interaction(plotby=female) / clm noobs;
run;
