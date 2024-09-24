data hist;
input id time trt co y;
datalines;
1 1 1 0 24
1 2 2 0 5
2 1 1 0 23
2 2 2 0 8
3 1 1 0 19
3 2 2 0 3
4 1 1 0 26
4 2 2 0 8
5 1 1 0 16
5 2 2 0 3
6 1 2 0 2
6 2 1 1 18
7 1 2 0 8
7 2 1 1 29
8 1 2 0 5
8 2 1 1 26
9 1 2 0 6
9 2 1 1 28
10 1 2 0 4
10 2 1 1 19
;

run;
proc sort data=hist;
by time trt;
run;
proc means;
var y;
by time trt;
run;
proc mixed data=hist;
class id time trt co;
model y=time trt co /s chisq;
repeated time / type=un subject=id r;
run;
