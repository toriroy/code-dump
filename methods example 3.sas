/* Example 1: Mice Litters from Slide 13 */

data abp;
 input litter treat y;
datalines;
1 1 5.4
1 2 6.0
1 3 5.1
2 1 4.0
2 2 4.8
2 3 3.9
3 1 7.0
3 2 6.9
3 3 6.5
4 1 5.8
4 2 6.4
4 3 5.6
5 1 3.5
5 2 5.5
5 3 3.9
6 1 7.6
6 2 9.0
6 3 7.0
7 1 5.5
7 2 6.8
7 3 5.4
;
run;

*graphical check of additivity assumption: are lines parallel?;
symbol1 v = circle i = join;
symbol2 v = square i = join;
symbol3 v = triangle i = join;
proc gplot data = abp;
 plot y * treat = litter;
run;

*wrong analysis -- one-way ANOVA ignoring blocking;
*Slide 13;
proc glm data = abp plots = diagnostics;
 class treat;
 model y = treat;
 means treat; 
 lsmeans treat / adjust = tukey;
 output out = diagnostics r = res p = pred;
run;

*correct analysis -- two-way ANOVA with blocking;
*Slide 23;
proc glm data = abp plots = diagnostics;
 class litter treat;
 model y = treat litter;
 means treat; 
 lsmeans treat / adjust = tukey;
 output out = diagnostics r = res p = pred;
run;

*check normality of residulas;
proc univariate data = diagnostics noprint;
 qqplot res / normal (L = 1 mu = 0 sigma = est);
 histogram res /normal (L = 1 mu = 0 sigma = est) kernel(L = 2 K = quadratic);
run;

* checking constant variance using proc glm each factor at a time;
proc glm data = abp;
 class treat litter;
 model y = treat;
 means treat / hovtest;
run;

* are block effects additive? Tukey non-additivity test;
proc means data = abp mean std n; *get mean of y for Step 2;
 var y;
run;

proc glm data = abp;
 class litter treat;
 model y = treat litter; *Step 1;
 output out = resid1 r = res1 p = pred1; *Step 2;
run;

data resid1;
 set resid1;
 pred1sq = pred1*pred1/(2*5.79); *5.79 is mean from proc means;
run;

* test of lambda = 0 is the pvalue corresponding to pred1sq;
proc glm data = resid1;
 class treat litter;
 model y = treat litter pred1sq / solution;
 output out = resid2 r = res2 p = pred2; *Steps 3-5;
run;

/* Example 2: Lever Press from Slide 38 */

data drug;
 input rat r1-r5;
 dose = 0.0; rate = r1; output; dose = 0.5; rate = r2; output;
 dose = 1.0; rate = r3; output; dose = 1.5; rate = r4; output;
 dose = 2.0; rate = r5; output;
 keep rat dose rate;
datalines;
 1 0.60 0.80 0.82 0.81 0.50
 2 0.51 0.61 0.79 0.78 0.77
 3 0.62 0.82 0.83 0.80 0.52
 4 0.60 0.95 0.91 0.95 0.70
 5 0.92 0.82 1.04 1.13 1.03
 6 0.63 0.93 1.02 0.96 0.63
 7 0.84 0.74 0.98 0.98 1.00
 8 0.96 1.24 1.27 1.20 1.06
 9 1.01 1.23 1.30 1.25 1.24
10 0.95 1.20 1.18 1.23 1.05
;
run;

proc glm data = drug;
 class rat dose;
 model rate = rat dose;
 output out = s p = prate r = rrate;
run;

proc sort data = drug;
 by dose;
run;

proc means data = drug noprint;
 by dose;
 var rate;
 output out = means mean = meanrate;
run;

proc sgplot data = means noautolegend;
 scatter x = dose y = meanrate;
 reg x = dose y = meanrate / degree = 2;
 xaxis label = "Dose";
 yaxis label = "Average Lever Press Rate";
run;

*calculate number of blocks needed for 80% power w/ data step;
data powerRCB;
 do b = 2 to 5;
  t = 5;
  nu1 = t - 1;
  nu2 = (b - 1) * (t - 1);
  alpha = 0.05;
  sigma2 = 0.0083487;
  css = 0.0460208;
  Fcrit = finv(1 - alpha, nu1, nu2);
  nc = b * css / sigma2;
  power = 1 - probf(Fcrit, nu1, nu2, nc);
  output;
  keep b nu2 nc power;
 end;
run;

proc print data = powerRCB; run;

/* Example 3: Detergent from Slide 46 */

data wash;
 input stain soap y @@;
cards;
1 1 45 1 2 47 1 3 48 1 4 42
2 1 43 2 2 46 2 3 50 2 4 37
3 1 51 3 2 52 3 3 55 3 4 49
;
run;

proc glm data = wash plots = diagnostics;
 class stain soap;
 model y = soap;
 means soap / hovtest;
run;

* are block effects additive? Tukey non-additivity test;
proc means data = wash mean std n; *get mean of y for Step 2;
 var y;
run;

proc glm data = wash;
 class stain soap;
 model y = stain soap; *Step 1;
 output out = resid1 r = res1 p = pred1; *Step 2;
run;

data resid1;
 set resid1;
 pred1sq = pred1*pred1/(2*47.08); *47.08 is mean from proc univariate;
run;

* test of lambda = 0 is the pvalue corresponding to pred1sq;
proc glm data = resid1;
 class stain soap;
 model y = stain soap pred1sq / solution;
 output out = resid2 r = res2 p = pred2; *Steps 3-5;
run;

