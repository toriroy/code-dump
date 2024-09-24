LIBNAME D XPORT 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_DEMO.XPT';
LIBNAME E XPORT 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_FOLATE.XPT';
LIBNAME F XPORT 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_LUX.XPT';
LIBNAME G XPORT 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_FOLFMS.XPT';
LIBNAME H XPORT 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_MCQ.XPT';
Libname I XPORT '"C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_ALQ.XPT';
LIBNAME out 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANESII';
DATA OUT.test1;
   MERGE D.P_DEMO
         E.P_FOLATE
		 F.P_LUX
		 G.P_FOLFMS
		 H.P_MCQ
I.P_ALQ;	
   BY SEQN;
   RUN;
PROC IMPORT OUT= WORK.comb2 
            DATAFILE= 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\combdata2.csv'  
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*Data with binary folate status use 'folateandout'*;
*Quartile folate status use 'folatemulticat';
data folate;
set work.comb2;
if 0 <= LBDRFO <449 then fo=1;
if 450 <= LBDRFO <= 3000 then fo=2;
run;
data folatefinal;
set folate;
if 0 <= LBDRFO <=250 then fo4=1;
if 250 < LBDRFO <=414 then fo4=2;
if 414 < LBDRFO <=650 then fo4=3;
if 650 < LBDRFO <= 3000 then fo4=4;
run;
data folatefinal;
set folatefinal;
if RIAGENDR=1 then gender=1;
if RIAGENDR=2 then gender=2;
run;
data folatefinal;
set folatefinal;
if RIDRETH1=1 then race=1;
if RIDRETH1=2 then race=2;
if RIDRETH1=3 then race=3;
if RIDRETH1=4 then race=4;
if RIDRETH1=5 then race=5;
run;
data folatefinal;
set folatefinal;
if DMDEDUC2=1 then educ=1;
if DMDEDUC2=2 then educ=2;
if DMDEDUC2=3 then educ=3;
if DMDEDUC2=4 then educ=4;
if DMDEDUC2=5 then educ=5;
run;
data folatefinal;
set folatefinal;
if DMDMARTZ=1 then marst=1;
if DMDMARTZ=2 then marst=2;
if DMDMARTZ=3 then marst=3;
if DMDMARTZ=77 then marst=4;
if DMDMARTZ=99 then marst=4;
run;
**//Possible clinical significant cuttoffs for liver stiffness//**;
data folatefinal;
set folatefinal;
if 0 <= LUXSMED <= 6 then ls=1;
if 6 < LUXSMED <=8 then ls=2;
if 8< LUXSMED <=12.4 then ls=3;
if 12.5 <= LUXSMED <= 75 then ls=4;
run;
data folatefinal;
set folatefinal;
if ALQ111=1 then everalcoh=1;
if ALQ111=2 then everalcoh=2;
run;
data folatefinal;
set folatefinal;
if ALQ121=1 then alcohuse=1;
if ALQ121=2 then alcohuse=2;
if ALQ121=3 then alcohuse=3;
if ALQ121=4 then alcohuse=4;
if ALQ121=5 then alcohuse=5;
if ALQ121=6 then alcohuse=6;
if ALQ121=7 then alcohuse=7;
if ALQ121=8 then alcohuse=8;
if ALQ121=9 then alcohuse=9;
if ALQ121=10 then alcohuse=10;
run;
*//ALQ130 split into 1 to 13 average drinks per day
15 second category, 15 drinks or more//*;
data folatefinal;
set folatefinal;
if ALQ151=1 then fourplus=1;
if ALQ151=2 then fourplus=2;
run;
data folatefinal;
set folatefinal;
if RIDEXPRG=1 then preg=1;
if RIDEXPRG=2 then preg=2;
if RIDEXPRG=3 then preg=3;
run;
data folatefinal;
set folatefinal;
if MCQ080=1 then obese=1;
if MCQ080=2 then obese=2;
run;
*//End Category Creation//*;


