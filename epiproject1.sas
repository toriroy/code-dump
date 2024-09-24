proc import file = 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\frmgham_period1.csv'
dbms=csv
out=fram;
run;
data framcat;
set fram;
if glucose LE 70 then glucat = '1';
if glucose GT 70 and glucose LE 100 then glucat = '2';
if glucose GT 100 and glucose LE 125 then glucat = '3';
if glucose GT 125 then glucat = '4';
if glucose = . then delete;
run;
/*categories based on Blood Glucose monitoring Thomas Mathew et al. 2023*/
/*changing glucat to a three level variable*/
data framcat2;
set framcat;
if glucose LE 100 then glucat = '1';
if glucose GT 100 and glucose LE 125 then glucat = '2';
if glucose GT 125 then glucat = '3';
run;
/*changing glucat to a binary variable*/
data framcat3;
set framcat;
if glucose LE 125 then glucat = '0';
if glucose GT 125 then glucat = '1';
run;

/*categorical total cholesterol*/
data framchol;
set fram;
if totchol LT 200 then cholcat = '1'; /*normal*/
if totchol GE 200 and cholcat LE 239 then cholcat = '2'; /*borderline high*/
if totchol GE 240 then cholcat = '3'; /*high, at or above 240 mg/dl*/
if totchol  = . then delete;
run;
data framchol2;
set fram; 
if totchol LE 239 then cholcat = '1'; /*borderline high*/
if totchol GE 240 then cholcat = '2'; /*high, at or above 240 mg/dl*/
if totchol  = . then delete;
run;
proc freq data=framchol;
tables cholcat;
run;

proc freq data=framchol2;
tables cholcat;
run;
ods graphics on;
proc logistic data=framchol descending;
class  angina (ref='0') cholcat (ref='1') / param=ref;
model angina = cholcat /corrb;
run;
proc lifetest data=framchol2 method=km;
 time timeap*angina(0);
 strata cholcat;
run;

proc freq data=framchol;
tables angina*cholcat;
run;

proc logistic data=framchol descending;
class  angina (ref='0') cholcat (ref='1')/ param=ref;
model angina = cholcat sex age bmi/corrb;
run;

/*checking data set*/
/*outcomes*/
proc freq data=framchol;
tables cholcat;
run;
proc freq data=fram;
tables HOSPMI;
run;
proc freq data=fram;
tables HOSPMI;
run;
proc freq data=fram;
tables MI_FCHD;
run;
proc freq data = fram;
tables anychd;
run;
proc freq data = fram;
tables stroke;
run;
proc freq data = fram;
tables hyperten;
run;
proc freq data=fram;
tables cvd;
run;
proc freq data = fram;
tables angina;
run;
proc freq data=framchol;
tables angina*cholcat;
run;
proc chart data = fram;
vbar angina;
run;

proc freq data = fram;
tables death;
run;

/*predictor variables*/
proc univariate data=fram;
var totchol; 
histogram/normal;
run;

proc univariate data=fram;
var glucose; 
histogram/normal; 
run;
proc univariate data=fram;
var CIGPDAY;
histogram/normal; 
run;
proc univariate data=fram;
var sysbp;
histogram/normal; 
run;
proc univariate data=fram;
var diabp;
histogram/normal; 
run;
proc univariate data=fram;
var age;
histogram/normal; 
run;
/*age distribution is not normal*/
proc univariate data=fram;
var bmi;
histogram/normal; 
run;
proc freq data = fram;
tables cursmoke;
run;
proc freq data=fram;
tables sex;
run;
proc freq data=fram;
tables diabetes;
run;
proc freq data = fram;
tables bpmeds;
run;
proc freq data=framcat;
tables glucat;
run;
proc freq data=framcat2;
tables glucat;
run;
proc freq data=framcat3;
tables glucat;
run;
proc freq data = fram;
tables educ;
run;
/*testing sample size*/

/*glucose as categorical and hospital MI outcome, checking distribution for exposure and outcome*/
proc freq data = framcat;
tables GLUCAT*HOSPMI /OR chisq;
run;
/*Blood pressure medication and diabetes*/
proc freq data = fram;
tables bpmeds*diabetes /OR chisq;
run;
/*glucose as a categorical variable and hospital MI*/
proc freq data=framcat;
tables glucat*hospmi /OR chisq;
run;

/*proc corr for correlation information*/
proc corr data=fram;
    var sex totchol age sysbp diabp cursmoke cigpday bmi diabetes bpmeds heartrte glucose educ; 
