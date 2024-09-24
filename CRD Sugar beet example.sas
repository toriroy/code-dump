
* Worked out example: SUgar Beet Data from text Book;
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
;
ods graphics on;
proc glm;
  class treat;
  model yield=treat;
  estimate 'fertilizer effect' treat 1 -.33333 -.33333 -.33333;
  estimate 'plowed vs broadcast' treat 0 1 -1 0;
  estimate 'January vs April' treat 0 0 1 -1;
  means treat/hovtest;
run;
ods graphics off;

/* Example 16  page 42                                         */
proc iml;
  t={35 40 45};
  C=orpol(t);
  print C;
quit;

/* Example 18 page 43                                           */  
proc glm data=Sugarbeet;
  class treat;
  model yield=treat;
  means treat/cldiff tukey;
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


