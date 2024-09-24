
*** Using Proc Plan to implement CRD *********;
* Three training methods with three replications each;
* the response measures can then be entered based on rep ID;
*method1;
data CRD_training /*(drop=rep)*/;
do rep= 1 to 9;
if rep lt 4 then treat=1;
else if rep lt 7 then treat=2;
else treat=3;
score='------';
rannum=ranuni(1215);
output;
end;
run;

proc sort data=crd_training;
by rannum;
run;

data crd2_training;
set crd_training;
rep=_N_;
run;

*method1;
*using Proc Plan to randomize subjects to treatment groups;
proc plan seed=1215;
factors rep=9;
output data=crd_training out=crd3_training; * this is the file created using data step above;
run;
proc sort data=crd3_training;
by rep;
run;

proc print data=crd3_training double;
var treat score;
id rep;
run;

*method3;
proc plan seed=1215;
factors treat=3 ordered rep=3 random;
output out=crd4_training; 
run;
proc sort data=crd4_training;
by treat;
run;

proc print data=crd4_training double;
var treat score;
run;

** bread rise data example;
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
proc sort data=unrand out=crd1; by u;
/* Put Experimental units back in order */
data list; set crd1;
  Loaf =_n_;
/* Print the randomized data collection form */
proc print double;  var time dough_height; id Loaf;
run;

/*  Example 2  page 17                */
/* Randomize the design with proc plan*/
proc plan seed=27371;
  factors Loaf=12;
  output data=unrand out=crd2;
run;
/* Put Experimental units back in order */
proc sort data=crd2;
  by Loaf;
/* Print the randomized data collection form */
proc print double;  var time dough_height; id Loaf;
run;

*** using PROC FACTEX;

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
