data wloss;
do diet = 1 to 5;
do i =1 to 10;
input wloss @@;
output;
end; 
end;
datalines;
12.4 10.7 11.9 11.0 12.4 12.3 13.0
12.5 11.2 13.1 9.1 11.5 11.3 9.7
13.2 10.7 10.6 11.3 11.1 11.7 8.5
11.6 10.2 10.9 9.0 9.6 9.9 11.3
10.5 11.2 8.7 9.3 8.2 8.3 9.0
9.4 9.2 12.2 8.5 9.9 12.7 13.2
11.8 11.9 12.2 11.2 13.7 11.8 11.5
11.7
;
proc glm data=wloss;
class diet;
model wloss=diet;
lsmeans diet / pdiff cl adjust=bon alpha=0.05; 
run;
proc glm data=wloss;
class diet;
model wloss=diet;
lsmeans diet / pdiff cl adjust=tukey alpha=0.05; *(if unbalanced it gives Tukey Kramer);
run;

proc glm data=wloss;
class diet;
model wloss=diet;
lsmeans diet / pdiff cl adjust=simulate(nsamp=1000 seed=02345);
run;

proc glm data=wloss;
class diet;
model wloss=diet;
lsmeans diet / pdiff cl adjust=dunnett('5');
run;
