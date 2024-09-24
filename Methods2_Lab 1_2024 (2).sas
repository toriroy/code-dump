/*Methods 2 LAB: Lecture 1*/ 
/* NAME:                   */
/* Date created: 01/02/2023  */
/* Last revised: 01/02/2024  */
/*Original Dataset: https://cran.r-project.org/web/packages/medicaldata/medicaldata.pdf*/
/*Two Subsets Data: Demographic + COVID Info*/


/*-------Write a sub-heading for each section--------*/
/*---------------------IMPORT DATA-------------------*/
/*--------------------------------------------------*/

/* Add comment before every step indicating what you intend to do */
/* Assign a "libname" for your working directory (do this for every new program)   */
libname lab1 "/home/u44071514/lab_xy/lab_datasets"; 
			/*Replace this with your own path*/
/* Now check on the left panel and your new libname will appear as a folder.*/
/* Files in the folder will appear too. */


/*Import SAS File -- COVID Data*/
data covid;                           /*New Data Name in SAS*/
	set lab1.covid;                   /*Data file location by using libname*/
run;

/* Check the import - always check after every step */ 
proc print data=covid(obs=20);run;    /*Print firt 20 subjects*/
proc contents data=covid;run;         /*Check variable format*/
/* We can also glance the data by opening the "work"/"lab1" library folder on the left */



/* Import CSV File -- Demographics */
proc import                
	datafile="/home/u44071514/lab_xy/lab_datasets/demo.csv" 
	    	/*Provide the path to the original data*/
	out=demo           /*Name the new data as "demo" and save in the "work" library by default*/ 
	/* out = lab1.demo    <---- if you specify the library, the new data will be in "lab1"   */
	dbms=CSV replace;  /*Replace XXX to your data location*/	
run;

proc print data=demo(obs=20); run;    /*Print firt 20 subjects*/
proc contents data=demo; run;         /*Check variable format*/



/*-----------------------------------------------------------*/
/*------------------------LABEL DATA-------------------------*/
/*-----------------------------------------------------------*/

/* What is the variable originally like? */
PROC FREQ data= demo ORDER=freq; /* optional: order by frequency */
    TABLES gender patient_class;
RUN;
	/* refer to the data dictionary for
       gender: 0-female, 1-male;
	   patient class: 1-inpatient, 2-outpatient, 3- emergency */

PROC FREQ data= covid;
	TABLES result;   
RUN; /*similarly, refer to the data dictionary */


/*CREATE a labeling rule using PROC FORMAT */
PROC FORMAT;
Value gender_fmt                    /*Name of the formatting rule we create */    
			0='0 Female'			/*No semicolon(;) here*/
			1='1 Male'; 			/*semicolon(;)*/

Value patient_fmt                   /*Disposition of subject at time of collection*/
			1 = '1 Inpatient'
			2 = '2 Outpatient'
			3 = '3 Emergency';

Value result_fmt                    /*Covid PCR Test Result*/
			0='0 Negative'
			1='1 Postive'; 

Value drive_thru_fmt                /*Whether the specimen was collected via a drive-thru site*/
			0='0 No'
			1='1 Yes'; 

Value payor_fmt
			1 = '1 Comercial'
			2 = '2 Government'
			3 = '3 Self pay';			
run; 


/*Print out the data while applying the formating rule */
proc print data=demo(obs=20);
	format gender gender_fmt.;      /*Label gender variable with our rule named gender_fmt (remember the dot)*/
	format patient_class patient_fmt.;  /*Label patient_class */
run;

proc print data=covid(obs=20);
	format result result_fmt.            /*Label multiple variable in "one" format statement*/
		   drive_thru_ind drive_thru_fmt.
		   ;                                /*Can you label "payor_group" variable?*/
run;	

/*Was the data itself labeled? */
PROC FREQ data= demo ORDER=freq; /* optional: order by frequency */
    TABLES gender patient_class;
RUN;

/*Unlike the PROC steps, DATA steps will change the data */
DATA demo_new;   /* new data (before we are sure, don't overwrite the origina)*/
	SET demo;     /*"old" data */
	format gender gender_fmt.;   /*actually apply the format */
    format patient_class patient_fmt.;
