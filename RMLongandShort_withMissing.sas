
* Example to demonstrate effect of missing data;
* Suppose 24 subjects are randomly assigned to two groups (Control and Treatment) and their responses are measured at 4 times. 
  These times are labeled as 0 (baseline), 1 (after one month posttest) 3 (after 3 months of follow-up) and 6 (after 6 months of follow-up). ;
data short;
input Group Subj y0 y1 y3 y6;
datalines;
1 1 296 175 187 242
1 2 376 329 236 126
1 3 309 238 150 173
1 4 222 60 82 135
1 5 150 271 250 266
1 6 316 291 238 194
1 7 321 364 270 358
1 8 447 402 294 266
1 9 220 70 95 137
1 10 375 335 334 129
1 11 310 300 253 190
1 12 310 245 200 170
2 13 282 186 225 134
2 14 317 31 85 120
2 15 362 104 144 114
2 16 338 132 91 77
2 17 263 94 141 142
2 18 138 38 16 95
2 19 329 62 62 6
2 20 292 139 104 184
2 21 275 94 135 137
2 22 150 48 20 85
2 23 319 68 67 12
2 24 300 138 114 12
;

** Introducing missing data ***;
*MCAR;
data short2;
set short;
if ranuni(4321) lt 0.3 then m2=1; else m2=0; * 20%;
if ranuni(1234) lt 0.3 then m3=1; else m3=0; * 30%;
if ranuni(4321) lt 0.3 then m5=1; else m5=0; * 50%;
if m2 eq 1 then my6=.; else my6=y6;
if m2 eq 1 then imy6=146; else imy6=y6;
run;

proc means data=short2;
var m2 m3 m5 y6; * mean of y6 is 146;
run;

*MAR;
data short3;
set short;
p=exp(-4+2*group)/(1+exp(-4+2*group));
if ranuni(4321) lt p then m2=1; else m2=0; * 20%;
if ranuni(1234) lt p then m3=1; else m3=0; * 30%;
if ranuni(4321) lt p then m5=1; else m5=0; * 40%;
if m2 eq 1 then my6=.; else my6=y6;
if m2 eq 1 then imy6=146; else imy6=y6;
run;
proc means data=short3;
var m2 m3 m5;
run;
*MNAR;
data short4;
set short;
p=exp(-20 +0.2*y6)/(1+exp(-20 +0.2*y6));
if ranuni(4321) gt p then m2=1; else m2=0; * 25%;
if ranuni(1234) gt p then m3=1; else m3=0; * 21%;
if ranuni(4321) gt p then m5=1; else m5=0; * 21%;
if m2 eq 1 then my6=.; else my6=y6;
if m2 eq 1 then imy6=146; else imy6=y6;
run;
proc means data=short4;
var m2 m3 m5;
run;
/*******************************************************************
CCA
*******************************************************************/
proc GLM  data=short;
class group;
model y6 = group/ ss3;
run;

proc GLM  data=short2;
class group;
model my6 = group/ ss3;
run;
proc GLM  data=short3;
class group;
model my6 = group/ ss3;
run;
proc GLM  data=short4;
class group;
model my6 = group/ ss3;
run;

/*******************************************************************
Mean Imputation;
*******************************************************************/
proc GLM  data=short2;
class group;
model imy6 = group/ ss3;
run;
proc GLM  data=short3;
class group;
model imy6 = group/ ss3;
run;
proc GLM  data=short4;
class group;
model imy6 = group/ ss3;
run;

/*******************************************************************
Missing Data in RM ANOVA and MANOVA;
*******************************************************************/
proc GLM  data=short4;
class group;
model y0 y1 y3 my6 = group/ nouni ss3;
repeated time 4 (0 1 3 6) polynomial /summary printm printe;*generates orthogonal polynomial contrasts. 
Level values, if provided, are used as spacings in the construction of the polynomials, otherwise, equal spacing is assumed;
run;

/*******************************************************************
Missing Data in Longitudinal Analysis;
*******************************************************************/
* Create long form of data ***;
data long; 
set short;
array yy(4) y0 y1 y3 y6;
do j = 1 to 4;
y = yy(j);
if j=1 then time=0; else if j=2 then time=1; else if j=3 then time=3; else time=6;
output;
end;
drop j y0 y1 y3 y6;
run;

*MAR;
data long3; 
set short3;
array yy(4) y0 y1 y3 my6;
do j = 1 to 4;
y = yy(j);
if j=1 then time=0; else if j=2 then time=1; else if j=3 then time=3; else time=6;
output;
end;
drop j y0 y1 y3 my6;
run;
*MNAR;
data long4; 
set short4;
array yy(4) y0 y1 y3 my6;
do j = 1 to 4;
y = yy(j);
if j=1 then time=0; else if j=2 then time=1; else if j=3 then time=3; else time=6;
output;
end;
drop j y0 y1 y3 my6;
run;


/* This is the main Proc Mixed procedure. */
* Covariance pattern Models;
* UN;

Proc Mixed data = Long;
class group subj time;
model y = group time group*time;
repeated time/subject = subj type = UN rcorr;
run;
*MAR;
Proc Mixed data = Long3;
class group subj time;
model y = group time group*time;
repeated time/subject = subj type = UN rcorr;
run;
*MNAR;
Proc Mixed data = Long4;
class group subj time;
model y = group time group*time;
repeated time/subject = subj type = UN rcorr;
run;