* graphical check of additivity assumption: are lines parallel?;
symbol1 v = circle i = join;
symbol2 v = square i = join;
symbol3 v = triangle i = join;
proc gplot data = wash;
 plot y*stain = soap;
run;

/* Example 4: Golf Tee Height from Slide 63 */

data rcb;
 input id teehgt cdistance;
datalines;
1       1        142.0
1       1        141.8
1       1        153.7
1       1        130.6
1       1        147.8
1       2        142.7
1       2        136.2
1       2        140.2
1       2        143.3
1       2        145.8
1       3        137.8
1       3        159.0
1       3        151.1
1       3        154.1
1       3        135.0
2       1        169.5
2       1        177.0
2       1        169.1
2       1        176.5
2       1        173.8
2       2        185.6
2       2        164.8
2       2        173.9
2       2        191.9
2       2        164.5
2       3        184.7
2       3        183.0
2       3        195.9
2       3        194.4
2       3        182.2
3       1        142.7
3       1        136.2
3       1        140.2
3       1        143.3
3       1        145.8
3       2        137.8
3       2        159.0
3       2        151.1
3       2        154.1
3       2        135.0
3       3        142.0
3       3        141.8
3       3        153.7
3       3        130.6
3       3        147.8
4       1        185.4
4       1        164.8
4       1        173.9
4       1        191.9
4       1        164.5
4       2        184.7
4       2        172.8
4       2        175.8
4       2        184.7
4       2        172.2
4       3        176.0
4       3        177.0
4       3        175.3
4       3        176.5
4       3        173.8
5       1        222.2
5       1        201.9
5       1        192.5
5       1        182.0
5       1        224.8
5       2        197.7
5       2        229.8
5       2        203.3
5       2        214.3
5       2        220.9
5       3        221.8
5       3        240.0
5       3        221.4
5       3        234.9
5       3        213.2
6       1        133.6
6       1        132.6
6       1        135.0
6       1        147.6
6       1        136.7
6       2        145.5
6       2        154.5
6       2        150.5
6       2        137.9
6       2        154.4
6       3        145.9
6       3        146.0
6       3        149.2
6       3        145.2
6       3        147.2
7       1        165.2
7       1        173.2
7       1        174.2
7       1        176.9
7       1        166.4
7       2        178.8
7       2        163.4
7       2        160.2
7       2        160.6
7       2        169.3
7       3        172.8
7       3        183.2
7       3        170.2
7       3        169.6
7       3        169.9
8       1        174.3
8       1        160.1
8       1        162.8
8       1        174.6
8       1        172.6
8       2        184.4
8       2        181.8
8       2        185.0
8       2        192.4
8       2        193.3
8       3        180.6
8       3        172.5
8       3        181.2
8       3        178.4
8       3        167.6
9       1        229.7
9       1        220.7
9       1        240.4
9       1        219.5
9       1        225.6
9       2        241.6
9       2        242.1
9       2        243.4
9       2        240.8
9       2        240.7
9       3        243.3
9       3        242.1
9       3        236.1
9       3        248.3
9       3        240.4
;
run;

proc glm data = rcb;
 class id teehgt;
 model cdistance = id teehgt id*teehgt;
 test h = teehgt e = id*teehgt;
 lsmeans teehgt / pdiff adjust = tukey e = id*teehgt;
run;

/* Self Study: BIBD and Flowers*/

/* Example 5: Leprosy from Slide 97 */

data drugtest; 
 input drug $ pretrt posttrt @@; 
datalines; 
A 11  6   A  8  0   A  5  2   A 14  8   A 19 11 
A  6  4   A 10 13   A  6  1   A 11  8   A  3  0 
D  6  0   D  6  2   D  7  3   D  8  1   D 18 18 
D  8  4   D 19 14   D  8  9   D  5  1   D 15  9 
F 16 13   F 13 10   F 11 18   F  9  5   F 21 23 
F 16 12   F 12  5   F 12 16   F  7  1   F 12 20 
;
 
data drugtest;
 set drugtest;
 change = posttrt - pretrt;
run;

proc gplot data = drugtest;
 symbol1 c = blue v = star i = r;
 symbol2 c = red v = plus i = r;
 symbol3 c = green v = star i = r;
 axis1 label = (r = 0 a = 90);
 plot posttrt*pretrt = drug / regeqn vaxis = axis1;
run;

*ANCOVA;
proc glm data = drugtest plots = diagnostics; 
 class drug; 
 model posttrt = drug pretrt / solution; *assumes equal slopes model;
 lsmeans drug / stderr pdiff cl cov out = adjmeans;
run;
  
*ANCOVA parametrization 1: y_ij = mu + tau_i + beta*X_ij + rho_i*X_ij + e_ij;
proc glm data = drugtest plots = diagnostics;
 class drug;
 *if interaction is not significant then equal slope;
 model posttrt = drug pretrt drug*pretrt / solution;
 output out = check2 r = residuals p = predicted;
run;

*ANCOVA parametrization 2: yij = tau_i + beta_i*X_ij + e_ij;
proc glm data = drugtest plots = diagnostics;
 class drug;
 *fits separate intercepts and slopes for each drug;
 model posttrt = drug drug*pretrt / noint solution;
 *tests if slopes for all drugs are equal;
 contrast 'all slopes equal' drug*pretrt 1 -1 0,
							 drug*pretrt 1 0 -1;
run;

*vs. ANOVA;
proc glm data = drugtest;
 class drug;
 model posttrt = drug / solution;
run;

/* Self Study: SBP from Slide 111 */
