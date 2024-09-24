/*Methods II LAB 4-5: Multiple Linear Regression and interactions */
/*Date: 01-31-2024, 02-07-2024*/
/*Datasets: Elementary, SENIC */
/*https://stats.oarc.ucla.edu/sas/webbooks/reg/chapter1/regressionwith-saschapter-1-simple-and-multiple-regression/ */


/*-------------------*/
/*Homework 2 review  */
/*-------------------*/

/*Import homework2  data */
proc import out=AIS               /*Data Name*/ 
	datafile="/home/u44071514/lab_xy/lab_datasets/AIS.csv"     /*Fill in with your data location*/
	dbms=CSV replace; 
run;
proc contents data=AIS;run; 

/* 1. A handy variation of proc Univariate */
proc means data=AIS maxdec=2 mean std lclm uclm;
	class sex;
	var rbc;
run;

/* 2. Interpreting the betas of regression on categorical covariates */
proc freq data=AIS;
	table sex;
RUN;   

/*Approach 1: dummy coding + proc reg ? */
data AIS1;
	set AIS;
	female=1;
	if sex="M" then female="0"; /*female = 1 for females, =0 for males */
run;

proc reg data=AIS1;    
	/*proc reg does not allow class*/ 
	model rbc=female;   
run;

/*Approach 2: PROC glm with class */
proc glm data=AIS;
	class sex;
	model rbc=sex / solution;
run;/*Which group is the reference group by default? */

proc glm data=AIS;
	class sex(ref="F");
	model rbc=sex / solution;
run;  /*How has beta1 changed? What is the interpretation now? */






/*What about for MULTIPLE categories? Revisit what we did in lab2: */

/*Import the iris data from SAS built-in library*/ 
data iris;
	set sashelp.iris;
run;
proc print data=iris(obs=20);run;
proc contents data=iris;run;

proc freq data=iris;
	table species;  		/* Three species: Setosa/Versicolor/Virginica*/
run;


/* The proc reg + dummy coding approach: */
data iris2;
	set iris;
	/*Set "Virginica" as reference group*/
	Setosa=0;							/*create dummy variable for "Setosa" and "Versicolor"*/
	Versicolor=0;
	if species = "Setosa" then Setosa=1; 
	if species = "Versicolor" then Versicolor=1; 
	keep sepallength species setosa versicolor;
run;
proc reg data=iris2;								 
	model sepallength = setosa versicolor;   	 
run;
	/*Write out the formula with dummy variables in it */
	/*What is the average pedallength for Virginica? */
	
/* The proc glm + class approach: */
proc glm data=iris;
	class species (ref="Virginica");    /*Class Statement: for categorical variables;*/
	model sepallength = species / solution;
run; 
	/*What is the average pedal length for Virginica? */

 
 
 
 

/*----------------------------*/
/* Multiple Linear Regression */
/*----------------------------*/
 
/*=====IMPORT DATA======*/ 

/*Import CSV File -- */
proc import out=dat0               /*Data Name*/ 
	datafile="/home/u44071514/lab_xy/lab_datasets/elemapi.csv"     /*Fill in with your data location*/
	dbms=CSV replace; 
run;
proc print data=dat0(obs=20);run;    /*Print firt 20 subjects*/
proc contents data=dat0;run;         /*Check variable format*/

/* Main Outcome (Y): api00 (Academic Performance Index at 2000) for each school*/
/* Covariates (X1): ell (english language learners)
			  (X2): meals (pct free meals)
			  (X3): yr_rnd (year round school) --> """binary category"""
			  (X4): mobility (pct 1st year in school) 
			  (X5):	acs_k3 (avg class size k-3)
			  (X6):	acs_46 (avg class size 4-6)
			  (X7):	full (pct full credential) 
			  (X8):	emer (pct emer credential)
			  (X9):	enroll (number of students)*
			  (X10): mealcat (Percentage free meals in 3 categories) --> """three category"""


/*====CHECK VARIABLES BEFORE MODEL FITTING=====*/

/*make a (simpler) copy of my working dataset*/
data dat; 
	set dat0;
	keep api00 ell meals yr_rnd mobility
		acs_k3 acs_46 full emer enroll mealcat; /*keep the variables needed for analysis*/
	label api00 = "Academic Performance Index"
		ell = 'English language learners'
		yr_rnd = 'year around school - binary'
		meals = 'percent free meals'
		mobility = 'pct 1st year in school'
		acs_k3 = 'avg class size k-3'
		acs_46 = 'avg class size 4-6'
		full = 'pct full credential'
		emer = 'pct emer credential'
		enroll = 'number of students'
		mealcat = "percent free meals - categorical"; 
		/* Optional: add labels to variables for later convenience */
		/* This doesn't change their names */
run;

proc contents data=dat;run;         /*Now the labels will appear too*/


/* Check missing data points, abnormal values, etc... */
/* categorical variales: missing?*/
proc freq data=dat;
	table yr_rnd mealcat;    /* now the labels are printed as well! */
run;
/* continuous variables: get a vague idea of the values ranges, spot abnormal values*/
proc means data=dat N mean std min max range maxdec=2;
	var api00 ell meals mobility
		acs_k3 acs_46 full emer enroll ;
run;

/* Check assumption of normality with histogram: any severe violations?*/
proc univariate data=dat normal;				    /* Check normality*/
	var api00;										/* api00*/			
	histogram api00  / normal(mu=est sigma=est);	/* Add normal density */
	qqplot api00 ;									/* Q-Q plot*/
run;


/* Check assumption of no collinearity: bivariate scatterplots between covariates*/
proc sgscatter data=dat;
	matrix  meals  acs_k3  full enroll / diagonal=(histogram kernel); 
		/*optional: put histograms on the diagonals with the options behind the slash */
run;


/* =====Multiple linear regression model====== */

/* Multiple linear regression model with four of the continuous variables*/
proc glm data=dat PLOTS=(DIAGNOSTICS RESIDUALS);
  model api00 = meals  acs_k3  full enroll / solution;
run;
	/*Which variables have significant effect on academic performance? Protective or harmful? */

/* What if I have meals as categorical  instead of continuous? */
proc glm data=dat PLOTS=(DIAGNOSTICS RESIDUALS);
	class mealcat(ref="1");  /*set first category as reference group */ 
    model api00 = mealcat  acs_k3  full enroll / solution;
run;
	/*How to interpret the difference between 1st category and 3rd category of meals? */

/* Introduction to interactions */
proc glm data=dat  ;
	class mealcat(ref="1");
    model api00 = mealcat enroll  / solution;
run;

proc glm data=dat  ;
	class mealcat(ref="1");
    model api00 = mealcat enroll mealcat*enroll / solution;
run;
	/*Does the effect of student number differ by meals category? */









