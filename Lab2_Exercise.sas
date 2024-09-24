/*Methods 2 LAB: Lecture 2*/
/*Date: 01-17-2024*/
/*Original Dataset: https://cran.r-project.org/web/packages/medicaldata/medicaldata.pdf*/
/*Two Subsets Data: Demographic + COVID Info*/

/*-----------*/
/*IMPORT DATA*/
/*-----------*/

/*Import CSV File -- Merged Data*/
proc import out=dat                  /*Data Name*/ 
	datafile='XXX\mergeddata.csv'   /*Fill in XXX with your data location*/
	dbms=CSV replace; 
run;
proc print data=dat(obs=20);run;    /*Print firt 20 subjects*/
proc contents data=dat;run;         /*Check variable format*/


/*-----------------------------------------------------------*/
/* LABEL DATA*/
/*-----------*/
PROC FORMAT;
Value gender                        
			0='0 Female'
			1='1 Male'; 
Value patient_class                 /*Disposition of subject at time of collection*/
			1 = '1 Inpatient'
			2 = '2 Outpatient'
			3 = '3 Emergency';
Value result                        /*Covid PCR Test Result*/
			0='0 Negative'
			1='1 Postive'; 
Value drive_thru_ind                /*Whether the specimen was collected via a drive-thru site*/
			0='0 No'
			1='1 Yes'; 
Value payor_group
			1 = '1 Comercial'
			2 = '2 Government'
			3 = '3 Self pay';	
/* Value agebin */						/*Remember to format new variable, such as "agebin" and "agecat"*/
	
/* Value agecat */                      /*Fun Fact: You can not name a format with number in the end*/

	
run; 


/*------------------------------------------------------------*/
/* Histogram + Density Plot */
/*--------------------------*/

proc sgplot data=dat;
  title "Histogram of Age";						
  histogram age;                            		/* Histogram of age*/     
  density age;										/* Normal Density with Histogram*/
  density age / type=kernel;						/* Density plot (smooth out the distribution)*/
  keylegend / location=inside position=topright;
run;

proc means mean std data=dat;
var age pan_day;
run;

/* Another approach to make histogram*/
proc univariate data=dat normal;					/* Check normality*/
	var age;										
	histogram ;				
	title "Histogram of Age"; 						/*Change plot title*/
run;

/************************************************************************************************/
/************************************************************************************************/
/*Exercise 1: Make histogram and density plot for days from pandamic start (pan_day)*/
proc sgplot data=dat;
  title "Histogram of Days from pandamic start";						
  histogram XXX;                            		/* Fill in XXX*/     
  density XXX;										/* Normal Density with Histogram*/
  density  XXX/ type=kernel;						/* Density plot (smooth out the distribution)*/
  keylegend / location=inside position=topright;
run;

/* Another approach to make histogram*/
proc univariate data=dat normal;					/* Check normality*/
	var XXX;										/*Fill in XXX*/
	histogram ;			
	title "Histogram of Days from pandamic start"; 	/*Change plot title*/
run;
/************************************************************************************************/
/************************************************************************************************/


/*-----------------------------------------------------------*/
/* Data Manipulation */
/*-------------------*/
data dat2;                	  /*New Dataset*/
	set dat;              	  /*Original Dataset*/
	
	/*Dichotomize Age>=30 or less than 30 yrs*/
	/*FIRST APPROACH*/
	agebin=0;             	  		/*Create a NEW dichotomized age variable -- agebin*/
	if age>=20 then agebin=1;	  	/*Dichotomize age to 2 groups*/
							  		/*Remember to format dichotomized age variable*/
    /*SECOND APPROACH*/        	  		
	if age>=20 then agebin2=1;	  	/*Dichotomize age to 2 groups*/
		else agebin2=0;				/*Remember to format dichotomized age variable*/

	/*Classifided Age to Three groups: <20 yrs (agecat=0), 20-30 yrs (agecat=1), and >30 yrs (agecat=2)*/
	agecat=0;                  		/*Create a NEW age variable -- agecat*/
	if 20<=age<=30 then agecat=1;	/*age between 20-30 yrs -> agecat=1*/
	else if age>30 then agecat=2;   /*age >30 yrs -> agecat=2*/

