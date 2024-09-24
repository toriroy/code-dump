
*** Text book examples ***;
* the experiment consist of burning fuel and determining the amount of CO emissions released (y) 
factr A is amount of ethanol use as portion of fuel -3 levels (0.1,0.2,0.3)
factor B is the fuel/air ratio used during the burn of the fuel - three levels 14,15,16;
/* Example 5 page 63                              */
Data CO;
input Ethanol Ratio CO;
datalines;
.1 14 66
.1 14 62
.1 15 72
.1 15 67
.1 16 68
.1 16 66
.2 14 78
.2 14 81
.2 15 80
.2 15 81
.2 16 66
.2 16 69
.3 14 90
.3 14 94
.3 15 75
.3 15 78
.3 16 60
.3 16 58
;
run;
ods graphics on;
proc glm;
  class Ethanol Ratio;
  model CO=Ethanol Ratio Ethanol*Ratio/solution;
  means Ethanol Ratio Ethanol*Ratio;
  estimate '0.3 vs 0.1' Ethanol -1 0 1;
  estimate '16 vs 14' Ratio -1 0 1;
run;
ods graphics off;

/* Example 6  page 66                             */
ods graphics on;
proc glm data=CO;
  class   Ratio Ethanol ;
  model CO= Ratio Ethanol  Ratio*Ethanol;
run;
ods graphics off;


/* Example 10 page 74                              */
Data CO;
input Eth Ratio CO;
datalines;
.1 14 66
.1 14 62
.1 15 72
.1 15 67
.1 16 68
.1 16 66
.2 14 78
.2 14 81
.2 15 80
.2 15 81
.2 16 66
.2 16 69
.3 14 90
.3 14 94
.3 15 75
.3 15 78
.3 16 60
proc glm data=CO;
  class Eth Ratio;
  model CO=Eth Ratio Eth*Ratio;
  means Eth Ratio;
title Results of means statement; run;
proc glm data=CO;
  class Eth Ratio;
  model CO=Eth Ratio Eth*Ratio;
  lsmeans Eth Ratio;
title Results of lsmeans statement;
run;


/* Example 11 pages 75-77                          */
Data CO;
input Ethanol Ratio CO;
datalines;
.1 14 66
.1 14 62
.1 15 72
.1 15 67
.1 16 68
.1 16 66
.2 14 78
.2 14 81
.2 15 80
.2 15 81
.2 16 66
.2 16 69
.3 14 90
.3 14 94
.3 15 75
.3 15 78
.3 16 60
.3 16 58
proc sort data=CO; by Ethanol Ratio;
proc means noprint; 
  by Ethanol Ratio; var CO;
  output out=cells mean=COmean;
  run;
proc glm data=cells;
  class Ethanol Ratio;
  model COmean=Ethanol Ratio Ethanol*Ratio;
  contrast 'Linear x Linear' Ethanol*Ratio .500000309  0  -.500000309
                                           0           0      0
                                          -.500000309  0   .500000309;
title ;
run;



/* Example 12  page 77                           */
ods graphics on;
proc glm data=cells; 
  class Ethanol Ratio;
  model COmean=Ethanol Ratio Ethanol*Ratio;
run;
proc sgplot data=cells;
  scatter x=Ratio y=COmean/group=Ethanol;
  reg x=Ratio y=COmean/group=Ethanol;
  yaxis label="CO emmissions";
run;
ods graphics off;






