
 /*-------------------------------------------------------*/
 /*---CHAPTER 3: Random Effects Models                 ---*/
 /*-------------------------------------------------------*/

 /*-------------------------------------------------------*/
 /*---Data Set 3.3, Mississippi River                  ---*/
data influent;
  input influent y type @@;
  datalines;
1   21  2 1   27  2 1   29  2 1   17  2 1   19  2
1   12  2 1   29  2 1   20  2 1   20  2 2   21  2
2   11  2 2   18  2 2   9   2 2   13  2 2   23  2
2   2   2 3   20  1 3   19  1 3   20  1 3   11  1
3   14  1 4   14  2 4   24  2 4   30  2 4   21  2
4   31  2 4   27  2 5   7   1 5   15  1 5   18  1
5   4   1 5   28  1 6   41  3 6   42  3 6   35  3
6   34  3 6   30  3
;
 /*-------------------------------------------------------*/

 /*-------------------------------------------------------*/
 /*---Output 3.1                                       ---*/
proc mixed data=influent covtest cl;
   class influent;
   model y = /solution;
   random influent / solution;

   estimate 'influent 1' intercept 1 | influent 1 0 0 0 0 0;
   estimate 'influent 2' intercept 1 | influent 0 1 0 0 0 0;
   estimate 'influent 3' intercept 1 | influent 0 0 1 0 0 0;
   estimate 'influent 4' intercept 1 | influent 0 0 0 1 0 0;
   estimate 'influent 5' intercept 1 | influent 0 0 0 0 1 0;
   estimate 'influent 6' intercept 1 | influent 0 0 0 0 0 1;

   estimate 'influent 1U' | influent 1 0 0 0 0 0;
   estimate 'influent 2U' | influent 0 1 0 0 0 0;
   estimate 'influent 3U' | influent 0 0 1 0 0 0;
   estimate 'influent 4U' | influent 0 0 0 1 0 0;
   estimate 'influent 5U' | influent 0 0 0 0 1 0;
   estimate 'influent 6U' | influent 0 0 0 0 0 1;
run;
 /*-------------------------------------------------------*/

 /*-------------------------------------------------------*/
 /*---Output 3.2                                       ---*/
proc mixed data=influent method=ml;
   class influent;
   model y = / solution;
   random influent / solution;
   estimate 'influent 1' intercept 1 | influent 1 0 0 0 0 0;
   estimate 'influent 2' intercept 1 | influent 0 1 0 0 0 0;
   estimate 'influent 3' intercept 1 | influent 0 0 1 0 0 0;
   estimate 'influent 4' intercept 1 | influent 0 0 0 1 0 0;
   estimate 'influent 5' intercept 1 | influent 0 0 0 0 1 0;
   estimate 'influent 6' intercept 1 | influent 0 0 0 0 0 1;

   estimate 'influent 1U' | influent 1 0 0 0 0 0;
   estimate 'influent 2U' | influent 0 1 0 0 0 0;
   estimate 'influent 3U' | influent 0 0 1 0 0 0;
   estimate 'influent 4U' | influent 0 0 0 1 0 0;
   estimate 'influent 5U' | influent 0 0 0 0 1 0;
   estimate 'influent 6U' | influent 0 0 0 0 0 1;
run;
 /*-------------------------------------------------------*/

 /*-------------------------------------------------------*/
 /*---Output 3.3                                       ---*/
proc mixed data=influent method=mivque0;
   class influent;
   model y = / solution;
   random influent / solution;
   estimate 'influent 1' intercept 1 | influent 1 0 0 0 0 0;
   estimate 'influent 2' intercept 1 | influent 0 1 0 0 0 0;
   estimate 'influent 3' intercept 1 | influent 0 0 1 0 0 0;
   estimate 'influent 4' intercept 1 | influent 0 0 0 1 0 0;
   estimate 'influent 5' intercept 1 | influent 0 0 0 0 1 0;
   estimate 'influent 6' intercept 1 | influent 0 0 0 0 0 1;

   estimate 'influent 1U' | influent 1 0 0 0 0 0;
   estimate 'influent 2U' | influent 0 1 0 0 0 0;
   estimate 'influent 3U' | influent 0 0 1 0 0 0;
   estimate 'influent 4U' | influent 0 0 0 1 0 0;
   estimate 'influent 5U' | influent 0 0 0 0 1 0;
   estimate 'influent 6U' | influent 0 0 0 0 0 1;
run;
 /*-------------------------------------------------------*/

 /*-------------------------------------------------------*/
 /*---Output 3.4                                       ---*/
proc mixed data=influent method=type1;
   class influent;
   model y = / solution;
   random influent / solution;
   estimate 'influent 1' intercept 1 | influent 1 0 0 0 0 0;
   estimate 'influent 2' intercept 1 | influent 0 1 0 0 0 0;
   estimate 'influent 3' intercept 1 | influent 0 0 1 0 0 0;
   estimate 'influent 4' intercept 1 | influent 0 0 0 1 0 0;
   estimate 'influent 5' intercept 1 | influent 0 0 0 0 1 0;
   estimate 'influent 6' intercept 1 | influent 0 0 0 0 0 1;

   estimate 'influent 1U' | influent 1 0 0 0 0 0;
   estimate 'influent 2U' | influent 0 1 0 0 0 0;
   estimate 'influent 3U' | influent 0 0 1 0 0 0;
   estimate 'influent 4U' | influent 0 0 0 1 0 0;
   estimate 'influent 5U' | influent 0 0 0 0 1 0;
   estimate 'influent 6U' | influent 0 0 0 0 0 1;