run;
proc print data=dat2(obs=20);run;  /*Verify manipulate data correctly by printing out the first 20 subjects*/

proc freq data=dat2;						/* Check proportion of new classified age variable*/
	table agebin agecat;
	format agebin agebin. agecat agecat.;   /* Format new variables*/
run; 


/************************************************************************************************/
/************************************************************************************************/
/*Exercise 2: Classified days from pandemic start to FOUR groups*/

/*Group 1: pan_day < 50 days; Group 2: 50 <= pan_day < 70; Group 3: 70 <= pan_day < 90; Group 4: pan_day>=90*/

data dat2;
	set dat2;
	
run;
proc print data=dat2(obs=20);run;

proc freq data=dat2;								/* Check proportion of new classified pan_day4 variable*/
	table pan_day4;
run; 
/************************************************************************************************/
/************************************************************************************************/

/*-----------------------------------------------------------*/
/* Statistical Tests - comparing two groups */
/*------------------------------------------*/

/*---------------------*/
/* Continuous Variable */
/*---------------------*/
/*T-Test*/
proc ttest data=dat2;
	class result;				/*PCR test tesult: postive vs negative*/
	var age;					/*Compare mean age between two groups*/
	format result result.;
run; 

/*Wilcoxon Rank Sum Test*/
proc npar1way data=dat2 wilcoxon;
	class result;					/*PCR test tesult: postive vs negative*/
	var age;						/*Compare mean age between two groups*/
	format result result.;
run;


/*----------------------*/
/* Categorical Variable */
/*----------------------*/

/*Chi-Square Test*/
proc freq data=dat2 ;
	table agebin*result / chisq;     /*Chi-square test*/
	format agebin agebin. result result.;
run;

/*Fisher's Exact Test*/
proc freq data=dat2 ;
	table agebin*result / fisher;    /*Fisher's exact test*/
	format agebin agebin. result result.;
run;



/*Methods 2 LAB 2.5: Simple Linear Regression*/
/*Date: 01-17-2024*/
/*Two Datasets: FatherSon Data (from R) + Iris data (from SAS)*/
/*Y=beta0+beta1*X*/


/*-------------------------------------------------------------*/
/*Case 1: X(predictor) is continuous variable (Father's Height)*/
/*-------------------------------------------------------------*/
/*-------------*/
/*IMPORT DATA 1*/
/*-------------*/
/* Goal: Use father's height to predict son's height*/
/*Import CSV File -- FatherSon*/
proc import out=dat                  /*Data Name*/ 
	datafile="XXX\fatherson.csv"   /*Fill in XXX with your data location*/
	dbms=CSV replace; 
run;
proc print data=dat(obs=20);run;    /*Print firt 20 subjects*/
proc contents data=dat;run;         /*Check variable format*/

data dat;
	set dat;
	father=fheight;                /*rename father's height variable*/  
	son=sheight;				   /*rename son's height variable*/
	keep father son;
run;
proc print data=dat(obs=20);run;  


/*Check Histogrram - Normality Check*/
proc univariate data=dat normal;							/* Check normality*/
	var father son;											/* Father's and Son's  Height*/			
	histogram father son / normal(mu=est sigma=est);		/* Add normal density */
	qqplot father son;										/* Q-Q plot*/
run;

proc means data=dat N mean std min max range;
	var father son;
run;


/*Correlation plot b/t X and Y*/
proc corr data=dat plots=matrix(histogram);             /* Scatter plot b/t two variables*/
	var father son;
run;


/*------------------------*/
/*Simple Linear Regreesion*/
/*------------------------*/

