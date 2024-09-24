/*Methods II LAB 4-5: Multiple Linear Regression and interactions *
/*Practice sheet solutions */
/*Date: 02-14-2024*/
/*Datasets: Senic Dataset*/


****** Multiple regression with an interaction *******
****** with PROC REG and PROC GLM*********************;

proc import out= senic0 
            datafile= "/home/u44071514/lab_xy/lab_datasets/senic.csv" 
            dbms=CSV REPLACE;
     getnames=YES;
     datarow=2; 
RUN;


PROC FORMAT;      
Value regionfmt                     
			1='East'
			2='North'
			3='South'
			4='West';
Value yesnofmt
	   		1='Yes'
	   		2='No';
/*Note that in the original SENIC data, the four regions are Northeast, North Central, South, West */
/*For simplicity, Northeast-->East and NorthCentral-->North */
RUN;


data senic; 
	set senic0;
	format region regionfmt.
		   medschl yesnofmt.;     /*Apply the format*/
	label LOS="Length of stay"     /*Label the variables we need */
		INFRISK="Risk of Infection"
		MEDSCHL="Medical school";
run;
	
proc contents data=senic;run;
proc print data=senic(obs=20);run;


/* Exercise:*/
/* Outcome(Y): LOG (length of stay)*/
/* Exposue(X): (Four Regions: 1-East, 2-North, 3-South, 4-West) */

/* First Approach: PROC GLM */
proc glm data=senic;
	class region;				/*What is the baseline group for region?*/
	model los = region / solution clparm;
run;


/* Could you change refernce group to 1:East?*/
proc glm data=senic;
	class region(ref="East");          /*Reference Group*/
	model los = region / solution clparm;
run;


/* Second Approach: PROC GLM*/
/* Remember there is no class statement in PROC REG*/
/* Dummy Coding*/
data senic2;
	set senic;
	if region=1 then region_E=1;	/*Create dummy variable for region East*/
		else region_E=0;
	if region=2 then region_N=1;   /*Create dummy variable for region North*/
		else region_N=0;
	if region=3 then region_S=1;    /*Create dummy variable for region South*/
		else region_S=0;
run;
proc print data=senic2(obs=20);
	var region region_E region_N region_S; 
run;
proc reg data=senic2;
	model los = region_E region_N region_S;
run;



/*Multiple Linear Regression with interaction*/
/*------------------------------------------*/
/* Case 1: Binary by Categorical            */
/* Med-school (binary) + Region (Categorical)*/
/*------------------------------------------*/

/* Note: if medschl=2, there is no med school (No); if medschl=1, there is med school (Yes)  */
/* Without Interaction*/
proc glm data=senic;
	class medschl(ref="No") region(ref="West");
	model los = region medschl / solution;
run;

/* First Approach: PROC GLM */
proc glm data=senic;
	class medschl(ref="No") region(ref="West");
	model los = region medschl  medschl*region / solution;
run;

/* Second Approach: PROC REG + dummy coding */
data senic2;
	set senic2;  /*Base on our previous dummy variables in senic2 */
	mednew=0;
	if medschl=1 then mednew=1;
	region_E_mednew = region_E*mednew; /*Create interaction terms for all 3 dummy variables */
	region_N_mednew = region_N*mednew;
	region_S_mednew = region_S*mednew;
run;
proc print data=senic2(obs=20);
	var medschl mednew region_E region_E_mednew region_N region_N_mednew region_S region_S_mednew; 
run;

proc reg data=senic2;
	model los = region_E region_N region_S mednew region_E_mednew region_N_mednew region_S_mednew;
run;


/*-----------------------------------=----------------*/
/* Case 2-1: Binary by Continuous                     */
/* Medical School(Binary) + Infection Risk (Continous)*/
/*----------------------------------------------------*/

/* Without Interaction */
proc glm data=senic;
	class medschl(ref="No");
	model los = medschl infrisk / solution;
run;

/* First Approach: PROC GLM */
proc glm data=senic;
	class medschl(ref="No");
	model los = medschl infrisk medschl*infrisk / solution;
run;


/* Second Approach: PROC REG */
data senic2;
	set senic2;
	mednew_infrisk = mednew*infrisk;         /*Create interaction in data step*/
run;
proc print data=senic2(obs=20);
	var mednew infrisk mednew_infrisk;run;

proc reg data=senic2;
	model los = mednew infrisk mednew_infrisk;
run;


/*---------------------------------------------------*/
/* Case 2-2: Categorical by Continuous                 */
/* Region (4 categories) + Infection Risk (Continous)*/
/*---------------------------------------------------*/

/* Without Interaction */
proc glm data=senic;
	class region(ref="West");
	model los = region infrisk/ solution;
run;


/* First Approach: PROC GLM */
proc glm data=senic;
	class region(ref="West");
	model los = region infrisk infrisk*region/ solution;
run;

/* Second Approach: PROC REG */
data senic2;
	set senic2;
	region_E_infrisk = region_E*infrisk;     /*Create interaction in data step*/
	region_N_infrisk = region_N*infrisk;
	region_S_infrisk = region_S*infrisk;
run;
proc print data=senic2(obs=20);
	var region infrisk region_E region_N region_S region_E_infrisk region_N_infrisk region_S_infrisk;
run;

proc reg data=senic2;
	model los = region_E region_N region_S infrisk  region_E_infrisk region_N_infrisk region_S_infrisk;
run;



/*---------------------------------------------------*/
/* Case 3: Continous by Continuous                 */
/* nurse + Infection Risk (Continous)*/
/*---------------------------------------------------*/

proc glm data=senic;
	model los = nurse infrisk nurse*infrisk;
run;
quit;
