title 'Balanced Data from Randomized Complete Block';
data plants;
   input Type $ @;
   do Block = 1 to 3;
      input StemLength @;
      output;
      end;
   datalines;
1 32.7 32.3 31.5
2 32.1 29.7 29.1
3 35.7 35.9 33.1
4 36.0 34.2 31.2
5 31.8 28.0 29.2
6 38.2 37.8 31.9
7 32.5 31.1 29.7
;

data plants2;
set plants;
if type eq 1 then type1=1; else type1=0;
if type eq 2 then type2=1; else type2=0;
if type eq 3 then type3=1; else type3=0;
if type eq 4 then type4=1; else type4=0;
if type eq 5 then type5=1; else type5=0;
if type eq 6 then type6=1; else type6=0;
if type eq 7 then type7=1; else type7=0;
run;
proc glm ;
   class Type;
   model StemLength = Type/solution;
   estimate 'effect1' type ;
run;

proc glm;
   model StemLength = Type1-type7/solution;
run;

proc genmod;
   class Type(param=ref);
   model StemLength = Type/dist=normal;
   run;
   proc genmod;
   class Type(param=effect); * this provides estimates of tau- treatment effect;
   model StemLength = Type/dist=normal;
   run;
   proc means data=plants2;
   class type;
   var stemlength;
   run;
   proc means data=plants2;
   var stemlength;
   run;

