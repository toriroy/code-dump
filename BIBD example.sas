
*BIBD example;
data chem;
input catalyst batch time;
cards;
1 1 73
1 2 74
1 4 71
2 2 75
2 3 67
2 4 72
3 1 73
3 2 75
3 3 68
4 1 75
4 3 72
4 4 75
;

proc glm data=chem;
class catalyst batch;
model time=catalyst batch;
lsmeans catalyst/tdiff pdiff adjust=bon stderr;
lsmeans catalyst /tdiff adjust=tukey;
contrast '1 vs 2' catalyst 1 -1 0 0;
estimate '1 vs 2' catalyst 1 -1 0 0;
run;
quit;
