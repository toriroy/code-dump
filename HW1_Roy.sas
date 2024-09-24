/*
F0.05,2,10,0		F0.05,2,10,1		F0.01,2,10,0		F0.01,2,10,5
F0.05,2,20,0		F0.05,2,20,1		F0.01,2,20,0		F0.01,2,20,5
F0.05,2,30,0		F0.05,2,30,1		F0.01,2,30,0		F0.01,2,30,5 
*/


data one; 
q1=finv(.95, 2, 10, 0);
q2=finv(.95, 2, 20, 0);
q3=finv(.95, 2, 30, 0);

q4=finv(.95, 2, 10, 1);
q5=finv(.95, 2, 20, 1);
q6=finv(.95, 2, 30, 1);

q7=finv(.99, 2, 10, 0);
q8=finv(.99, 2, 20, 0);
q9=finv(.99, 2, 30, 0);

q10=finv(.99, 2, 10, 5);
q11=finv(.99, 2, 20, 5);
q12=finv(.99, 2, 30, 5);
put q1= q2= q3= q4= q5= q6= q7= q8= q9= q10= q11= q12=;
run;

proc print data=one;
run;

data phys;
input physician $ LOS;
cards;
C 6
C 7
C 7
C 6
C 8
C 8
C 6
C 7
C 7
C 7

B 4
B 5
B 4
B 3
B 4
B 5
B 3
B 3
B 5
B 5

A 5
A 3
A 3
A 3
A 3
A 3
A 4
A 2
A 4
A 2
;
run;
proc print data = phys;
run;

proc glm data=phys;
class physician;
model los = physician;
run;

proc glm data=phys;
class physician (ref='C');
model los = physician;
lsmeans physician / cl;
run;