/* First Approach - PROC REG */
proc reg data=dat;					/*Y = beta0+beta1*X  */
	model YYY = XXX;				/*Please fill in YYYY and XXX to son and father*/
run;

/* Second Approach - PROC GLM */
proc glm data=dat;					/*Y = beta0+beta1*X */
	model YYY = XXX; 			/*Please fill in YYY and XXX to son and father*/
run;
	 


/*--------------------------------*/
/* Check normality of error terms */
/*--------------------------------*/
proc reg data=dat;					/*Y = beta0+beta1*X  */
	model son = father;				
	output out=out1 r=res p=pred;	/*out=[residual dataset] r=residual*/
run;
proc print data=out1(obs=20);run;

proc univariate data=out1 normal;         /*use resids output from "PROC REG"*/
	var res;
	qqplot res / normal (mu=est sigma=est);
	run;
*Residuals are normally distributed.  Shapiro-Wilk p-value is 0.7444;


proc glm data=dat;						/*Y = beta0+beta1*X */
	model YYY = XXX; 				/*Please fill in Y and X*/
	output out=out2 r=res p=pred;				/*out=[residual dataset] r=residual*/
run;
proc print data=out2(obs=20);run;

proc univariate data=out2 normal;         /*use resids output from "PROC GLM"*/
	var res;
	qqplot res / normal (mu=est sigma=est);
	run;
*Residuals are normally distributed.  Shapiro-Wilk p-value is 0.7444;



/*-----------------------------------------------------------*/
/*Case 2: X(predictor) is categorical variable (Iris Species)*/
/*-----------------------------------------------------------*/
/*-------------*/
/*IMPORT DATA 2*/
/*-------------*/

data iris;
	set sashelp.iris;
run;
proc print data=iris(obs=20);run;
proc contents data=iris;run;

/* Goal: Construct a linear regression for sepal length*/
/*Import File from SAS -- Iris Dataset*/
proc freq data=iris;
	table species;  		/* Three species: Setosa/Versicolor/Virginica*/
run;



/*Step 1: Create a dummy variable*/
data iris2;
	set iris;
	/*Set "Virginica" as reference group*/
	Setosa=0;											/*create dummy variable for "Setosa" and "Versicolor"*/
	Versicolor=0;
	if species = "Setosa" then Setosa=1; 
	if species = "Versicolor" then Versicolor=1; 
	keep sepallength species setosa versicolor;
run;
proc print data=iris2;run;

/*Step 2: Check Histogrram - Normality Check*/
proc univariate data=iris2 normal;							/* Check normality*/
	var sepallength;										/* Check Sepal Length*/			
	histogram sepallength / normal(mu=est sigma=est);		/* Add normal density */
	qqplot sepallength;										/* Q-Q plot*/
run;

proc means data=iris2 N mean std min max range;
	var sepallength;
run;
		

/*Step 3: Construct linear regression*/
/*First Approach - PROC REG */
proc reg data=iris2;								/*No class statement in PROC REG*/
	model sepallength = setosa versicolor;   		/*Use dummy coding in "ROC REG"*/
	output out=out1 r=res;							/*Export residual data*/
run;


/*Second Approach - PROC GLM */
proc glm data=iris2 plot=diagnostic;
	class species (ref="Virginica");                /*Class Statement: for categorical variables*/
	model sepallength = species / solution;
	output out=out2 r=res;							/*Export residual data*/
run;

/*Step 4: Check normality of error terms*/
proc univariate data=out1 normal;         /*use resids output from "PROC REG"*/
	var res;
	qqplot res / normal (mu=est sigma=est);
	run;
*Residuals are normally distributed.  Shapiro-Wilk p-value is 0.2189;


/*Residuals from PROC GLM*/
proc univariate data=out2 normal;         /*use resids output from "PROC GLM"*/
	var res;
	qqplot res / normal (mu=est sigma=est);
run;
*Residuals are normally distributed.  Shapiro-Wilk p-value is 0.2189;