run;
proc corr data=fram;
    var death angina hospmi mi_fchd anychd stroke cvd hyperten sex totchol age sysbp diabp cursmoke cigpday bmi diabetes bpmeds heartrte glucose educ; 
run;
proc corr data=fram;
var angina totchol age cursmoke cigpday bmi glucose diabetes educ sex heartrte;
run;
proc corr data=fram;
    var death angina hospmi mi_fchd anychd stroke cvd hyperten sex totchol age sysbp diabp cursmoke cigpday bmi diabetes bpmeds heartrte glucose educ; 
run;
proc corr data=fram;
var angina age cursmoke cigpday bmi glucose diabetes educ sex;
run;
proc corr data=fram;
var angina age sex BMI heartrte totchol;
run;
proc corr data =fram;
var angina sex;
run;

/*#6 and #7: chisq and ttest*/
proc ttest data=fram;
class angina;
var totchol;
title "Angina and Total Cholesterol";
run;
proc freq data = framchol;
tables angina*cholcat /chisq or;
title "Angina and Categorical Cholesterol (3-levels)";
run;
proc freq data = framchol2;
tables angina*cholcat /chisq or;
title "Angina and Categorical Cholesterol (binary)";
run;
proc freq data = framchol;
tables angina*cholcat /chisq or;
title "Angina and Total Chol.";
run;
/*angina and age*/
proc ttest data=fram;
class angina ;
var age ;
run;
/*angina and sex*/
proc freq data=fram;
tables angina*sex /chisq or;
run;
/*angina and BMI*/
proc ttest data=fram;
class angina;
var bmi;
run;
/*angina and heart rate*/
proc ttest data=fram;
class angina;
var heartrte;
run;
/*angina and totchol*/
proc ttest data=fram;
class angina;
var totchol;
run;




proc freq data = framcat;
tables hospmi*glucat /chisq;
title "Hospital MI and 4-level glucose variables";
run;
proc ttest data=framcat;
class hospmi;
var glucose;
title "Hospital MI and glucose";
run;
/*The distribution of glucose is not as close to normal as expected*/
proc ttest data=framcat;
class hospmi;
var cigpday;
title "Hospital MI and Cigs Per Day";
run;
proc ttest data=framcat;
class hospmi;
var totchol;
title "Hospital MI and total cholesterol";
run;
/*Total Chol is more normally distributed, changing predictor variable*/
/*logistic regression with glucose as pred. and Hospital MI as outcome*/
ods graphics on;
proc logistic data=fram descending;
class  hospmi (ref='0') sex (ref='1') / param=ref;
model HOSPMI = glucose /corrb;
run;
/*small effect, OR 1.005 [1.002, 1.008]
/*backwards step-wise regression for Hospital MI = Glucose*/
proc logistic data=fram descending;
class hospmi (ref='0') sex (ref='1') cursmoke (ref='0') educ (ref='4') /param=ref;
model hospmi = glucose sex age cursmoke educ bmi HEARTRTE /corrb;
run;
/*AIC=2449.088 remove heart rate*/
proc logistic data=fram descending;
class hospmi (ref='0') sex (ref='1') cursmoke (ref='0') educ (ref='4') /param=ref;
model hospmi = glucose sex age cursmoke educ bmi /corrb;
run;
/*Remove education */
proc logistic data=fram descending;
class hospmi (ref='0') sex (ref='1') cursmoke (ref='0') /param=ref;
model hospmi = glucose sex age cursmoke bmi/corrb;
run;
proc logistic data=fram descending;
class hospmi (ref='0') sex (ref='1') cursmoke (ref='0') /param=ref;
model hospmi = glucose sex age cursmoke bmi /corrb;
missing glucose;
run;
/*AIC=2498.073
OR = 1.004 [1.001, 1.007]*/
/*Would the model be a better fit if glucose was categorical?*/
/*glucat (4-levels)*/
proc logistic data=framcat descending;
class glucat (ref='2') hospmi (ref='0')  sex (ref='1') /param=ref;
model hospmi = glucat/corrb;
run;
/*AIC=2676.625
no significant except in 4 v 2 highest glucose level vs normal*/
/*glutcat - 3-levels*/
proc logistic data=framcat2 descending;
class glucat (ref='2') hospmi (ref='0') sex (ref='1') /param=ref;
model hospmi = glucat/corrb;
run;
/*AIC=2676.352
same result*/
/*glucat - binary variable, significant*/
proc logistic data=framcat3 descending;
class glucat (ref='0') hospmi (ref='0') sex (ref='2') /param=ref;
model hospmi = glucat/corrb;
run;
/*glucat 1 v 0 OR = 2.448 [1.477, 4.058]*/
/*AIC=2676.488*/
/*Glucat (binary) all potential covariates*/
proc logistic data=framcat3 descending;
class glucat (ref='0') hospmi (ref='0') sex (ref='1')cursmoke (ref='0') educ (ref='4') /param=ref;
model hospmi = glucat sex age cursmoke educ bmi HEARTRTE cigpday/corrb;
run;
/*AIC=2436.233*/
/*backwards stepwise regression for glucat (binary) and hospital MI*/
/*remove heartrate*/
proc logistic data=framcat3 descending;
class glucat (ref='0') hospmi (ref='0') sex (ref='1')cursmoke (ref='0') educ (ref='4') /param=ref;
model hospmi = glucat sex age cursmoke educ bmi cigpday/corrb;
run;
/*remove education*/
proc logistic data=framcat3 descending;
class glucat (ref='0') hospmi (ref='0') sex (ref='1')cursmoke (ref='0') /param=ref;
model hospmi = glucat sex age cursmoke bmi cigpday/corrb;
run;
/*remove cigs per day*/
proc logistic data=framcat3 descending;
class hospmi (ref='0') glucat (ref='0') sex (ref='1')cursmoke (ref='0') /param=ref;
model hospmi = glucat sex age cursmoke bmi/corrb;
run;