run;
 /*-------------------------------------------------------*/

 /*-------------------------------------------------------*/
 /*---Output 3.5                                       ---*/
proc mixed data=influent noprofile; 
   class influent;
   model y = / solution;
   random influent / solution;
   parms (70) (25) / noiter;
run;
 /*-------------------------------------------------------*/

 /*-------------------------------------------------------*/
 /*---Output 3.6                                       ---*/    
proc glm data=influent; 
   class influent;
   model y = influent;
   random influent / test;

   estimate 'Mean'       intercept 6 influent 1 1 1 1 1 1 / divisor=6;
   estimate 'Influent 1' intercept 6 influent 6 0 0 0 0 0 / divisor=6;
   estimate 'Influent 2' intercept 6 influent 0 6 0 0 0 0 / divisor=6;
   estimate 'Influent 3' intercept 6 influent 0 0 6 0 0 0 / divisor=6;
   estimate 'Influent 4' intercept 6 influent 0 0 0 6 0 0 / divisor=6;
   estimate 'Influent 5' intercept 6 influent 0 0 0 0 6 0 / divisor=6;
   estimate 'Influent 6' intercept 6 influent 0 0 0 0 0 6 / divisor=6;

   estimate 'Influent 1U' influent  5 -1 -1 -1 -1 -1 / divisor=5;
   estimate 'Influent 1U' influent -1  5 -1 -1 -1 -1 / divisor=5;
   estimate 'Influent 1U' influent -1 -1  5 -1 -1 -1 / divisor=5;
   estimate 'Influent 1U' influent -1 -1 -1  5 -1 -1 / divisor=5;
   estimate 'Influent 1U' influent -1 -1 -1 -1  5 -1 / divisor=5;
   estimate 'Influent 1U' influent -1 -1 -1 -1 -1  5 / divisor=5;
run;
quit;
 /*-------------------------------------------------------*/

 /*-------------------------------------------------------*/
 /*---Output 3.7                                       ---*/
data satt;
   /* c = coefficient of var(influent) in e(ms influent) */
   c      = 6.0973;
   mssite = 1319.77936508/31;  * ms error;
   msi    = 1925.19360789/5;   * ms influent;
   sa2    = 56.16672059;       *estimate of var(influent);
   /* approximate degrees of freedom*/;
   v      = (sa2**2)/((((msi/c)**2)/5)+(((mssite/c)**2)/31)); 
   c025   = cinv(.025,v); * lower  2.5 chi square percentage point;
   c975   = cinv(.975,v); * upper 97.5 chi square percentage point;
   low    = v*sa2/C975;   * lower limit;
   high   = v*sa2/C025;   * upper limit;
run; 
proc print data=satt; 
run;
 /*-------------------------------------------------------*/


 /*-------------------------------------------------------*/
 /*---Output 3.8 and Output 3.9                        ---*/
proc mixed data=influent covtest cl; 
   class type influent;
   model y=type/solution;
   random influent(type)/solution;
   estimate 'influent 1' intercept 1 type 0 1 0 | 
                         influent(type) 1 0 0 0 0 0;
   estimate 'influent 2' intercept 1 type 0 1 0 | 
                         influent(type) 0 1 0 0 0 0;
   estimate 'influent 3' intercept 1 type 1 0 0 | 
                         influent(type) 0 0 1 0 0 0;
   estimate 'influent 4' intercept 1 type 0 1 0 | 
                         influent(type) 0 0 0 1 0 0;
   estimate 'influent 5' intercept 1 type 1 0 0 | 
                         influent(type) 0 0 0 0 1 0;
   estimate 'influent 6' intercept 1 type 0 0 1 | 
                         influent(type) 0 0 0 0 0 1;
   lsmeans type / diff;
run;
 /*-------------------------------------------------------*/

 /*-------------------------------------------------------*/
 /*---Output 3.10                                      ---*/
proc mixed data=influent method=type3; 
   class type influent;
   model y=type/solution;
   random influent(type)/solution;
   estimate 'influent 1' intercept 1 type 0 1 0 | 
                         influent(type) 1 0 0 0 0 0;
   estimate 'influent 2' intercept 1 type 0 1 0 | 
                         influent(type) 0 1 0 0 0 0;
   estimate 'influent 3' intercept 1 type 1 0 0 | 
                         influent(type) 0 0 1 0 0 0;
   estimate 'influent 4' intercept 1 type 0 1 0 | 
                         influent(type) 0 0 0 1 0 0;
   estimate 'influent 5' intercept 1 type 1 0 0 | 
                         influent(type) 0 0 0 0 1 0;
   estimate 'influent 6' intercept 1 type 0 0 1 | 
                         influent(type) 0 0 0 0 0 1;
   lsmeans type / diff;
run;
 /*-------------------------------------------------------*/

 /*-------------------------------------------------------*/
 /*---Output 3.11                                      ---*/
proc glm data=influent; 
   class type influent;
   model y = type influent(type);
   random influent(type) / test;
run;
