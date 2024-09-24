*Disk Drive Service;

options nocenter ls=80;
goptions ftitle=centb ftext=swissb htitle=3 
         htext=1.5 ctitle=blue ctext=black;


data a1; 
input Srv_Time Tech Make;
datalines;
   62.0      1      1      1
   48.0      1      1      2
   63.0      1      1      3
   57.0      1      1      4
   69.0      1      1      5
   57.0      1      2      1
   45.0      1      2      2
   39.0      1      2      3
   54.0      1      2      4
   44.0      1      2      5
   59.0      1      3      1
   53.0      1      3      2
   67.0      1      3      3
   66.0      1      3      4
   47.0      1      3      5
   51.0      2      1      1
   57.0      2      1      2
   45.0      2      1      3
   50.0      2      1      4
   39.0      2      1      5
   61.0      2      2      1
   58.0      2      2      2
   70.0      2      2      3
   66.0      2      2      4
   51.0      2      2      5
   55.0      2      3      1
   58.0      2      3      2
   50.0      2      3      3
   69.0      2      3      4
   49.0      2      3      5
   59.0      3      1      1
   65.0      3      1      2
   55.0      3      1      3
   52.0      3      1      4
   70.0      3      1      5
   58.0      3      2      1
   63.0      3      2      2
   70.0      3      2      3
   53.0      3      2      4
   60.0      3      2      5
   47.0      3      3      1
   56.0      3      3      2
   51.0      3      3      3
   44.0      3      3      4
   50.0      3      3      5
;

* Comparison between proc mixed and proc glm for Random Effects;
** the RANDOM statement in proc mixed causes all standrd errors abd test statistics to incorporate the fact that the effect is random;
** the RANDOM statement in proc GLM does not do that. While the /TEST option will fix the test for those listed in the model statement
   it does not help for contrasts;
	* Standard error for a mean as well as estimate statements: proc glm incorrect
	* Standard error for a contrast: proc glm incorrect
    * the Covariance Parameter Estimates table provides variance component estimates based on MSE, MSA ans MSB;
 * the CL option provides CI for var(resid) based on Satterwaite approximation, but var(stain) based on Wald method. 
    note that the Wald interval can include negative values, you need to calculate the Satherth approximation;
** BOTTOM LINE: use proc mixed for mixed effect models;

*Analysis;
proc glm data=a1;
	class make tech;
	model srv_time = make tech make*tech;
	random tech make*tech/test; *The TEST option in the RANDOM statement requests that PROC GLM to determine the appropriate  
tests based on stain being treated as random effects. ;
	lsmeans make/stderr tdiff; *these SE are wrong estimates;
run;
*REML is the default estimation method in PROC MIXED, and you can specify other methods by using the METHOD= option. ; 
* when the number of random levels is not large (in this it is 5), Type III may be better test;
* COVTEST provides estimates of variance components and their 95% CI;
* the CL option provides CI for var(resid) based on ML approximation, but var(tech) based on Wald method;
* the SE estimates of variance components from REML and ML are computed from inverse of information matrix, ;
proc mixed data=a1 asycov covtest cl;
	class make tech;
	model srv_time = make /ddfm=satterth;
	random tech make*tech;
run;

proc mixed data=a1 asycov cl covtest method=type3; * var(tech) is negative here but in REML it is truncated to 0;
	class make tech;
	model srv_time = make/ddfm=satterth ;
	random tech make*tech;
run;

proc mixed data=a1 asycov cl method=type1;
	class make tech;
	model srv_time = make ;
	random tech make*tech;
run;

proc varcomp data=a1; * default is MIVQUE;
class make tech;
model srv_time = make tech make*tech/fixed=1;
run;
proc varcomp data=a1 method=type1;
class make tech;
model srv_time = make tech make*tech/fixed=1;
run;

proc varcomp data=a1 method=reml;
class make tech;
model srv_time = make tech make*tech/fixed=1;
run;

** Blocked factorial with all random effects;
* Heritability is estimated as the ratio of genetic variance to family variance;
* that is var(fam)/[var(loc)/4+var(fam)+var(loc*fam)/4 + var(blk)/12 +var(error)/12];
 /*---Data Set 3.5, Genetics                           ---*/
data e_3_5;
 input loc block fam Yield @@;
  datalines;
1  1  1  268 1  2  1  279 1  3  1  261 1  1  2  242
1  2  2  261 1  3  2  258 1  1  3  242 1  2  3  245
1  3  3  234 1  1  4  225 1  2  4  231 1  3  4  219
1  1  5  236 1  2  5  260 1  3  5  248 2  1  1  238
2  2  1  220 2  3  1  243 2  1  2  215 2  2  2  192
2  3  2  226 2  1  3  198 2  2  3  151 2  3  3  191
2  1  4  195 2  2  4  182 2  3  4  202 2  1  5  201
2  2  5  161 2  3  5  196 3  1  1  221 3  2  1  216
3  3  1  224 3  1  2  208 3  2  2  197 3  3  2  201
3  1  3  186 3  2  3  173 3  3  3  161 3  1  4  207
3  2  4  183 3  3  4  186 3  1  5  200 3  2  5  207
3  3  5  190 4  1  1  194 4  2  1  194 4  3  1  197
4  1  2  203 4  2  2  191 4  3  2  204 4  1  3  177
4  2  3  170 4  3  3  180 4  1  4  180 4  2  4  195
4  3  4  193 4  1  5  199 4  2  5  183 4  3  5  208
;
 /*-------------------------------------------------------*/

 /*-------------------------------------------------------*/
 /*---Output 3.16                                      ---*/
proc mixed data=e_3_5 covtest cl; * REML may not provide good estimates;
   class loc fam block;
   model Yield =;
   random loc fam loc*fam block(loc);
run; 
 /*-------------------------------------------------------*/
 
 /*-------------------------------------------------------*/
 /*---Output 3.17                                      ---*/
proc mixed data=e_3_5 method=type3;
   class loc fam block;
   model Yield=;
   random loc fam loc*fam block(loc);
   ods select CovParms type3;
run; 
 /*-------------------------------------------------------*/
