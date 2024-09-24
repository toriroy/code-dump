/* Example 17  page 42                                         */
/* Reads the data from compact list   */
data bread;
  input time h1-h4;
  height=h1; output;
  height=h2; output;
  height=h3; output;
  height=h4; output;
  keep time height;
datalines;
35 4.5 5.0 5.5 6.75
40 6.5 6.5 10.5 9.5
45 9.75 8.75 6.5 8.25
run;
proc glm data=bread;
  class time;
  model height=time;
  estimate 'Linear Trend' time -.707107 0 .707107;
  estimate 'Quadratic Trend' time .4082483 -.816497 .4082483;
run;

* to test quadratic and linear trends independently each at 5%;
proc glm data=bread;
  class time;
  model height=time;
  contrast 'Linear Trend' time -.707107 0 .707107;
  contrast 'Quadratic Trend' time .4082483 -.816497 .4082483;
run;
*To test the hypothesis that the pooled A linear and A quadratic effect is zero, you can use: ;
proc glm data=bread;
  class time;
  model height=time;
  contrast 'Linear and quadratic Trend' 
    time -.707107 0 .707107,
    time .4082483 -.816497 .4082483/e;
run;
