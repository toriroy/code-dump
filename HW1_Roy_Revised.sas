
proc import datafile = 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\patientbyphys.csv'
out=phys
dbms=csv;
run; /*I just copy pasted the table from the homework into a csv 
and made a few adjustments for sas to read it*/
proc print data = phys;
run;
******* BoxPlot of the distribution of LOS************;
proc sgplot data=phys;
  title "Box plot of Physician Data";
  vbox LOS / category=physician;
run;
proc glm data=phys;
  class physician;
  model LOS = physician;
  means physician / tukey hovtest;
run;


proc sort data=phys out=phys_sorted;
by physician;
run;
proc print data=phys_sorted;
run;
proc univariate data=phys_sorted normal;
qqplot los /normal(mu=est sigma=est);
by physician;
run;
proc univariate data=phys_sorted;
by physician;
histogram los;
run;

proc glm data=phys;
  class physician;
  model LOS = physician;
  means physician / cldiff tukey alpha=0.05;
run;

proc glm data=phys;
  class physician;
  model LOS = physician;
  means physician / cldiff tukey bon scheffe lsd dunnett('C') alpha=0.05;
run;

proc glm data=phys;
  class physician;
  model LOS = physician;
  means physician / clm;
run;

proc glm data=phys;
    class physician;
    model LOS = physician;
   contrast 'LOS for patients of C compared
 to the average stay of A' physician -1 0 1;
    contrast 'LOS for patients of C compared
to the average stay of B' physician 0 -1 1 ;
estimate 'C vs the Mean of (A, B)' physician -2 1 1 ;
means physician cldiff tukey bon scheffe lsd dunnett('C') alpha=0.05;
 lsmeans physician / diff;
run;


proc glm data=phys;
    class physician;
    model LOS = physician /clparm;
estimate 'C vs the Mean of (A, B)' physician 0.5 0.5 -1;
run;
