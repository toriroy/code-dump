/* Example 1  page 16                  */
/* The unrandomized design */
data unrand;
  do Loaf=1 to 12;
    if (Loaf <= 4) then time=35;
    if (5 <=Loaf <= 8) then time=40;
    if (Loaf >=9 ) then time=45;
	dough_height='_____________';
	u=ranuni(0);
    output;
  end;
run;
/* Sort by random numbers to randomize */
proc sort data=unrand out=crd; by u;
/* Put Experimental units back in order */
data list; set crd;
  Loaf =_n_;
/* Print the randomized data collection form */
proc print double;  var time dough_height; id Loaf;
run;



/*  Example 2  page 17                */
/* Randomize the design with proc plan*/
proc plan seed=27371;
  factors Loaf=12;
  output data=unrand out=crd;
run;
/* Put Experimental units back in order */
proc sort data=crd;
  by Loaf;
/* Print the randomized data collection form */
proc print double;  var time dough_height; id Loaf;
run;



/*  Example 3  page 18                            */
/* Creates CRD in random order using proc factex  */
proc factex;
  factors time/nlev=3;
  output out=crd time nvals=(35 40 45) designrep=4 randomize;
/* Add experimental unit id and space for response*/
data list; set crd;
  Loaf =_n_; dough_height='_____________';
/* Print the data Collection form                 */
proc print double;  var time dough_height; id Loaf;
run;


/* Example 4  page 22                 */
/* Reads the data from compact list   */
data bread;
  input time h1-h4;
  height=h1; output;
  height=h2; output;
  height=h3; output;
  height=h4; output;
  keep time height;
datalines;
35 4.5 5.0 5.5 6.75
40 6.5 6.5 10.5 9.5
45 9.75 8.75 6.5 8.25
run;
/* Fits model with proc glm           */
proc glm;
  class time;
  model height=time/solution;
run;


/* Example 5 page 24                              */
proc glm;
  class time;
  model height=time/solution;
  estimate '1 - 2' time 1 -1;
  estimate '1 -2 -3' time 1 -1 -1;
run;


/* Example 6  page 27                             */
ods graphics on/imagefmt=png;
ods listing style=journal2 image_dpi=300;
proc sgplot data=bread;
  scatter y=Height x=Time;
run;
ods graphics off;



/* Example 7  page 28                             */
/* Fit model and Examine Residual Plots */
ods graphics on;
proc glm data=bread  plots=diagnostics;
  class time;
  model height=time/solution;
run;
ods graphics off;


/* Example 8  page 31                              */
proc sort data=bread; by time;
proc means data=bread noprint; var height; by time;
  output out=means mean=meanht stddev=s;
data logs; set means;
  logmean=log(meanht);
  logs=log(s);
proc reg data=logs;
model logs=logmean;
run;

 
/* Example 9  page 32                               */
ods graphics on;
proc sgplot data=logs;
  reg y=logs x=logmean/curvelabel="Slope=1.29487";
  xaxis label="log mean";
  yaxis label="log standard deviation";
run;
ods graphics off;



/* Example 10  page 32                                */
data bread2;
  input time h1-h4;
  height=h1**(1-1.294869); output;
  height=h2**(1-1.294869); output;
  height=h3**(1-1.294869); output;
  height=h4**(1-1.294869); output;
  keep time height;
datalines;
35 4.5 5.0 5.5 6.75
40 6.5 6.5 10.5 9.5
45 9.75 8.75 6.5 8.25
run;
/* Fits model with proc glm           */
ods graphics on;
proc glm data=bread2 plots=diagnostics(unpack);
  class time;
  model height=time/solution;
run;
ods graphics off;



/* Example 11 page 35                       */
data bread;
input time h1-h4;
height=h1; output;
height=h2; output;
height=h3; output;
height=h4; output;
keep time height;
datalines;
35 4.5 5.0 5.5 6.75
40 6.5 6.5 10.5 9.5
45 9.75 8.75 6.5 8.25
;
/* Calculates mean and standard deviations  */
proc sort data=bread; by time;
proc means data=bread; var height; by time;
  output out=means stddev=s;
/* Creates weights                          */
data bread3; merge bread means; by time;
  w=1/s;
proc glm data=bread3;
  class time;
  model height=time;
  weight w;
run;



/*  Example 12  page 36                       */
data teaching;
  input count score$ class method;
