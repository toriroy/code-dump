* Test of HOMOGENEITY of variance: tests homogeneity of covariance parameters across groups by imposing equality constraints. 
* For example, the following statements fit a one-way model with heterogeneous variances and test whether the model could be reduced to a one-way analysis with the same variance 
across groups: ;

* One factor: checking constant variance;
proc glimmix;
   class A B;
   model y = A B;
   random _residual_ / group=A;
   covtest 'common variance' homogeneity;
run;

proc glimmix;
   class A B;
   model y = A B;
   random _residual_ / group=B; * if B is also fixed;
   covtest 'common variance' homogeneity;
run;
* Here you need to increate the A*B combinations to form one way ANOVA;
proc glm ;
   class A B;
   model y = A*B;
   means A/ HOVTEST;
run;

* we can also use glm for each factor and HOVTEST but we need first to output R=residual from the two way ANOVA
  and either use absR or SqR;
proc glm;
   class A B;
   model Y = A B;
   output out=resid r=r p=p;
run;
data resid;
set resid;
absR=abs(r);
sqR=r*r;
run;

proc glm;
   class A ;
   model absR = A;
   means A / HOVTEST;
run;
proc glm;
   class B ;
   model absR = B;
   means B / HOVTEST;
run;

** Example **;
DATA RM1;
INPUT B A Y @@;
CARDS;
1 1 2.6 1 2 4.6 1 3 5.2 1 4 4.2
2 1 3.9 2 2 5.1 2 3 6.3 2 4 5.0
3 1 4.2 3 2 5.8 3 3 7.1 3 4 5.8
4 1 2.4 4 2 3.9 4 3 5.1 4 4 4.0
5 1 3.3 5 2 5.2 5 3 6.3 5 4 3.8
6 1 3.9 6 2 5.5 6 3 5.2 6 4 4.5
;
* Test of HOMOGENEITY: tests homogeneity of covariance parameters across groups by imposing equality constraints. For example, the following statements fit a one-way model with heterogeneous variances and 
test whether the model could be reduced to a one-way analysis with the same variance across groups: ;
proc glimmix;
   class A;
   model y = a;
   random _residual_ / group=A;
   covtest 'common variance' homogeneity;
run;
