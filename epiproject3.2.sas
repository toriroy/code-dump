proc import file = 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\frmgham_period1.csv'
dbms=csv
out=fram;
run;

data framcat;
set fram;
/*categorical total cholesterol*/
if totchol LT 200 then cholcat = '1'; /*normal*/
if totchol GE 200 and cholcat LE 239 then cholcat = '2'; /*borderline high*/
if totchol GE 240 then cholcat = '3'; /*high, at or above 240 mg/dl*/
if totchol  = . then delete;
/*Dichotomized total cholesterol */
if totchol LE 239 then cholcatbinary = '0'; /*borderline high*/
if totchol GE 240 then cholcatbinary = '1'; /*high, at or above 240 mg/dl*/
if totchol  = . then delete;
/*Changing age and Heart rate to categorical. New Code!*/
if Age GE 32 and Age LE 42  then agecat = '1'; /*32-42*/
if Age GE 43 and Age LE 53 then agecat = '2'; /*43-53*/
if Age GE 54 then agecat = '3'; /*54-64*/
if age = . then delete;
if heartrte LE 75 then heartcat = '0'; /*Lower and Higher than 75*/ ; 
if heartrte GE 76 then heartcat = '1';
if heartrte = . then delete;
/*Dichotomizing age to "younger" and "older"*/
if age LE 60 then agebinary = '0'; 
if Age GE 61 then agebinary = '1'; 
if age = . then delete;
/*Changing BMI to categorical*/
if bmi LE 18.4 then bmicat = '1'; /*underweight*/
if bmi GE 18.5 and bmi LE 24.9 then bmicat = '2'; /*normal weight*/
if bmi GE 25 and bmi LE 29.9 then bmicat = '3'; /*overweight*/
if bmi GE 30 then bmicat = '4';
if bmi = . then delete;
/*BMI as binary. Because the underweight group is so small, compining with normal*/
if bmi LE 24.9 then bmibinary = '0';
if bmi GE 25 then bmibinary = '1';
/*education as binary variable*/
if educ LE 2 then educbinary = '1'; /*0 - 11 years and HS diploma, GED*/
if educ GT 2 then educbinary ='0'; /*Some college, vocational school and 4 year degree +/ reference group*/
run;


/*Crude*/

proc logistic data=framcat descending;
class cholcatbinary (ref='0') angina (ref='0') /param=ref;
model angina = cholcatbinary;
run;

/*all variables all interactions*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') heartcat (ref='0') educbinary (ref='0') diabetes (ref='0')  /param=ref; 
model angina = cholcatbinary sex bmibinary agebinary heartcat educbinary diabetes cholcatbinary*sex cholcatbinary*bmibinary cholcatbinary*agebinary cholcatbinary*heartcat cholcatbinary*educbinary cholcatbinary*diabetes cholcatbinary*bpmeds;
run;
/*Remove interaction terms BPmeds*chol and diabetes*chol*/

/*BACKWARDS STEPWAISE*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') heartcat (ref='0') educbinary (ref='0') diabetes (ref='0')  /param=ref; 
model angina = cholcatbinary agebinary sex heartcat bmibinary educbinary diabetes glucose cholcatbinary*educbinary;
run;
/*remove glucose*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') heartcat (ref='0') educbinary (ref='0') diabetes (ref='0')  /param=ref; 
model angina = cholcatbinary agebinary sex heartcat bmibinary educbinary diabetes cholcatbinary*educbinary;
run;

/*remove heartcat*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0') diabetes (ref='0')  /param=ref; 
model angina = cholcatbinary agebinary sex educbinary bmibinary diabetes cholcatbinary*educbinary;
run;

/*remove diabetes*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0') /param=ref; 
model angina = cholcatbinary agebinary sex educbinary bmibinary cholcatbinary*educbinary /corrb;
run;

/*FINAL MODEL*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary sex educbinary bmibinary cholcatbinary*educbinary ;
run;


/*sidenote: interesting interaction*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') heartcat (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0') bpmeds (ref='0') /param=ref; 
model angina = cholcatbinary agebinary sex educbinary heartcat bmibinary bpmeds cholcatbinary*educbinary cholcatbinary*heartcat/corrb;
run;
/*check bpmeds*/
proc freq data=framcat;
tables angina*cholcatbinary /or chisq;
run;
proc freq data=framcat;
where (bpmeds = 1);
tables angina*cholcatbinary/or chisq;
run;
proc freq data=framcat;
where (bpmeds = 0);
tables angina*cholcatbinary/or chisq;
run;
proc freq data=framcat;
tables bpmeds*angina /or chisq;
run;
proc corr data=framcat;
var bpmeds angina;
run;

/* OR between angina and bpmeds is 2.8249 [1.9731 4.0446] high CI upper, concerned with colinearity*/
/*/expb for exponentiated betas. Stratified odds ratio estimates. strata statment v by statement?*/

/*#2: outliers*/

