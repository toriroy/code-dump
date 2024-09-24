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

proc logistic data=framcar desc;
class cholcatbinary (ref='0') angina (ref='0') agebinary (ref='0') heartcat (ref='0') educbinary (ref='0') diabetes (ref='0') bpmeds (ref='0') /param=ref; 









/*/expb for exponentiated betas. Stratified odds ratio estimates*/