run;

/*check our data with newly labeled variables */
PROC FREQ data=demo_new;
	TABLES gender patient_class;
RUN;


/*Practice in homework 1: import DemoData.csv, ExtraData.csv and outcomedata.sas7bdat into SAS 
                         Q1.d: format the categorical variables*/



/*-----------------------------------------------------------*/
/*-----------------------Data Cleaning-----------------------*/
/*---------------------------------------------------------------*/
 
/*--------------------------------------*/
/*Data cleaning for continuous Variable*/
/*-------------------------------------*/

/*1. Plotting continuous variable(s) */
/*1.1: Check Histogram*/
proc sgplot data=demo; 
	histogram age;          /*Plot histogram for age*/
run;

/*1.2: Check Boxplot*/
proc sgplot data=demo;
	vbox age;               /*Plot boxplot for age*/
run;


/*2. Check Basic Statistics of continuous variable(s)*/
proc means data=demo n nmiss mean std median qrange min max maxdec=2;  /*For more options: check SAS documentaion for Proc means*/
	var age;
run;
	/*spot any abnormal data points? */

/*Filter out the abnormal observations */
proc print data=demo;
	where age=999;          /*Print out Age=999*/
run;
data demo2;          		/*Create new dataset name*/
	set demo;        	    /*from orignial dataset*/
	where age<150;          /*Exclude extreme value (Age=999)*/
run;
proc print data=demo2(obs=20);run;

/*OR: we can filter by the subject IDs */
data demo3;          		/*Create new dataset name*/
	set demo;        	    /*from orignial dataset*/
	where subject_id~=25 | subject_id~=56;     /*subject id not equal to 25 OR 26*/
run;

/*3: Plot age histogram again on the cleaned data*/
proc sgplot data=demo2;     		/*Use cleaned subet data*/
	histogram age;            		/*Plot histogram for age*/
	title "Histogram of Age"; 		/*Change plot title*/
	xaxis label="Age (in years)";   /*Change X-axis label*/
 	yaxis label="Percent(%)";       /*Change Y-axis label*/
run;

proc sgplot data=demo2;   		    /*Use subset data*/
	vbox age;         	    		/*Plot boxplot for age*/
	title "Boxplot of Age";         /*Change plot title*/
	yaxis label="Age (in years)";   /*Change Y-axis label*/
run;



/*--------------------------------------*/
/*Data cleaning for categorical Variable*/
/*-------------------------------------*/

/*Check proportion*/
proc freq data=demo;
	table patient_class;                  /*Propostion patient class*/
	title "Prportion of Patient Class";    /*Make Title for the table*/
	format patient_class patient_class.;  /*Apply formatting if the data has not been formatted*/
run;


/*Crosstable of two categorical variables*/
proc freq data=covid;
	table result*payor_group;             /*Crosstable between test result and payor groups*/
	format result result.                 /*Label multiple variable in "one" format statement*/
		   payor_group payor_group.;
run;

/*note that the output table also shows the missing values, how do we know the detailed pattern of missing? */
proc freq data=covid;
	table result*payor_group / missprint;             /*Add the MISSPRINT option to TABLE*/
	format result result.                
		   payor_group payor_group.;
run;

/*Practice in homework 1 Q1.b: look for missing, non-plausible values and inconsistencies in the variables
                         Q1.c: filter out the abnormal subjects and save to a new dataset*/



/*--------------------------------------------------------------*/
/*--------------Merging data: two datasets example---------------*/
/*--------------------------------------------------------------*/

/*Here we want to merge "Demo" and "COVID" by the one common variable*/

/*STEP 0: Which variable we can match two datasets? */
/*STEP 1: Sort the datasets by that variable*/
proc sort data=demo;
	by subject_id;                /*Match two datasets by subject_id*/
run;
proc print data=demo(obs=20);run;

proc sort data=covid;
	by subject_id;
run;
proc print data=covid(obs=20);run;



/*STEP 2: Match two datasets using the subject identifier*/	
data mergedata;                    /*Name new merged dataset*/
	merge demo covid;			   /*Which two dataset we want to merge (can be more than two datasets)*/
	by subject_id;				   /*Match by subject ID*/
