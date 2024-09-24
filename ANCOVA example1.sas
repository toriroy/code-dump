data DrugTest;
      input Drug $ PreTreatment PostTreatment @@;
      datalines;
   A 11  6   A  8  0   A  5  2   A 14  8   A 19 11
   A  6  4   A 10 13   A  6  1   A 11  8   A  3  0
   D  6  0   D  6  2   D  7  3   D  8  1   D 18 18
   D  8  4   D 19 14   D  8  9   D  5  1   D 15  9
   F 16 13   F 13 10   F 11 18   F  9  5   F 21 23
   F 16 12   F 12  5   F 12 16   F  7  1   F 12 20
   ;

 * Assuming no pre-treatment effect;

 proc sgplot data=drugtest;
  title "Box plot";
  vbox posttreatment / category=drug;
run;

proc sgplot data=drugtest;
    title "Scatter plot to see correlation of y and x";
    scatter x=pretreatment y=posttreatment / group=drug; * group helps to distinguish dots by treatment;
run;
** this provides the same plots as the gplot below*********;
proc sgplot data=drugtest;
    title "Scatter plot to see correlation of y and x in each group";
    reg x=pretreatment y=posttreatment /  group=drug;
run;

**** using gplot to depict ANCOVA plots**********;
title1 'Plot of the data with lines';
symbol1 v='1' i=rl c=black;	*rl=regression line;
symbol2 v='2' i=rl c=black;
symbol3 v='3' i=rl c=black;
proc gplot data=drugtest;
plot posttreatment*pretreatment=drug;
run;

   ods graphics on;
   proc glm data=DrugTest;
      class Drug;
      model PostTreatment = Drug / solution clparm;* clparm results in 95% CI of LSmeans;
      lsmeans Drug / stderr pdiff cov out=adjmeans; 
   run;
   ods graphics off;

  * Assuming there could be pre-treatment effect;
   * Here to get parameter estimates, use centered pretreatment values;
   proc means data=drugtest mean;
   class drug;
   var pretreatment posttreatment ;
   run;

   data drugtest;
   set drugtest;
   pretreatment_c=pretreatment-10.73	;
   run;

   proc glm data=DrugTest;
      class Drug;
      model PostTreatment = Drug PreTreatment_c / solution clparm;
      lsmeans Drug / stderr pdiff cov out=adjmeans;
   run;
   
   proc print data=adjmeans;
   run;

  *This provides Diffogram plots;
ods graphics on;
   * Testing if there differences of pre-treatment effect by drug;
   proc glm data=DrugTest;
      class Drug;
      model PostTreatment = Drug PreTreatment Drug*PreTreatment/ solution clparm;
      lsmeans Drug / stderr pdiff cov out=adjmeans;
   run;
ods graphics off;
   * Using Ods for plotting LS means;

ods graphics on;
     proc glm data=DrugTest plot=meanplot(cl);
      class Drug;
      model PostTreatment = Drug PreTreatment /clparm;
      lsmeans Drug / pdiff;
   run;
 ods graphics off;

 ods graphics on;
    proc glm data=DrugTest plot=diagnostics;
      class Drug;
      model PostTreatment = Drug|PreTreatment/clparm;
      lsmeans Drug / pdiff stderr cov;
   run;
  ods graphics off;

   ** Test  post-pre using ANOVA: this assumes Y= alpha + X;
   data drugtest;
   set drugtest;
   difprepost=Posttreatment - Pretreatment;
   run;

    proc glm data=DrugTest plot=meanplot(cl);
      class Drug;
      model difprepost = Drug ;
      lsmeans Drug / pdiff;
   run;


   *** Second example: no interaction*********;
   options nocenter ls=80;
data example1;
input trt x y @@;
cards;
1 1.2 7 1 1.9 13 1 3.4 16
2 4.0 20 2 5.2 22 2 5.8 32
3 7.7 31 3 8.3 45 3 8.9 42
;
proc sort; by trt;
symbol1 v=circle i= c=black;
symbol2 v=square i= c=black;
symbol3 v=triangle i= c=black;
proc gplot data=example1;
plot y*x=trt;
run;

*equal slopes;
proc glm data=example1;
class trt;
model y=trt x / solution;
means trt /lines lsd;
lsmeans trt / tdiff adjust=t;
run;

*non equal slopes test;
proc glm data=example1;
class trt;
model y=trt x trt*x / solution;
lsmeans trt / tdiff;
run;
