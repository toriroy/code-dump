libname M8 'C:\Users\lcowan\Desktop\Fall 2019\EPID 7134\SAS';
proc means data = M8.newframingham sum;
class BMI2;
var TIMEDTH;
run;
proc sort data = M8.newframingham;
by descending BMI2 descending death;
run;
proc freq data = m8.newframingham order=data;
table BMI2*death;
run;

data m8.cohort;
set M8.newframingham;
lpdays = log(TIMEDTH);
run;
proc genmod data = m8.cohort;
Class BMI2 (ref='0');
model death = BMI2 /dist=poisson link=log offset = lpdays  type3;
run; 

proc genmod data = m8.cohort;
class BMI2 (ref='0');
model death = BMI2 /dist=poisson link=log offset = lpdays  type3;
estimate 'Beta' BMI2 1 -1/ exp;
run; 

proc genmod data = m8.cohort;
class bmi2 (ref = '0') sex (ref = '2');
model death = BMI2 Sex /dist=poisson link=log offset = lpdays  type3;
estimate 'Beta' BMI2 1 -1/ exp;
estimate 'Beta' Sex 1 -1/ exp;
run; 

proc genmod data = m8.cohort;
class bmi2 (ref = '0') sex (ref = '2');
model death = BMI2 Sex BMI2*Sex /dist=poisson link=log offset = lpdays  type3;
run; 

proc sort data = M8.newframingham;
by sex;
run;

proc lifetest data=m8.newframingham atrisk plots=survival;
time TIMEDTH*death(0);
strata sex;
run;


