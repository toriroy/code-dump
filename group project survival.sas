proc import out=new
datafile = "C:\Users\varoy\Desktop\NHISO4.PRO2.csv"
dbms=csv
replace;
getnames=yes;
run; 

data a1;
set a1;
if dibev = "1 Ye" then dib = 1;
if dibev = "2 No" then dib =.;
if dibev = "3 Bo" then dib = .;
if dibev = "7 Re" then dib =.;
if dibev = "9 Do" then dib = .;
run;
Sleep
data a1;
set a1;
if sleep = '3' then slpcat = 0;
if sleep = '4' then slpcat = 0;
if sleep = '5' then slpcat = 0;
if sleep = '6' then slpcat = 1;
if sleep = '7' then slpcat = 2;
if sleep = '8' then slpcat = 3;
if sleep = '9' then slpcat = 4;
if sleep = '10' then slpcat = 4;
if sleep = '11' then slpcat = 4;
if sleep = '12' then slpcat = 4;
if sleep = '13' then slpcat = 5;
if sleep = '14' then slpcat = 5;
if sleep = '15' then slpcat = 5;
if sleep = '16' then slpcat = 5;
if sleep = '18' then slpcat = 5;
if sleep = '19' then slpcat = 5;
if sleep = '20' then slpcat = 5;
run;
Sex
data a1;
set a1;
if sex = "1 Male" then male = 1;
if sex = "2 Female" then male = 0;
run;
 
Smoke
data a1;
set a1;
if smkev = "1 Yes" then smoke = 1;
if smkev = "2 No" then smoke = 0;
if smkev = "7 Ref" then smoke = .;
if smkev = "8 Not" then smoke =.;
if smkev = "9 Don" then smoke = .;
run;
 
Alcohol
data a1;
set a1;
if alcstat = "01 Lifetime abstainer" then alc = 0;
if alcstat = "02 Former infrequent" then alc = 1;
if alcstat = "03 Former regular" then alc = 1;
if alcstat = "04 Former unknown fr" then alc = .;
if alcstat = "05 Current infrequent" then alc = 2;
if alcstat = "06 Current light" then alc = 2;
if alcstat = "07 Current moderate" then alc = 3;
if alcstat = "08 Current heavier" then alc = 3;
if alcstat = "09 Current drinker, f" then alc = .;
if alcstat = "10 Drinking status un" then alc = .;
run;
 
Physical Activity
New variable = minutes of activity X freq per week = weekly PA
Continuous = PA
data a1;
set a1;
PA = modmin*modfreqw;
run;
Inactivity
data a1;
set a1;
if pa < 180 then inact = 1;
if pa GE 180 then inact = 0;
run;
 
AGE
Continuous or cat
data a1;
set a1;
if age_p < 25 then agecat = 0;
if age_p GE 25 LE 34 then agecat =1;
if age_p GE 35 LE 44 then agecat = 2;
if age_p GE 45 LE 54 then agecat= 3;
if age_p GE 55 LE 64 then agecat=4;
if age_p GE 65 then agecat=5;
run;
 
 
 
 
Race:
data a1;
set a1;
if hiscodi2 = "1 Hispanic" then race = 3;
if hiscodi2 = "2 Non-Hispanic White" then race = 1;
if hiscodi2 = "3 Non-Hispanic Black" then race = 2;
if hiscodi2 = "4 Non-Hispanic All o" then race = 4;
run;
 
BMI
Continuous or categorical
data a1;
set a1;
if bmi GE 0 LT 18.5 then bmicat = 0;
if bmi GE 18.5 LE 24.9 then bmicat = 1;
if bmi  GE 25 LE 29.9 then bmicat = 2;
if bmi  GE 30 then bmicat = 3;
run;
 
Hypertension
data a1;
set a1;
if hypev = "1 Ye" then hype = 1;
if hypev = "2 No" then hype = 0;
if hypev = "7 Re" then hype = .;
if hypev = "9 Do" then hype = .;
run;
 
Education:
data a1;
set a1;
if educ1 = "00 Never attended/kindergarten only" then ed = 1;
if educ1 = "01 1st grade" then ed = 1;
if educ1 = "02 2nd grade" then ed = 1;
if educ1 = "03 3rd grade" then ed = 1;
if educ1 = "04 4th grade" then ed = 1;
if educ1 = "05 5th grade" then ed = 1;
if educ1 = "06 6th grade" then ed = 1;
if educ1 = "07 7th grade" then ed = 1;
if educ1 = "08 8th grade" then ed = 1;
if educ1 = "09 9th grade" then ed = 1;
if educ1 = "10th grade" then ed = 1;
if educ1 = "11th grade" then ed = 1;
if educ1 = "12th grade, no diploma" then ed = 1;
if educ1 = "13 GED or equivalent" then ed = 2;
if educ1 = "14 High School Graduate" then ed = 2;
if educ1 = "15 Some college, no degree" then ed = 2;
if educ1 = "16 Associate degree: occupational, technical, or vocat" then ed = 3;
if educ1 = "17 Associate degree: academic program" then ed = 3;
if educ1 = "18 Bachelor's degree (Example: BA, AB, BS, BBA)" then ed = 3;
if educ1 = "19 Master's degree (Example: MA, MS, MEng, MEd, MBA)" then ed = 4;
if educ1 = "20 Professional School degree (Example: MD, DDS, DVM," then ed = 4;
if educ1 = "21 Doctoral degree (Example: PhD, EdD)" then ed = 4;
if educ1 = "96 Child under 5 years old" then ed = missing;
if educ1 = "97 Refused" then ed = missing;
if educ1 = "98 Not ascertained" then ed = missing;
if educ1 = "99 Don't know" then ed = missing;
run;
 
Marital Status
data a1;
set a1;
if  R_MARITL = "0 Under 14 years" then mar = missing;
if  R_MARITL = "1 Married - spouse in household" then mar = 1;
if  R_MARITL = "2 Married - spouse not in house" then mar = 1;
if  R_MARITL = "4 Widowed" then mar = 2;
if  R_MARITL = "5 Divorced" then mar = 2;
if  R_MARITL = "6 Separated" then mar = 2;
if  R_MARITL = "7 Never married" then mar = 0;
if  R_MARITL = "8 Living with partner" then mar = 3;
if  R_MARITL = "9 Unknown marital status" then mar = missing;
run;
 



