
* Example where spherecity does not hold;
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
/*******************************************************************
In the REPEATED statement, The SUMMARY option asks that PROC GLM to print tests corresponding to the contrasts.
The NOU option asks that printing of the univariate analysis of variance be suppressed
THE PRINTM option prints out the matrix corresponding to the contrasts being used . SAS calls this matrix M, and
actually prints out its transpose.
*******************************************************************/
proc GLM  data=short;
class group;
model y0 y1 y3 y6 = group/ nouni ss3;
repeated time 4 (0 1 3 6) polynomial /summary printm printe;*generates orthogonal polynomial contrasts. 
Level values, if provided, are used as spacings in the construction of the polynomials, otherwise, equal spacing is assumed;
run;

proc glm data=short;
class group;
model y0 y1 y3 y6 = group/ nouni;
repeated time 4 (0 1 3 6)  profile /summary printm nom ; *generates contrasts between adjacent levels of the factor;
run;
proc glm data=short;
class group;
model y0 y1 y3 y6 = group/ nouni;
repeated time 4 (0 1 3 6)  helmert /summary printm nom ; *HELMERT-generates contrasts between each level of the factor and 
the mean of subsequent levels. ;
run;

* Box's M test for equality of variances;
proc discrim data=short method=normal pool=test wcov;
class group ;
var y0 y1 y3 y6;
run;


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

/* The following lines plot the data */
Symbol1 I = join v = none r = 12;
Proc gplot data = long;
Plot y*time = subj/ nolegend;
By group;
Run;
* mean plot using proc glimmix;
Proc Glimmix data = Long;
class group subj time;
model y = group time group*time;
random _residual_/subject = subj type = cs;
lsmeans group*time/plot=meanplot(sliceby=group join); *requests a graphical display for the interaction LS means;
run;

** correlation;
proc corr data=short cov;
var y0 y1 y3 y6;
run;

* Matrix plot;
* set ODS graphics to landscape mode and designate output PDF file;
OPTIONS ORIENTATION=LANDSCAPE;
ODS GRAPHICS ON;
TITLE '';
        PROC SGSCATTER DATA=short;
        *MATRIX income_1990--income_1995 / DIAGONAL=(HISTOGRAM KERNEL);
		MATRIX y0--y6 ;
RUN;

/* This is the main Proc Mixed procedure. */
* Covariance pattern Models;
* UN;
Proc Mixed data = Long;
class group subj time;
model y = group time group*time;
repeated time/subject = subj type = UN rcorr;
run;
* CS;
Proc Mixed data = Long;
class group subj time;
model y = group time group*time;
repeated time/subject = subj type = cs rcorr;
run;
* AR(1);
Proc Mixed data = Long;
class group subj time;
model y = group time group*time;
repeated time/subject = subj type = AR(1) rcorr;
run;
* ARH(1);
Proc Mixed data = Long;
class group subj time;
model y = group time group*time;
repeated time/subject = subj type = ARH(1) rcorr;
run;

* polynomial effects using proc mixed equivalent to the proc glm below ;
* allows for running reduced model with only linear, linear+quadratic;
* between and within subject factors are in the model statement, but only between subject in GLM;
Proc Mixed data = Long;
class group subj;
model y = group|time|time|time/htype=1; * type I sum of squres;
repeated time/subject = subj type = UN rcorr;
*lsmeans group/pdiff; * LSMEANS here has advantages over theat of proc GLM: computes correct SE, allows for time to be continuous;
run;
* Does NOT allow for running reduced model with only linear, linear+quadratic;
proc GLM  data=short;
class group;
model y0 y1 y3 y6 = group/ nouni ss1;
repeated time 4 (0 1 3 6) polynomial /summary;*generates orthogonal polynomial contrasts. 
Level values, if provided, are used as spacings in the construction of the polynomials, otherwise, equal spacing is assumed;
run;
