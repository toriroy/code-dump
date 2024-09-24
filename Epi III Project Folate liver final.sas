PROC IMPORT OUT= WORK.comb 
            DATAFILE= "C:\Users\royv\OneDrive - Medical University of So
uth Carolina\Desktop\combdata.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*//Categories//*;
data folate;
set work.comb;
if 0 <= LBDRFO <=414 then fo=1;
if 415 <= LBDRFO <= 2500 then fo=2;
run;
data folatefinal;
set folate;
if 0 <= LBDRFO <=314 then fo4=1;
if 314 < LBDRFO <= 414 then fo4=2;
if 414 < LBDRFO <=514 then fo4=3;
if 514 < LBDRFO <=2500 then fo4=4;
run;
**//Possible clinical significant cuttoffs for liver stiffness//**;
data folateout;
set folatefinal;
if 0 <= LUXSMED <= 6 then ls=1;
if 6 < LUXSMED <=8 then ls=2;
if 8< LUXSMED <=12.4 then ls=3;
if 12.5 <= LUXSMED <= 75 then ls=4;
run;
*//End Category Creation//*;

ods graphics on;
proc univariate data =folatefinal;
var LUXSMED;
histogram LUXSMED;
qqplot LUXSMED /Normal(mu=est sigma=est color=red l=1);
run;
**//LUXSMED (Liver Stiffness) is not normally distributed, but has a bellshaped curve skewed right with the majority of the observations between 2.5 and 7.5//**;
ods graphics on;
proc univariate data =folatefinal;
var LBDRFO;
histogram LBDRFO;
qqplot LBDRFO /Normal(mu=est sigma=est color=red l=1);
run;

/*perform nonparametic test: Mann Whitney U test*/
proc npar1way data=folatefinal wilcoxon;
    class fo4;
    var LUXSMED;
run;
proc npar1way data=folatefinal wilcoxon;
    class fo;
    var LUXSMED;
run;

PROC GLM data = folatefinal;
class fo (ref='2');
Model LUXSMED=fo /solution;
run;
PROC GLM data = folatefinal;
class fo4 (ref='4');
Model LUXSMED=fo4 /solution;
run;
**//Check both cont//**;
PROC GLM data = folatefinal;
Model LUXSMED=LBDRFO /solution;
run;

**///SGPLOT///**;
PROC SGPLOT DATA = folatefinal;
title 'Folate Status Dichotomous';
VBAR fo;
RUN;
PROC SGPLOT DATA = folatefinal;
title 'Folate Status Quartile';
VBAR fo4;
RUN;
proc sgplot data = folatefinal;
title 'Scatter Plot for All Folate and Stiffness Data';
scatter x=LBDRFO y=LUXSMED;
run;
PROC SGPLOT DATA = folatefinal;
title 'Liver Stiffness';
VBAR LUXSMED;
RUN;
PROC SGPLOT DATA = folatefinal;
title 'Folate Status';
VBAR LBDRFO;
RUN;



*//---Remove---//*;
proc freq data = folateandout;
title 'Categorical CHISQ';
table ls*fo /CHISQ OR CMH;
run;
proc logistic data = folateandout;
title 'Logistic Regression with Categorical';
class fo (ref='1') ls (ref='1');
model ls = fo;
run;
 proc ANOVA data=folateandout;
	title One-way ANOVA;
	class fo;
	model  LUXSMED=fo;
	means fo /hovtest welch;
	run;
*proc print data= ;
*run;

