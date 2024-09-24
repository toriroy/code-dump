data midtermq1;
input ID Gender $ COD timeyrs;
datalines;
1 m 0 2
2 m 1 3
3 f 1 2
4 m 1 4
5 m 1 2
6 m 0 2.5
7 f 1 4
8 f 1 5
9 f 0 3
10 f 0 6
 ;
 proc print;
 run;