proc freq data=framcat;
tables angina;
run;
proc freq data=framcat;
tables cholcatbinary;
run;
proc freq data=framcat;
tables agebinary;
run;
proc freq data=framcat;
tables sex;
run;
proc freq data=framcat;
tables educbinary;
run;
proc freq data=framcat;
tables bmibinary;
run;
/*BMI has 41 missing obs.*/
proc univariate data=framcat;
var totchol;
class angina;
histogram/normal;
run;
proc univariate data=framcat;
var totchol;
histogram/normal;
run;
ods output sgplot=boxplot_data;
proc sgplot data=fram;
vbox totchol /category=angina;
run;
proc print data=boxplot_data;
run;
proc univariate data=framcat;
var bmi;
class angina;
histogram/normal;
run;
proc univariate data=framcat;
var bmi;
histogram/normal;
run;
ods output sgplot=bmiboxplot_data;
proc sgplot data=fram;
vbox bmi /category=angina;
run;
proc print data=bmiboxplot_data;
run;

ods output sgplot=hrtboxplot_data;
proc sgplot data=fram;
vbox heartrte /category=angina;
run;
proc print data=hrtboxplot_data;
run;
proc univariate data=framcat;
var heartrte;
class angina;
histogram/normal;
run;
proc univariate data=framcat;
var heartrte;
histogram/normal;
run;
proc sgplot data=fram;
vbox heartrte /category=angina;
run;
proc freq data=framcat;
table angina;
run;

/*#3: model*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary sex educbinary bmibinary cholcatbinary*educbinary /corrb ;
run;
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary sex bmibinary /corrb ;
where educbinary = '0';
run;
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='1')/param=ref; 
model angina = cholcatbinary agebinary sex bmibinary /corrb ;
where educbinary = '1';
run;
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary bmibinary /corrb ;
where sex = 1;
run;
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='1')/param=ref; 
model angina = cholcatbinary agebinary bmibinary /corrb ;
where sex = 2;
run;
/*#4*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') heartcat (ref='0') educbinary (ref='0') diabetes (ref='0') bpmeds (ref='0') /param=ref; 
model angina = cholcatbinary sex bmibinary agebinary heartcat educbinary diabetes bpmeds cholcatbinary*educbinary;
run;

/*AIC is increasing, forward regression to check*/


/*FINAL MODEL*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary sex educbinary bmibinary cholcatbinary*educbinary /corrb;
run;

/*Forward stepwise regression, Checking model fit */
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary;
run;
/*add age*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary;
run;
/*add sex*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary sex;
run;
/*add BMI*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary sex bmibinary;
run;
/*add education*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary sex bmibinary educbinary;
run;
/*add glucose*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary sex bmibinary educbinary glucose;
run;

/*glucose p-value: 0.1455*/
/*add interaction, remove glucose*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary sex bmibinary educbinary cholcatbinary*educbinary;
run;
/*add diabetes*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') diabetes (ref='0') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary sex bmibinary educbinary diabetes cholcatbinary*educbinary;
run;
/*diabetes is on the line of signficiance p=0.0542, testing stratification by diabetes*/

/*stratified by diabetes*/

proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') diabetes (ref='1') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary bmibinary diabetes/corrb ;
run;
/*OR = 1.572 1.334 1.852 */
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') diabetes (ref='1') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary bmibinary /corrb ;
where diabetes = 1;
run;
/*OR d= y : 1.778 [0.766 4.131] p=0.1807 */
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='1')/param=ref; 
model angina = cholcatbinary agebinary bmibinary /corrb ;
where diabetes = 0;
run;
/* OR d= n : 1.560 [1.319 1.844]  */
/*tested interaction between diabetes and all included variables, outcome, and main exposure. None were significant. Added them below just for reference, they were not tested together but in sep. models for each with covariates*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') diabetes (ref='0') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0')/param=ref; 
model angina = cholcatbinary agebinary sex bmibinary educbinary diabetes cholcatbinary*educbinary cholcatbinary*diabetes diabetes*angina diabetes*sex diabetes*age diabetes*bmibinary;
run;


/*Odds ratios, changing where interaction is added*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') heartcat (ref='0') educbinary (ref='0') diabetes (ref='0')  /param=ref; 
model angina = cholcatbinary agebinary sex heartcat bmibinary educbinary diabetes glucose; /*cholcatbinary*educbinary*/
run;
/*remove glucose*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') heartcat (ref='0') educbinary (ref='0') diabetes (ref='0')  /param=ref; 
model angina = cholcatbinary agebinary sex heartcat bmibinary educbinary diabetes; /*cholcatbinary*educbinary*/
run;
/*remove heartcat*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0') diabetes (ref='0')  /param=ref; 
model angina = cholcatbinary agebinary sex bmibinary educbinary diabetes; /*cholcatbinary*educbinary*/
run;
/*remove diabetes*/
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0') /param=ref; 
model angina = cholcatbinary agebinary sex bmibinary educbinary; /*cholcatbinary*educbinary*/
run;
/*add interaction*/

proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary (ref='0') /param=ref; 
model angina = cholcatbinary agebinary sex bmibinary educbinary cholcatbinary*educbinary;
run;

proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary /param=ref; 
model angina = cholcatbinary agebinary sex bmibinary; 
where educbinary='1';
run;
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary /param=ref; 
model angina = cholcatbinary agebinary sex bmibinary; 
where educbinary='0';
run;
proc logistic data=framcat desc;
class cholcatbinary (ref='0') angina (ref='0') sex (ref='2') bmibinary (ref='0') agebinary (ref='0') educbinary /param=ref; 
model angina = cholcatbinary agebinary sex bmibinary; 
run;
