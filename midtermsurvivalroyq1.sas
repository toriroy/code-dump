data midtermq1;
input ID Gender $ censor time;
datalines;
1 1 0 2
2 1 1 3
3 0 1 2
4 1 1 4
5 1 1 2
6 1 0 2.5
7 0 1 4
8 0 1 5
9 0 0 3
10 0 0 6
 ;
 proc print;
 run;
proc lifetest data=midtermq1 ;
time time*censor(0);
strata gender;
run;

proc lifetest data=midtermq1 atrisk nelson;
time time*censor(0);
strata gender;
run;
