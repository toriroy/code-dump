
title "Two-way ANOVA Model, Kutner (1974, p.98)";
data a;
input drug disease @;
do i=1 to 6;
input y @;
output;
end;
datalines;
1 1 42 44 36 13 19 22
1 2 33 . 26 . 33 21
1 3 31 -3 . 25 25 24
2 1 28 . 23 34 42 13
2 2 . 34 33 31 . 36
2 3 3 26 28 32 4 16
3 1 . . 1 29 . 19
3 2 . 11 9 7 1 -6
3 3 21 1 . 9 3 .
4 1 24 . 9 22 -2 15
4 2 27 12 12 -5 16 15
4 3 22 7 25 5 12 .
;

* TYPE III SS shows the test for each effect, and 
  PDIFF option in the LSMEANS statement shows the comparison of LS-means.;
proc glm data=a;
class drug disease;
model y=drug disease drug*disease;
lsmeans drug/pdiff;
lsmeans drug*disease/slice=disease; * gives simple effects of drug or sliced drug differences;
run;
*to test some custom hypothesis tests such as the following:
• The average of drugs 1 and 2 is equal to the average of drugs 3 and 4.
• The mean of drug 3 is zero.
• The mean of drug 1 is the same as the mean of drug 2 for disease 2.;

proc glm data=a;
class drug disease;
model y=drug disease drug*disease;
lsmeans drug/pdiff;
estimate "Drug pair 1,2 vs drug pair 3,4" drug 1 1 -1 -1 /divisor=2;
estimate "Drug 3 mean" intercept 1 drug 0 0 1 0;
estimate "Drug 1 disease 2 vs drug 2 disease 2" drug 1 -1 drug*disease 0 1 0 0 -1;
run;