run;
proc print data=mergedata(obs=20);run;

/*You may also include more details and cleaning steps in this data step, such as formatting and dropping variables */
data mergedata;                   /*Name new merge dataset*/
	merge demo covid;			  /*Which two dataset we want to merge (can more than two datasets)*/
	by subject_id;				  /*Match by subject ID*/
	format gender gender.                  /*Label gender variable*/
		   patient_class patient_class.    /*Label patient class variable*/
		   result result.                  /*Label multiple variable in "one" format statement*/
		   drive_thru_ind drive_thru_ind.
		   payor_group payor_group.;
	/* drop gender; */
run;
proc print data=mergedata;run;


/*Practice in homework 1 Q1.e: merge your cleaned datasets into one data by subject ID */



/*-----------------------------------------------------------------*/
/*--------------------------Export Data--------------------------*/
/*-----------------------------------------------------------------*/

/*Export CSV File, similar to the PROC IMPORT syntax*/
proc export data=mergedata                 /*Export merged dataset*/ 
   outfile='XXX\cleandata.csv'  		   /*Replace XXX to Where you want to store new dataset*/
   dbms=csv
   replace;
run;


/*Export SAS File*/
libname out "XXX\Cleaned Dataset";  	/*Replace XXX to Where you want to store new dataset*/

data out.cleandata;                     /*Data Location + Create Clean Dataset Name*/
	set mergedata;                      /*Which dataset you want to save out*/
run;






/************************************************************************************************/
/*****************************************exercise**********************************************/
/************************************************************************************************/

/*=====Cleaning the demo data======*/
/*1: Can you select subjects with age between 29 to 31 years old*/
data demo4;          			/*Create new dataset name*/
	set demo;        	    	/*from orignial dataset*/
	where XXX;   			    /*Replace XXX here*/
run;
proc print data=demo3(obs=20);run;

data demo4;          			/*Create new dataset name*/
	set demo;        	    	/*from orignial dataset*/
	where age>=29 & age<=31;    /*Another way to code "and" operator*/
run;
proc print data=demo3(obs=20);run;

/*2: Can you select subjects with age less than 29 or greater than 31 years old*/
data demo4;          			/*Create new dataset name*/
	set demo;        	    	/*from orignial dataset*/
	where XXX;                  /*Replace XXX here*/    
run;
proc print data=demo3(obs=20);run;

data demo4;          			/*Copy old dataset*/
	set demo;        	    	/*from orignial dataset*/
	where age>29 | age<31;	    /*Another way to code "or" operator*/
run;
proc print data=demo3(obs=20);run;


/*3: Can you select "female" subjects with age between 29 to 31 years old*/
data demo4;          			/*Copy old dataset*/
	set demo;        	    	/*from orignial dataset*/
	where age>29 and age<31;
	where XXX;                  /*Replace XXX here*/
	format gender gender.;      /*Format gender varaiable*/
run;
proc print data=demo3(obs=20);run;

data demo4;          					 /*Copy old dataset*/
	set demo;        	    			 /*from orignial dataset*/
	where gender=0 & age>29 & age<31;    /*Combined two "where" statement together*/
	format gender gender.;      		 /*Format gender varaiable*/
run;
proc print data=demo3(obs=20);run;


/*=====Checking the covid data======*/
 
/*---Continuous Variable---*/

/*1: Check Histogram */
proc sgplot data=covid; 
	histogram XXX;          /*Replace XXX to the variable: day after start of the pandemic*/
run;

/*2: Check Basic Statistics*/
proc means data=covid  maxdec=;  						/*Exercise: Show me "sample size"/"mean"/"standard deviation"/"min"/"max"/"Only show 2 digits"*/
	var pan_day;                                    	/*day after start of pandemic*/
	title "Histogram of Days Afer Start Of Pandemic";
run;


/*---Categorical Variable---*/
/*3: Check proportion*/
proc freq data=covid;
	table  result drive_thru_ind payor_group;      /*Propostion*/
	format result result.                         /*Label multiple variable in "one" format statement*/
    	   drive_thru_ind drive_thru_ind.
		   payor_group payor_group.;
run;



/************************************************************************************************/
/************************************************************************************************/