datalines;
2	1	1	1
14	2	1	1
12	3	1	1
8	4	1	1
6	5	1	1
1	1	2	3
11	2	2	3
15	3	2	3
15	4	2	3
10	5	2	3
3	1	3	2
8	2	3	2
18	3	3	2
14	4	3	2
10	5	3	2
1	1	4	3
9	2	4	3
17	3	4	3
15	4	4	3
12	5	4	3
4	1	5	2
12	2	5	2
19	3	5	2
9	4	5	2
7	5	5	2
3	1	6	1
16	2	6	1
13	3	6	1
10	4	6	1
4	5	6	1
proc genmod;
  freq count;
  class method;
  model score = method/ dist=multinomial
					  aggregate=method
					  type1;
run;
ods graphics on;
proc sort data=teaching;
by method;
run;
proc means data=teaching sum noprint; var count;
by method;
output out=s sum=total;
run;
data comb; merge teaching s ; by method;
Percent=100*(count/total);
run;
proc sgpanel data=comb;
panelby method/rows=3;
rowaxis label="Percent";
vbar score/response=Percent;
run;
ods graphics off;



/* Example 13 page 40                                        */
*Example power computation in SAS data step using Bread Example;
data Power;
do r=2 to 6;
   nu1=3-1; * df for numerator;
   nu2=3*(r-1); * df for denomonator;
   alpha=.05;
   Fcrit=finv(1-alpha,nu1,nu2); *F critical value;
   sigma2=2.1;
   css=4.5;
   nc=r*(css)/sigma2;*noncentrality parameter for noncentral F;
   power=1-probf(Fcrit,nu1,nu2,nc);
   output;
end;
keep r nu1 nu2 nc power;
title Power Calculation in Data Step;
proc print; run;


/* Example 14 page 41                                         */
* Eample Power Calculation Using proc power;
proc power;
   OneWayANOVA
      Alpha = 0.05
      GroupMeans = (-1.5 0 1.5)
      StdDev = 1.449
      Power = .
      NPerGroup = 2 to 6 by 1;
run;




/* Example 15 page 41                                        */
*Example Power Calculation Using proc glmpower;
/* data step reads in expected cell means 
ntotal is number of replicates per treatment factor level
times the number of levels                                */
data Breadm;
  input time meanht;
datalines;
1  -1.5
2    0
3  1.5
proc glmpower;
  class time;
  model meanht=time;
  power
  stddev=1.449
  ntotal=6 to 18 by 1
  power = .;
run;



/* Example 16 page 42                                          */
data Sugarbeet;
input treat$ yield;
datalines;
A 36.9
A 40.1
A 37.707 
A 40.093
B 43.7
B 46.2
B 44
B 46.1
C 48.2
C 47.7
C 50.6
C 48.6
C 48.9
D 47.3
D 49.2
D 51.3
D 47.2
D 48.5
proc glm;
  class treat;
  model yield=treat;
  estimate 'fertilizer effect' treat 1 -.33333 -.33333 -.33333;
  estimate 'plowed vs broadcast' treat 0 1 -1 0;
  estimate 'January vs April' treat 0 0 1 -1;
run;


/* Example 16  page 42                                         */
proc iml;
  t={35 40 45};
  C=orpol(t);
  print C;
quit;



/* Example 17  page 42                                         */
/* Reads the data from compact list   */
data bread;
  input time h1-h4;
  height=h1; output;
  height=h2; output;
  height=h3; output;
  height=h4; output;
  keep time height;
datalines;
35 4.5 5.0 5.5 6.75
40 6.5 6.5 10.5 9.5
45 9.75 8.75 6.5 8.25
run;
proc glm data=bread;
  class time;
  model height=time;
  estimate 'Linear Trend' time -.707107 0 .707107;
  estimate 'Quadratic Trend' time .4082483 -.816497 .4082483;
run;



/* Example 18 page 43                                           */  
proc glm data=Sugarbeet;
  class treat;
  model yield=treat;
  means treat/tukey;
run;


/*  Example 19 page 44                                          */ 
proc glm data=Sugarbeet;
  class treat;
  model yield=treat;
  lsmeans treat/pdiff adjust=tukey;
run;



/* Example 20  page 45                                          */
proc glm data=Sugarbeet;
  class treat;
  model yield=treat;
  means treat/snk;
run;



/* Example 24  page 46                                         */
proc glm data=Sugarbeet;
  class treat;
  model yield=treat;
  means treat/dunnett('A');
  lsmeans treat/pdiff=control('A') adjust=dunnett;
run;