proc tabulate data =folatefinal;
class RIDRETH1 ;
table RIDRETH1;
run;
proc tabulate data =folatefinal;
class RIDRETH3 ;
table RIDRETH3;
run;
proc tabulate data =folatefinal;
class RIAGENDR;
table RIAGENDR;
run;
proc tabulate data =folatefinal;
class LBDRFO;
table LBDRFO;
run;
*//SG PLOT//*;
PROC SGPLOT DATA = folatefinal;
title 'Liver Stiffness';
VBAR LUXSMED;
RUN;
PROC SGPLOT DATA = folatefinal;
VBAR RIDAGEYR;
RUN;
PROC SGPLOT DATA = folatefinal;
title 'Folate Status';
VBAR LBDRFO;
RUN;
PROC SGPLOT DATA = folatefinal;
VBAR fo4;
RUN;
PROC SGPLOT DATA = folatefinal;
VBAR RIAGENDR;
RUN;
PROC SGPLOT DATA = folatefinal;
vbar gender;
run;


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
*/Start/*;
PROC GLM data = folatefinal;
class fo (ref='1');
Model LUXSMED=fo/solution;
run;
PROC GLM data = folatefinal;
class fo4 (ref='1');
Model LUXSMED=fo4/solution;
run;
*/  /*;
*/Full Model: Gender Age RaceEthnicity RaceEthnicity EducationLevel Marital status PregnancyStatusAtExam 
RatioOfFamilyIncomeToPoverty Alcohol4+perday EverAlcohol 
HowOftenLastYr(0never,1daily,2mostdays,10 1/2lastyear),#drinksperday/*;
PROC GLM data = folatefinal;
class fo (ref='1') gender (ref='2') race (ref='3') educ (ref='5') marst (ref='3') preg (ref='2') obese (ref='2') fourplus (ref='2') everalcoh (ref='1') alcohuse (ref='5');
Model LUXSMED=fo RIDAGEYR gender race educ marst preg INDFMPIR fourplus everalcoh alcohuse ALQ130 obese gender*obese gender*RIDAGEYR /solution;
run;
PROC GLM data = folatefinal;
class fo (ref='1') gender (ref='2') race (ref='3') educ (ref='5') marst (ref='3') fourplus (ref='2')obese (ref='2') alcohuse (ref='1');
Model LUXSMED=fo RIDAGEYR gender race educ marst INDFMPIR fourplus alcohuse ALQ130 obese/solution;
run;
PROC GLM data = folatefinal;
class fo4 (ref='1') gender (ref='2') race (ref='3') educ (ref='5') marst (ref='3') obese (ref='2') fourplus (ref='2') alcohuse (ref='1');
Model LUXSMED=fo4 RIDAGEYR gender race educ marst INDFMPIR fourplus alcohuse ALQ130 obese/solution;
run;
*/Secondary Step-wise Model/*;
PROC GLM data = folatefinal;
class fo (ref='1') gender (ref='2') race (ref='3') educ (ref='5') marst (ref='3') fourplus (ref='2')obese (ref='2') alcohuse (ref='1');
Model LUXSMED=fo RIDAGEYR gender race educ marst INDFMPIR fourplus alcohuse obese/solution;
run;
*/3rd Step-wise/*;
PROC GLM data = folatefinal;
class fo (ref='1') gender (ref='2') race (ref='3') educ (ref='5') marst (ref='3') fourplus (ref='2')obese (ref='2');
Model LUXSMED=fo RIDAGEYR gender race educ marst INDFMPIR fourplus obese/solution;
run;
*/4th Step-wise/*;
PROC GLM data = folatefinal;
class fo (ref='1') gender (ref='2') race (ref='3') educ (ref='5') marst (ref='3') obese (ref='2');
Model LUXSMED=fo RIDAGEYR gender race educ marst INDFMPIR obese/solution;
run;
*/5th Step-wise/*;
PROC GLM data = folatefinal;
class fo (ref='1') gender (ref='2') race (ref='3') educ (ref='5') marst (ref='3') obese (ref='2');
Model LUXSMED=fo RIDAGEYR gender race educ marst obese/solution;
run;
*/Final Model/*;
PROC GLM data = folatefinal;
class fo (ref='1') gender (ref='2') race (ref='3') educ (ref='5') obese (ref='2');
Model LUXSMED=fo RIDAGEYR gender educ obese/solution;
run;
PROC GLM data = folatefinal;
class fo (ref='1') gender (ref='2') race (ref='3') educ (ref='5') obese (ref='2');
Model LUXSMED=fo RIDAGEYR obese*gender educ /solution;
run;
*/Final Model quartiles/*;
PROC GLM data = folatefinal;
class fo4 (ref='1') gender (ref='2') race (ref='3') educ (ref='5') marst (ref='3') obese (ref='2');
Model LUXSMED=fo4 RIDAGEYR educ gender*obese/solution;
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
title 'Folate Status Quartiles';
VBAR fo4;
RUN;
PROC SGPLOT DATA = folatefinal;
title 'Liver Stiffness Cont.';
VBAR LUXSMED;
RUN;
PROC SGPLOT DATA = folatefinal;
title 'Folate status cont.';
VBAR LBDRFO;
RUN;
proc sgplot data = folatefinal;
title 'Scatter Plot for All Folate and Stiffness Data';
scatter x=LBDRFO y=LUXSMED;
run;



*//---Remove---//*;
proc freq data = folatefinal;
title 'Categorical CHISQ';
table fo*LUXSMED /CHISQ OR CMH;
run;
proc logistic data = folatefinal;
title 'Logistic Regression with Categorical';
class fo (ref='1') ls (ref='1');
model ls = fo RIDAGEYR gender educ obese;
run;
 proc ANOVA data=folatefinal;
	title One-way ANOVA;
	class fo;
	model  ls=fo RIDAGEYR gender educ obese;
	means fo /hovtest welch;
	run;
*proc print data= ;
*run;
proc logistic data = folatefinal;
title 'Logistic Regression with Categorical';
class fo (ref='1') ls (ref='1') gender(ref='2') educ (ref='1') Marst (ref='1');
model ls = fo RIDAGEYR gender race educ marst preg INDFMPIR fourplus everalcoh alcohuse avealcoh;
run;

proc freq data=folatefinal;
tables gender;
run;
proc freq data=folatefinal;
tables educ;
run;
proc freq data=folatefinal;
tables race;
run;
proc freq data=folatefinal;
tables everalcoh;
run;
proc freq data=folatefinal;
tables martst;
run;
proc freq data=folatefinal;
tables obese;
run;
