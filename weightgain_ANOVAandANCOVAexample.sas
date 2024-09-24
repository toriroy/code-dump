*** An experiment was conducted to evaluate the effect of four vitamin supplements on weight gain.  
The experiment was a CRD with 5 separately housed animals for each treatment. The caloric intake of each animal was measured along with the weight gain.;

DATA Q2; 
   INPUT Diet Weight Calorie; 
   DATALINES; 
   1 58 35
   1 67 44 
   1 78 44
   1 69 51
   1 63 47
   2 65 40
   2 49 45
   2 37 37
   2 73 53
   2 63 42
   3 79 51
   3 52 41
   3 63 47
   3 65 47
   3 67 48
   4 51 53
   4 50 52
   4 49 52
   4 42 51
   4 34 43
   ;
   RUN;
* Variance homogneity test;
proc glm data=q2;
class diet;
model weight=diet/solution clparm;
means diet/ hovtest=levene(type=abs) ;
means diet/ hovtest=levene(type=square) ;
means diet/ hovtest=bf ;
run;

* using ods graphics to output diganostics;
ods graphics on;
proc glm data=q2 plots=(diagnostics residuals);
class diet;
model weight=diet/solution clparm;
run;
ods graphics off;

* an equivalent test using proc ANOVA;
proc ANOVA data=q2;
class diet;
model weight=diet;
means diet/cldiff tukey bon dunnett('1') scheffe;
run;

* using clparm for estimating confidence limits for the estimate statement ;
proc glm data=q2;
class diet;
model weight=diet/ clparm;
estimate '1 and 2 vs 3 and 4' diet -1 -1 1 1/divisor=4;
*after obtaining the estimate for the contrast you could use hand calculations to get the adjusted CI;
means diet/cldiff tukey bon dunnett('1') scheffe;
means diet/ regwq ;
run;

*Note that, if you specify an ADJUST= option, the confidence limits for the differences are 
adjusted for multiple inference but the confidence intervals for individual means are not adjusted.	;

proc glm data=q2;
class diet;
model weight=diet/solution clparm;
estimate '1 and 2 vs 3 and 4' diet -1 -1 1 1/divisor=4;
contrast '1 and 2 vs 3 and 4' diet -1 -1 1 1;
lsmeans diet/pdiff cl adjust=tukey ;
lsmeans diet/pdiff cl adjust=bon  ;
lsmeans diet/pdiff cl adjust=dunnett ;
lsmeans diet/pdiff cl adjust=scheffe;
run;

* Proc mixed provides CI for contrast;
PROC MIXED data=q2;
 CLASS diet;
 MODEL weight=diet/NOINT SOLUTION;
 estimate '1 and 2 vs 3 and 4' diet -1 -1 1 1/divisor=4 cl alpha=0.05;
RUN;

* Proc mixed provides CI for contrast with Bonnferronni would need changing the alpha;
PROC MIXED data=q2;
 CLASS diet;
 MODEL weight=diet/NOINT SOLUTION;
 estimate '1 and 2 vs 3 and 4' diet -1 -1 1 1/divisor=4 cl alpha=0.025;
 estimate '1  vs 2' diet 1 -1 0 0/divisor=2 cl alpha=0.025;

RUN;
