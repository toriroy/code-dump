/* Example 5 page 63                              */
Data CO;
input Ethanol Ratio CO;
datalines;
.1 14 66
.1 14 62
.1 15 72
.1 15 67
.1 16 68
.1 16 66
.2 14 78
.2 14 81
.2 15 80
.2 15 81
.2 16 66
.2 16 69
.3 14 90
.3 14 94
.3 15 75
.3 15 78
.3 16 60
.3 16 58
;
run;

data COwithmiss;
set CO;
id=_n_;
if id eq 17 then CO='.';
run;

ods graphics on;
proc glm data=CO;
  class Ethanol Ratio;
  model CO=Ethanol Ratio Ethanol*Ratio/solution ss1 ss3;
  means Ethanol Ratio Ethanol*Ratio;
  lsmeans Ethanol*Ratio/slice=(ethanol ratio) adjust=tukey;
run;
* compare to the balanced above**;
proc glm data=COwithmiss;
  class Ethanol Ratio;
  model CO=Ethanol Ratio Ethanol*Ratio/solution ss1 ss2 ss3;
  means Ethanol Ratio Ethanol*Ratio;
  lsmeans Ethanol*Ratio/slice=(ethanol ratio) adjust=tukey;
run;
ods graphics off;


* Example 2*;

data rat;
input env trait num @@;
cards;
1 1 92 1 1 100 1 1 89
2 1 106 2 1 98
1 2 85 1 2 76 1 2 72 1 2 92
1 3 51 1 3 61 1 3 47
2 2 80 2 2 72 2 2 92
2 3 73 2 3 82 2 3 77 2 3 69
; 

*  order matters in the type I SS analysis;
proc glm data=rat;
class env trait;
model num = env / ss1 ss3;
run;

proc glm data=rat;
class env trait;
model num = env trait / ss1 ss3;
run;

proc glm data=rat;
class env trait;
model num =trait env  / ss1 ss3 ;
run;
proc glm data=rat;
class env trait;
model num = env|trait / ss1 ss3 ;
run;

ods graphics on;
proc glm data=rat;
class env trait;
model num = env|trait / ss1 ss3 ;
means env|trait; * may not be accurate;
lsmeans env|trait / stderr;	* use lsmeans since they use predicted cell means;
output out = new r = res p = pred;
run;
ods graphics off;

ods graphics on;
proc glm data=rat;
class env trait;
model num = trait|env / ss1 ss2 ss3 ;
means env|trait;
lsmeans env|trait / stderr;
output out = new r = res p = pred; 
run;
ods graphics off;
proc plot data=new;
plot res*pred;
run;
