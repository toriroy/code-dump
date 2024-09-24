/*Methods 4 LAB: Lecture 4: Linear Regression */
/*Date: 02-08-2023*/
/*Datasets: Elementary 
/*https://stats.oarc.ucla.edu/sas/webbooks/reg/chapter1/regressionwith-saschapter-1-simple-and-multiple-regression/ */


/*-------------*/
/*IMPORT DATA  */
/*-------------*/
/* Goal: */
/*Import CSV File -- */
proc import out=dat                  /*Data Name*/ 
	datafile="C:\Users\chech\OneDrive - Medical University of South Carolina\MUSC courses\2023 Spring\Method 2 TA\data\elemapi.csv"   /*Fill in XXX with your data location*/
	dbms=CSV replace; 
run;
proc print data=dat(obs=20);run;    /*Print firt 20 subjects*/
proc contents data=dat;run;         /*Check variable format*/


/*-----------------------------------*/
/*Exercise: Simple Linear Regression */
/*-----------------------------------*/

/* Main Outcome: api00 (Academic Performance Index at 2000) for each school*/
/* Main Exposure: enroll (Number of enrollment)*/

/*Check Histogrram - Normality Check*/
proc univariate data=dat normal;							/* Check normality*/
	var api00 enroll;										/* api00 and enroll*/			
	histogram api00 enroll / normal(mu=est sigma=est);		/* Add normal density */
	qqplot api00 enroll ;									/* Q-Q plot*/
run;

proc means data=dat N mean std min max range maxdec=2;
	var api00 enroll;
run;


/*Correlation plot b/t X and Y*/
proc corr data=dat plots=matrix(histogram);             /* Scatter plot b/t two variables*/
	var api00 enroll;
run;


/*Simple Linear Regression*/
proc glm data=dat plots(unpack)=(diagnostics residuals);  /*put (unpack) command to make diagnostics figure bigger*/
	model api00 = enroll /clparm;								  /*Fill in Y=X*/
run;

/*----------------------*/
/* Data Transformation  */
/*----------------------*/

/* Variable Transformation on Y*/
proc transreg data=dat;												/*Box-Cox Transformation*/
	model BoxCox(api00 / lambda=-2 to 2 by 0.1)=identity(enroll);   /*(lambda=-2 to 2 by 0.1)-> search lambda range */
run;
/*Select lamda=0.3 -> choose lamda=0 (log transformation)*/

data dat2;
	set dat;
	logapi00 = log(api00);           /* Log transformation */
	sqapi00 = api00**0.5;    
	sqapi002 = sqrt(api00);	
	      /* Just want to show data after log-transformation*/
run;
proc print data=dat2(obs=20);run;

proc univariate data=dat2 normal;							/* Check normality*/
	var api00 logapi00;										/* api00 and enroll*/			
	histogram api00 logapi00 / normal(mu=est sigma=est);		/* Add normal density */
	qqplot api00 logapi00 ;									/* Q-Q plot*/
run;


/*Re-fit simple linear regression*/
proc glm data=dat2  plots=diagnostics;
	model logapi00 = enroll /solution ;    /*Use log-transformed Y*/
run;
	


/*----------------------------*/
/* Multiple Linear Regression */
/*----------------------------*/

/* Main Outcome (Y): api00 (Academic Performance Index at 2000) for each school*/
/* Covariates (X1): meals (pct free meals)
			  (X2):	acs_k3 (avg class size k-3)
			  (X3):	full (pct full credential)
			  (X4): enroll (school size)*/


/* Please check each variable carefully before fitting model*/

/* Any Collinearity relationship*/
proc sgscatter data=dat;
	matrix meals  acs_k3  full enroll;
run;

proc glm data=dat PLOTS=(DIAGNOSTICS RESIDUALS);
  model api00 = meals  acs_k3  full enroll;
run;


/*--------------------------------------*/
/* Exercise: Multiple Linear Regression */
/*--------------------------------------*/

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

/* Any Collinearity relationship*/
proc sgscatter data=dat;
	matrix ell meals yr_rnd mobility acs_k3 acs_46 full emer enroll mealcat;
run;

/* Please check each variable carefully before fitting model*/
proc glm data=dat PLOTS=(DIAGNOSTICS RESIDUALS);
  class yr_rnd mealcat;
  model api00 = ell meals yr_rnd mobility acs_k3 acs_46 full emer enroll mealcat /solution;
run;