/*survival analysis for glucose and hospital MI*/
proc phreg data = framcat3;
class sex (ref='1');
model TIMEMI*HOSPMI(0) = glucose / risklimits corrb;
run;
/*AIC=6752.590*/
proc phreg data = framcat3;
class glucat (ref='0') sex (ref='1')cursmoke (ref='0') educ (ref='4') /param=ref;
model TIMEMI*HOSPMI(0) = glucose sex age cursmoke educ bmi HEARTRTE / risklimits corrb;
run;
/*AIC=6346.404*/
proc phreg data = framcat3;
class glucat (ref='0') sex (ref='1')cursmoke (ref='0') /param=ref;
model TIMEMI*HOSPMI(0) = glucose sex age cursmoke bmi HEARTRTE / risklimits;
run;
/*AIC=6476.718*/
proc phreg data = framcat3;
class glucat (ref='0') sex (ref='1')cursmoke (ref='0')/param=ref;
model TIMEMI*HOSPMI(0) = glucose sex age cursmoke bmi / risklimits;
run;
/*AIC= 6489.761*/

proc lifetest data=framcat method=km;
 time timemi*hospmi(0);
 strata glucat;
run;
proc lifetest data=framcat2 method=km;
 time timemi*hospmi(0);
 strata glucat;
run;
proc lifetest data=framcat3 method=km;
 time timemi*hospmi(0);
 strata glucat;
run;
proc lifetest data=framcat3 method=km;
 time timemi*hospmi(0);
 strata sex/group=glucat;
run;
/*Unhappy with glucose distribution, exploring total cholesterol*/
proc ttest data=framcat;
class hospmi;
var cigpday;
title "Hospital MI and Cigs Per Day";
run;
proc ttest data=framcat;
class hospmi;
var totchol;
title "Hospital MI and total cholesterol";
run;
/*Total Chol is more normally distributed, changing predictor variable. Glucose would be better suited for categorical*/

proc logistic data=framcat descending;
class hospmi (ref='0') ;
model hospmi = totchol/corrb;
run;

/*Other possible models*/

proc freq data = fram;
tables angina*totchol /chisq or;
title "Angina and Total Chol.";
run;
proc logistic data=fram descending;
class angina (ref='0') /param=ref;
model angina = totchol;
run;
/*backwards stepwise regression for new Angina = Total Cholesterol*/
proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') cursmoke (ref='0') educ (ref='4') diabetes (ref='0')/param=ref;
model angina=totchol diabetes sex age cursmoke educ bmi HEARTRTE cigpday/corrb;
run;
/*Remove cursmoke p=0.6558*/
proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') educ (ref='4') diabetes (ref='0')/param=ref;
model angina=totchol diabetes sex age educ bmi HEARTRTE cigpday/corrb;
run;
/*Remove cigpday p=0.7559*/
proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') educ (ref='4') diabetes (ref='0')/param=ref;
model angina=totchol diabetes sex age educ bmi HEARTRTE/corrb;
run;
/*remove diabetes p=0.1514, second highest is education 1 p=0.1104, but other levels are significant*/
proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') educ (ref='4')/param=ref;
model angina=totchol sex age educ bmi HEARTRTE/corrb;
run;
/*choice between education 1 p=0.1147 (however, 2 p=0.0071 and 3 p=0.0829) and heart rate p=0.0881
remove both and see*/
proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') educ (ref='1')/param=ref;
model angina=totchol sex age educ bmi/corrb;
run;
proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') /param=ref;
model angina=totchol sex age bmi HEARTRTE/corrb;
run;
/*Remove education, heart rate remain slightly significant p=0.0484*/

