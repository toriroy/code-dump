/* Example 1: Diet from Slide 139 */

data wloss;
 do diet = 1 to 5;
  do i = 1 to 10;
   input wloss @@;
   output;
  end;
 end;
datalines;
12.4 10.7 11.9 11.0 12.4
12.3 13.0 12.5 11.2 13.1
 9.1 11.5 11.3  9.7 13.2
10.7 10.6 11.3 11.1 11.7
 8.5 11.6 10.2 10.9  9.0
 9.6  9.9 11.3 10.5 11.2
 8.7  9.3  8.2  8.3  9.0
 9.4  9.2 12.2  8.5  9.9
12.7 13.2 11.8 11.9 12.2
11.2 13.7 11.8 11.5 11.7
;

proc glm data = wloss;
 class diet;
 model wloss = diet;
 lsmeans diet / pdiff cl adjust = tukey;
run;

/* Example 2: Fertilizer from Slide 149 */

data sugarbeet;
 input treat $ yield;
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

*proc print data = sugarbeet; run;

*planned comparisons;
proc glm data = sugarbeet;
 class treat;
 model yield = treat;
 estimate 'fertilizer effect' treat 3 -1 -1 -1 / divisor = 3;
 estimate 'plowed vs. broadcast' treat 0 1 -1 0;
 estimate 'January vs. April' treat 0 0 1 -1;
 means treat / dunnettl('A');
run;

*unplanned comparisons, Option 1;
proc glm data = sugarbeet;
 class treat;
 model yield = treat;
 means treat / tukey;
run;

*unplanned comparisons, Option 2;
proc glm data = sugarbeet;
 class treat;
 model yield = treat;
 lsmeans treat / pdiff adjust = tukey;
run;

*SNK method;
proc glm data = sugarbeet;
 class treat;
 model yield = treat;
 means treat / snk;
run;

*compare all treatment levels to control;
proc glm data = sugarbeet;
 class treat;
 model yield = treat;
 means treat / dunnett('A');
 lsmeans treat / pdiff = control('A') adjust = dunnett;
run;

/* Example 3: Bread-Baking from Slide 152 */
data bread;
 input time h1-h4;
 height = h1; output;
 height = h2; output;
 height = h3; output;
 height = h4; output;
 keep time height;
datalines;
30 4.5 5.0 5.5 6.75
35 6.5 6.5 10.5 9.5
40 9.75 8.75 6.5 8.25
;

proc glm data = bread;
 class time;
 model height = time;
 contrast '35 vs. 45' time -1 0 1;
 contrast '35 vs. 40' time -1 1 0;
 estimate '-0.5 * (35 + 40) + 45' time -1 -1 2 / divisor = 2;
run;

* use orpol() in proc iml for orthogonal polynomials;
proc iml;
 t = {35 40 45};
 C = orpol(t);
 print C;
quit;

*trend tests;
proc glm data = bread;
 class time;
 model height = time;
 estimate 'linear trend' time -0.707107 0 0.707107;
 estimate 'quadratic trend' time 0.4082483 -0.816497 0.4082483;
 *OR;
 estimate 'linear trend' time -1 0 1;
 estimate 'quadratic trend' time 1 -2 1;
run;

*multiple comparisons *;
proc glm data = bread;
 class time;
 model height = time;
 means time / cldiff tukey bon scheffe lsd dunnett('35') alpha = 0.05;
run;

*however, lsmeans doesn't have the same options;
/* proc glm data = bread;
 class time;
 model height = time;
 lsmeans time / cldiff tukey bon scheffe lsd dunnett('35') alpha = 0.05;
run; */
