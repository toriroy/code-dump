** Example: with interaction ***;
* A grape grower is interested in maximizing the number of bushels/acre on her winery. She
limits her study to the combinations of 3 varieties and 4 pesticides (12 combinations). For
each combination, two replicates will be obtained. If there is an interaction, the grower wants 
to compare the pesticides for each fixed variety of grape.;

options nocenter ls=78;
goptions colors=(none);
data grape;
input varty pest resp @@;
cards;
1 1 49 1 1 39 1 2 50 1 2 55 1 3 43 1 3 38 1 4 85 1 4 73
2 1 55 2 1 41 2 2 67 2 2 58 2 3 53 2 3 42 2 4 53 2 4 48
3 1 66 3 1 68 3 2 85 3 2 92 3 3 69 3 3 62 3 4 85 3 4 99
;

ods rtf file="I:\bmtry702\BMTRY702\Fall 2010\data and sas code\Factorial with interaction examples.rtf";
proc sort data=grape; 
by pest varty;
proc means data=grape noprint;
var resp; by pest varty;
output out=grape1 mean=mn;
run;
symbol1 v=circle i=join; symbol2 v=square i=join; symbol3 v=triangle i=join;
proc gplot data=grape1;
plot mn*pest=varty;
run;

ods graphics on;
proc glm data=grape plots=diagnostics;
class varty pest;
model resp = varty|pest/clparm;
lsmeans varty*pest / slice=varty adjust=tukey stderr tdiff;	*to compare the pesticides for each fixed variety;
estimate 'Variety effect 1 vs 2' varty 1 -1 0/e;
estimate 'Variety effect 1 vs 3' varty 1 0 -1/e;

estimate 'Pest effect 1 vs 2' pest 1 -1 0 0/e;
estimate 'Pest effect 1 vs 4' pest 1 0 0 -1/e;

estimate 'varty effect 1 vs 2 at pest1' varty 1 -1 0 varty*pest 1 0 0 0 -1 0 0 0/e;
estimate 'varty effect 1 vs 3 at pest1' varty 1 0 -1 varty*pest 1 0 0 0 0 0 0 0 -1 0 0 0/e;

output out=grape2 r=res p=pred;
run;
ods graphics off;
ods rtf close;

symbol1 v=circle i=none;
proc gplot data=grape2;
plot res*pred;
run;

* pooled analysis: Do not pool as below if interaction is suignificant  **;
ods graphics on;
proc glm data=grape plots=diagnostics;
class pest varty ;
model resp = pest varty varty*pest/clparm;
run;
ods graphics off;