proc logistic data=fram descending;
class angina (ref='0') sex (ref='1') /param=ref;
model angina=totchol sex age bmi /corrb;
run;

proc phreg data = fram;
class  angina (ref='0') sex (ref='1') cursmoke (ref='0') educ (ref='4') diabetes (ref='0')/param=ref;
model TIMEAP*ANGINA(0) = totchol diabetes sex age cursmoke educ bmi HEARTRTE cigpday / risklimits corrb;
run;
/*Number of days from Baseline exam to first Angina during the followup
or Number of days from Baseline to censor date. Censor date may be
end of followup, death or last known contact date if subject is lost to
followup*/
/*remove cigpday p=0.9740*/
proc phreg data = fram;
class  angina (ref='0') sex (ref='1') cursmoke (ref='0') educ (ref='4') diabetes (ref='0')/param=ref;
model TIMEAP*ANGINA(0) = totchol diabetes sex age cursmoke educ bmi HEARTRTE / risklimits corrb;
run;
/*remove cursmoke p=0.3436 */
proc phreg data = fram;
class  angina (ref='0') sex (ref='1') educ (ref='4') diabetes (ref='0')/param=ref;
model TIMEAP*ANGINA(0) = totchol diabetes sex age educ bmi HEARTRTE / risklimits corrb;
run;
/*remove heart rate p=0.3292 */
proc phreg data = fram;
class  angina (ref='0') sex (ref='1') educ (ref='4') diabetes (ref='0')/param=ref;
model TIMEAP*ANGINA(0) = totchol diabetes sex age educ bmi / risklimits corrb;
run;
/*remove education p=0.0593*/
proc phreg data = fram;
class  angina (ref='0') sex (ref='1') diabetes (ref='0')/param=ref;
model TIMEAP*ANGINA(0) = totchol diabetes sex age bmi / risklimits corrb;
run;
ods graphics on;
proc lifetest data=framchol method=km;
 time timeap*angina(0);
 strata sex /group=cholcat;
run;
proc lifetest data=framchol method=km;
 time timeap*angina(0);
 strata cholcat;
run;




/*Formatting*/

PROC FORMAT;
Value HOSPMI_fmt                        
			0='0 No'			
			1='1 Yes'; 
Value sex_fmt                  
			1 = '1 Male'
			2 = '2 Female';
run; 
proc print data=framcat(obs=10);
	format hospmi hospmi_fmt. 
	 sex sex_fmt.;
run;
DATA framcatformat;   
	Set framcat;     
	format hospmi HOSPMI_fmt.; 
	format sex sex_fmt.;
run;

/*Ignore*/

/*outcome: Any CHD and pred: glucose*/
ods graphics on;
proc logistic data=fram descending;
class  sex (ref='1') / param=ref;
model anychd = glucose;
run;

/*outcome: hypertension, pred: glucose*/
proc logistic data = fram descending;
class sex (ref='1')  / param=ref;
model hyperten = glucose sex age /corrb;
run; 

/*opposite effect of what you would expect*/
proc logistic data = fram descending;
class sex (ref='1') / param=ref;
model angina = cursmoke /corrb;
run; 
proc glm data =fram ;
model totchol =cursmoke;
run;

/*total chol. into categorical variable*/
data framcatchol;
set fram;
if totchol LT 200 then cholcat = '0';
if totchol GE 200 then cholcat = '1';
run;
proc logistic data = framcatchol descending;
class sex (ref='1') cholcat (ref='0') cursmoke (ref='0')/ param=ref;
model cholcat = cursmoke sex age/corrb;
run; 
/*not significant*/
/* Links for Glucat categories:
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5864122/
https://www.ncbi.nlm.nih.gov/books/NBK555976/
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5864122/
https://diabetesjournals.org/care/article/45/Supplement_1/S83/138927/6-Glycemic-Targets-Standards-of-Medical-Care-in

Cholesterol:
https://www.hopkinsmedicine.org/health/treatment-tests-and-therapies/lipid-panel 
oxford definition angina : https://languages.oup.com/google-dictionary-en/
*/
