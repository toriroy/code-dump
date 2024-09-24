* An experiment was designed to study the performance of four different detergents for cleaning
clothes. The following cleanness readings (higher = cleaner) were obtained with specially
designed equipment for three different types of common stains. 
* Is there a difference among the detergents?;

options nocenter ls=78;
goptions colors=(none);
symbol1 v=circle; axis1 offset=(5);
data wash;
input stain soap y @@;
cards;
1 1 45 1 2 47 1 3 48 1 4 42
2 1 43 2 2 46 2 3 50 2 4 37
3 1 51 3 2 52 3 3 55 3 4 49
;
run;
* RANDOM BLOCK EXAMPLE;
* assume that stain is random;
proc glm data=wash;
class stain soap;
model y = stain soap /clparm; 
random stain/test; *The TEST option in the RANDOM statement requests that PROC GLM to determine the appropriate  
tests based on stain being treated as random effects. ;
*test e=soap h=soap*stain; 	* if the design was generalized RCBD with replication;
lsmeans soap/stderr tdiff; *these SE are wrong estimates based on SE=sqrt(MSE/b) instead of SE=sqrt(2MSE/b);
run;
* equivalent to prc glm when data is balanced;
proc mixed data=wash method=reml covtest cl; *default method is REML and COVTEST provides estimates of variance components;
class stain soap;
model y = soap /*/ddfm=sat*/; 
random stain; *allows for variance component due to rando block;
*since there is no SUBJECT statement this assumes that all observations are from the same subject;
*lsmeans soap/diff cl; *unadjsuted;
*lsmeans soap/diff cl adjust=simulate(seed=12345) ;* provides FWE protection when assumptions are violated (more useful);
run;
proc mixed data=wash method=type3 covtest cl; *default method is REML and COVTEST provides estimates of variance components;
class stain soap;
model y = soap/ddfm=sat; 
random stain; *allows for variance component due to rando block;
*since there is no SUBJECT statement this assumes that all observations are from the same subject;
*lsmeans soap/diff cl; *unadjsuted;
*lsmeans soap/diff cl adjust=simulate(seed=12345) ;* provides FWE protection when assumptions are violated (more useful);
run;

Proc varcomp data=wash ;
class stain soap;
model y = soap stain /fixed=1;
run;
* Comparison between proc mixed and proc glm for Random Effects;
** the RANDOM statement in proc mixed causes all standrd errors abd test statistics to incorporate the fact that the effect is random;
** the RANDOM statement in proc GLM does not do that. While the /TEST option will fix the test for those listed in the model statement
   it does not help for contrasts;
	* Standard error for a mean as well as estimate statements: proc glm incorrect
	* Standard error for a contrast: proc glm incorrect
    * the Covariance Parameter Estimates table provides variance component estimates based on MSE, MSA ans MSB (with type3) and REML (with default). They are equal for balanced data;
 * the CL option provides CI for var(resid) based on Satterwaite approximation, but var(stain) based on Wald method. 
    note that the Wald interval can include negative values, you need to calculate the Satherth approximation;
** BOTTOM LINE: use proc mixed for mixed effect models;

proc mixed data=wash method=REML covtest cl; *default method is REML and COVTEST provides estimates of variance components;
 * the CL option provides CI for var(resid) based on ML approximation, but var(stain) based on Wald method;
class stain soap;
model y = soap/s; 
random stain; *allows for variance component due to rando block;
*since there is no SUBJECT statement this assumes that all observations are from the same subject;
lsmeans soap/diff cl;
lsmeans soap/diff cl adjust=simulate(seed=12345) ;* provides FWE protection;
estimate 'Soap 4 mean' intercept 1 soap 0 0 0 1;
estimate 'soap 1 vs soap 4' soap 1 0 0 -1;
contrast 'soap 1 vs soap 4' soap 1 0 0 -1;
run;

*Satterwaite approximated 95% CI for varinace of stain;
* equivalent to prc glm when data is balanced;
proc mixed data=wash method=type3 covtest cl; *default method is REML and COVTEST provides estimates of variance components;
class stain soap;
model y = soap; 
random stain; *allows for variance component due to rando block;
ods select Type3 CovParms;
ods output type3=Type3;
run;

data satt;
merge type3(where=(source='stain') rename=(ms=msblk df=dfblk))
      type3(where=(source='Residual') rename=(ms=mserror df=dferror));
	  var_blk=(msblk - mserror)/4; *g=4, b=3;
	  df_satt=(var_blk)**2/(((msblk/4)**2)/dfblk + (((mserror/4)**2)/dferror));
	  CI_low=df_satt*var_blk/cinv(.975,df_satt);
	  CI_upp=df_satt*var_blk/cinv(.025,df_satt);
run;
* the estimate of var(blk) that you get from proc MIXED and the step above will be about the same with method=type3;
proc print data=satt;
var msblk dfblk mserror dferror var_blk df_satt CI_low CI_upp;
run;
* how about if we use method=REML, you get 95% CI for var(blk) based on Satterwaite;
proc mixed data=wash method=reml covtest cl; *default method is REML and COVTEST provides estimates of variance components;
class stain soap;
model y = soap; 
random stain; *allows for variance component due to rando block;
*ods select Type3 CovParms;
*ods output type3=Type3;
run;













*Q2;
data factorial;
   seed=12345;
   do A=1 to 2;
      do B=1 to 2;
         do rep=1 to 100;
            y=25 + B + (2-A) - 8*B*(2-A) + rannor(seed)*5;
            output;
         end;
      end;
   end;
run;

PROC mixed DATA=factorial method=type3 covtest cl;
CLASS A B;
MODEL y = A;
random B A*B;
RUN;
QUIT;
*restricted maximum likelihood;
PROC mixed DATA=factorial method=reml covtest cl;
CLASS A B;
MODEL y = A;
random B A*B;
RUN;
QUIT;
*maximum likelihood;
PROC mixed DATA=factorial method=ml covtest cl;
CLASS A B;
MODEL y = A;
random B A*B;
RUN;
QUIT;

Proc varcomp data=factorial ;
CLASS A B;
MODEL y = A B A*B/fixed=1;
run;
Proc varcomp data=factorial method=reml;
CLASS A B;
MODEL y = A B A*B/fixed=1;
run;
Proc varcomp data=factorial method=type1;
CLASS A B;
MODEL y = A B A*B/fixed=1;
run;



* difference between estimate LSMestimate and LSmeans - assume stain as conti;
proc mixed data=wash method=REML covtest cl; 
class soap;
model y = soap stain/s; 
lsmeans soap/diff cl;
lsmeans soap/diff cl at stain=1;
lsmestimate soap 'soap 1 vs soap 4' 1 0 0 -1 ;
estimate 'soap 1 vs soap 4' soap 1 0 0 -1; * this is equivalent to at stain=0;
estimate 'soap 1 vs soap 4' soap 1 0 0 -1 stain 1;
estimate 'soap 1 vs soap 4' soap 1 0 0 -1 stain 2;
estimate 'soap 1 vs soap 4' soap 1 0 0 -1 stain 3;
estimate 'soap 1 vs soap 4' soap 1 0 0 -1 stain 1.5;
estimate 'soap 1 vs soap 4' soap 1 0 0 -1 stain 0;

*lsmestimate soap 'soap 1 vs soap 4' 1 0 0 -1 at stain=1;
run;
