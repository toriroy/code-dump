﻿/* Example 1: Hormone Data from Slide 4 */

data glycogen;
 input trt $ resp1 resp2 resp3 resp4 resp5 resp6 @;
 resp = resp1; output; 
 resp = resp2; output; 
 resp = resp3; output; 
 resp = resp4; output; 
 resp = resp5; output; 
 resp = resp6; output; 
 keep trt resp ;
datalines;
A 106 101 120 86 132 97
a 51 98 85 50 111 72
B 103 84 100 83 110 91
b 50 66 61 72 85 60
;
run;
/*interaction p value and the difference between t test and ANOVA*/
data new;
 set glycogen;
 *transform data into two factors;
 if trt = "a" then horm = 1; if trt = "a" then level = 1;
 if trt = "A" then horm = 1; if trt = "A" then level = 2;
 if trt = "b" then horm = 2; if trt = "b" then level = 1;
 if trt = "B" then horm = 2; if trt = "B" then level = 2;
run;

*break down one-way ANOVA by contrasts;
proc glm data = new;
 class trt;
 model resp = trt;
 contrast 'hormone' trt 1 -1 1 -1;     *low level vs high level;
 contrast 'level' trt 1 1 -1 -1;	   *hormone A vs B;
 contrast 'interaction' trt 1 -1 -1 1; *equivalence of level effect;
run;
/*proc glm data = bread;
class time;
model height = time;
contrast '35 vs. 45' time -1 0 1;
contrast '35 vs. 40' time -1 1 0;
estimate '-0.5 * (35 + 40) + 45' time -1 -1 2 / divisor = 2;
run;

We wish to test if the mean height at time 35 is different than the mean height at time 45, i.e., 
 
H_0: mu_{time = 45} - mu_{time = 35} = 0,
 
or, to be really pedantic,
 
H_0: [1 * mu_{time = 45}] + [0 * mu_{time = 40} ]+ [-1 * mu_{time = 35}] = 0.*/
/**/

*t-test on each factor;
proc glm data = new;
 class level;
 model resp = level;
run;

proc glm data = new;
 class horm;
 model resp = horm;
run;

*two-way ANOVA with interaction;
proc glm data = new plots = diagnostics;
 class horm level;
 model resp = horm level level*horm / solution clparm;
 lsmeans horm level horm*level / adjust = tukey pdiff;
 *to study simple effects of level at each level of hormone and viceversa;
 *lsmeans level*horm / slice=(horm level) adjust=tukey pdiff;
 output out = new1 r = res p = pred;
run;

proc glm data = new plots = diagnostics;
 class horm level;
 model resp = horm|level / solution clparm;
 lsmeans level|horm / adjust = tukey pdiff;
 *to study simple effects of level at each level of hormone and viceversa;
 *lsmeans level*horm / slice=(horm level) adjust=tukey pdiff;
 output out = new1 r = res p = pred;
run;

/* Example 2: CO Data from Slide 66 */

data CO;
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

proc glm data = CO;
 class Ethanol Ratio;
 model CO = Ethanol Ratio Ethanol*Ratio / solution;
 means Ethanol Ratio Ethanol*Ratio;
 estimate '0.3 vs 0.1' Ethanol -1 0 1;
 estimate '16 vs 14' Ratio -1 0 1;
run;

proc glm data = CO;
 class Ratio Ethanol;
 model CO = Ratio Ethanol Ratio*Ethanol;
run;

data CO;
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
;
run;

proc glm data = CO;
 class Eth Ratio;
 model CO=Eth Ratio Eth*Ratio;
 means Eth Ratio;
 title "Results of means statement";
run;

proc glm data = CO;
 class Eth Ratio;
 model CO = Eth Ratio Eth*Ratio;
 lsmeans Eth Ratio;
 title "Results of lsmeans statement";
run;

/* Example 3: BHA Data from Slide 78 */

data bha;
 input strain $ bha $ block erod;
datalines;
A/J     Yes 1 18.7
A/J     No  1 7.7
A/J     Yes 2 16.7
A/J     No  2 6.4
129/Ola Yes 1 17.9
129/Ola No  1 8.4
129/Ola Yes 2 14.4
129/Ola No  2 6.7
NIH     Yes 1 19.2
NIH     No  1 9.8
NIH     Yes 2 12.0
NIH     No  2 8.1
BALB/c  Yes 1 26.3
BALB/c  No  1 9.7
BALB/c  Yes 2 19.8
BALB/c  No  2 6.0
;
run;

proc glm data = bha;
 class strain bha block;
 model erod = block bha strain bha*strain;
run;

proc sort data = bha; 
 by strain bha;
run;

proc means data = bha;
 var erod; 
 by strain bha;
 output out = means mean = mn;
run;

symbol1 v = circle i = join;
proc gplot data = means;
 plot mn*bha = strain;
run;

/* Self Study: Rat Data from Slide 87 */

/* Example 4: Service Data from Slide 100 */

data service; 
 input time tech make;
datalines;
62.0 1 1
48.0 1 1
63.0 1 1
57.0 1 1
69.0 1 1
57.0 1 2
45.0 1 2
39.0 1 2
54.0 1 2
44.0 1 2
59.0 1 3
53.0 1 3
67.0 1 3
66.0 1 3
47.0 1 3
51.0 2 1
57.0 2 1
45.0 2 1
50.0 2 1
39.0 2 1
61.0 2 2
58.0 2 2
70.0 2 2
66.0 2 2
51.0 2 2
55.0 2 3
58.0 2 3
50.0 2 3
69.0 2 3
49.0 2 3
59.0 3 1
65.0 3 1
55.0 3 1
52.0 3 1
70.0 3 1
58.0 3 2
63.0 3 2
70.0 3 2
53.0 3 2
60.0 3 2
47.0 3 3
56.0 3 3
51.0 3 3
44.0 3 3
50.0 3 3
;

proc glm data = service;
 class make tech;
 model time = make tech make*tech;
 random tech make*tech / test;
run;
/*question of interest, the last table, the interaction, is the table you want to interpret.
If you remove the random statement, it will produce just the top table and is incorrect

Q - sum the alpha i squares  */
