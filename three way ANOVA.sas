
* extol is exercise tolerance measured by minutes until fatigue on a bicycle test;
* gender: male=1, female=2;
* percent body fat: 1=low, 2=high;
* smoking history: 1=light, 2=heavy;
* n=3 replications for each cell;
data exercise;
input Obs extol gender fat smoke gfs; *where gfs = 100*gender + 10*fat + smoke;;
datalines;
1 24.1 1 1 1 111
2 29.2 1 1 1 111
3 24.6 1 1 1 111
4 20.0 2 1 1 211
5 21.9 2 1 1 211
6 17.6 2 1 1 211
7 14.6 1 2 1 121
8 15.3 1 2 1 121
9 12.3 1 2 1 121
10 16.1 2 2 1 221
11 9.3 2 2 1 221
12 10.8 2 2 1 221
13 17.6 1 1 2 112
14 18.8 1 1 2 112
15 23.2 1 1 2 112
16 14.8 2 1 2 212
17 10.3 2 1 2 212
18 11.3 2 1 2 212
19 14.9 1 2 2 122
20 20.4 1 2 2 122
21 12.8 1 2 2 122
22 10.1 2 2 2 222
23 14.4 2 2 2 222
24 6.1 2 2 2 222
;
proc sort data=exercise;
by gender fat smoke;
title1 'Plot of the data';
symbol1 v=circle i=none c=black;
proc gplot data=exercise;
plot extol*gfs/ haxis = 111 112 121 122 211 212 221 222;
run;
proc means data=exercise;
output out=exer2 mean=avextol;
by gender fat smoke;
run;
data exer2;
set exer2;
fs = fat*10 + smoke; * making a two variable combination of fat and smoke to help with plotting of means;
run;
proc sort data=exer2; by fs;
title1 'Plot of the means';
symbol1 v='M' i=join c=black;
symbol2 v='F' i=join c=black;
proc gplot data=exer2;
plot avextol*fs=gender / haxis = 11 12 21 22;
run;
proc glm data=exercise;
class gender fat smoke;
model extol=gender|fat|smoke / solution;
means gender*fat*smoke;
run;
