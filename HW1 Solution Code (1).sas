libname methods2 "C:\Users\chech\OneDrive - Medical University of South Carolina\MUSC courses\2023 Spring\Method 2 TA\Homework\Homework 1";
run;
proc import out=DemoData datafile='C:\Users\chech\OneDrive - Medical University of South Carolina\MUSC courses\2023 Spring\Method 2 TA\Homework\Homework 1\DemoData.csv' dbms=CSV replace; 
run;
proc import out=ExtraData datafile='C:\Users\chech\OneDrive - Medical University of South Carolina\MUSC courses\2023 Spring\Method 2 TA\Homework\Homework 1\ExtraData.csv' dbms=CSV replace; 
run;

proc print data=DemoData(obs=20);run;
proc print data=ExtraData(obs=20);run;



/*#############################################################################################*/
/*#############################################################################################*/
*Formatting statements for data cleaning;
/*#############################################################################################*/
/*#############################################################################################*/
PROC FORMAT;
Value Sex
			0='0 Male'
			1='1 Female'; 
Value Gender
			0='0 Male'
			1='1 Female'; 
Value Alcohol
			0 = '0 No Alcohol'
			1 = '1 1-2 Servings Per Week'
			2 = '2 3-4 Servings Per Week'
			3 = '3 4-5 Servings Per Week'
			4 = '4 6+  Servings Per Week';
Value Smoking
			0 = "0 Never Smoked"
			1 = "1 Former Smoker"
			2 = "2 Current Smoker";
Value Diabetes
			0='0 Not Diabetic'
			1='1 Diabetic'; 
Value BloodPressure
			0='0 Normal Blood Pressure'
			1='1 High Blood Pressure'; 
Value Stage
			. = 'Missing'
			1 = '1 Stage 1 Disease'
			2 = '2 Stage 2 Disease'
			3 = '3 Stage 3 Disease'
			4 = '4 Stage 4 Disease';
Value Treatment
			. = 'Missing'
			1 = '1 Treatment A'
			2 = '2 Treatment B';

/* Randomization and Birthday format using MMDDYYS10.; */
			
run; 

/*#############################################################################################*/
/*#############################################################################################*/
/* Reading in the first dataset, demographic data */
/*#############################################################################################*/
/*#############################################################################################*/
data DemoData;
set DemoData;
format Sex Sex.;
subjectid  = subid;
    rand   = input(RandomizationDate, MMDDYY10.);
	birth  = input(DateOfBirth, MMDDYY10.);
	year   = intck("year",birth, rand);
	months = intck("month", birth, rand);
	/*age = floor ((intck('month',birth,rand) - (day(rand) < day(birth))) / 12); */
	age = round((intck('month',birth,rand) - (day(rand) < day(birth))) / 12,.1); 
	drop DateOfBirth RandomizationDate year months rand birth;
run;
proc print data=demodata(obs=20);run;
proc contents data = demodata;
run; 


data ExtraData;
set ExtraData;
subjectid = subject;
format Smoke Smoking.;
format Alcohol Alcohol.;
format Diabetes  Diabetes.;
format HighBloodPressure BloodPressure.;
format Gender Gender.;
run;
proc contents data = ExtraData;
run; 

data OutcomeData;
set methods2.OutcomeData;
StageNew  = Stage*1+0;
TRT = Treatment*1+0;
subjectid = id;
format StageNew Stage.;
format TRT Treatment.;
run;
proc print data=OutcomeData(obs=20);run;
proc contents data = OutcomeData;
run;


/*#############################################################################################  
format Stage Stage.;
format Treatment Treatment.;*/
/*#############################################################################################*/
/* Checking variables for missing values or values that do not make sense */
/*#############################################################################################*/
/*#############################################################################################*/

/* Dataset 1 -  Demographic Data */
/* checking height*/
proc sgplot data = demodata;
histogram height;
run;
proc print data = demodata;
var height;
where height<40;
run;
/* checking age*/
proc sgplot data = demodata;
histogram age;
run;
proc print data = demodata;
var age; 
where subid<10;
run;
/* checking weight*/
proc sgplot data = demodata;
histogram weight;
run;
proc print data = demodata;
var weight;
where weight<125;
run;
/* checking sex*/
proc freq data = demodata;
tables sex;
run;


/* Dataset 2 - Extra Data */
proc freq data = extradata;
tables smoke alcohol diabetes highbloodpressure gender;
run;



/*Dataset 3 - Outcome Data*/
proc freq data = outcomedata;
tables stagenew trt;
run;
/*printing off subjects with missing data values*/
proc print data = outcomedata;
var stagenew;
where stagenew = .;
run;
proc print data = outcomedata;
var trt; 
where trt = .;
run;
proc print data = outcomedata;
var id wbc;
where wbc<0;
run;


proc sort data = demodata;
by subid;
run;
proc sort data = extradata;
by subjectid;
run;
proc sort data = outcomedata;
by id;
run;


data MergedData;
merge demodata extradata outcomedata;
by subjectid;
run;

proc print data=MergedData(obs=20);run;


proc print data = MergedData; 
var subjectid trt age  stagenew wbc height weight sex gender;
where gender ~=sex ;
run;

/* if subject has missing stage or treatment variable */
proc print data = MergedData; 
var subjectid trt age  stagenew wbc height weight sex gender;
where trt = . ! stagenew = . ! wbc<0 ! gender ~=sex ! height<40 ! weight<125;
run;

data badsubs;
set mergeddata;
if trt = . ! stagenew = . ! wbc<0 ! gender ~=sex ! height<40 ! weight<125 then keep = 1;
else keep = 0;
run;

proc print data=badsubs(obs=20);run; 

data badsubsprint;
set badsubs;
if keep=0 then delete;
drop subjectid subject id keep;
run;
proc print data=badsubsprint(obs=20);run; 

data exportdata;
set mergeddata;
drop subject subjectid id;
if trt = . ! stagenew = . then delete;
format _ALL_;
run;


proc export data=badsubsprint
   outfile='C:\Users\chech\OneDrive - Medical University of South Carolina\MUSC courses\2023 Spring\Method 2 TA\Homework\Homework 1\badsubs.csv'
   dbms=csv
   replace;
   where trt = .;
run;



proc export data=exportdata
   outfile='C:\Users\chech\OneDrive - Medical University of South Carolina\MUSC courses\2023 Spring\Method 2 TA\Homework\Homework 1\CleanedData.csv'
   dbms=csv
   replace;
   where trt = .;
run;


proc contents exportdata; run;

