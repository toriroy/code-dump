libname M5 'E:\SAS';
proc sort dta = m5.Matched2;
by ID;
run;
proc sort dta = m5.Matched2;
by descending case;
run;

data M5.MatchedCase;
set M5.Matched2;
if CASE = 1 and EXP14 = 1;
keep id case exp14;
run;

data M5.MatchedControl;
set M5. Matched2;
if Case=0 and EXP14 = 1;
Keep ID Case EXP14;
run;
data M5.MatchedControl;
set M5. MatchedControl;
CaseA=Case;
EXP14A = EXP14;
drop case exp14;
run;
proc sort data = M5.MatchedCase;
by id;
run;
proc sort data = M5.MatchedControl;
by id;
run;
data M5.MatchedTot;
merge M5.MatchedCase M5.MatchedControl;
by id;
run;
Data M5.MatchedTot;
set M5.MatchedTot;
Tot = EXP14+EXP14A;
run;
proc sort data = M5.MatchedTot;
by Tot;
run;


proc freq data = M5.Matched2 order=data;
Table Case*Exp14;
run;

proc logistic data = M5.Matched2;
class case (ref='0') exp14 (ref='0' param=ref);
strata id;
model case= exp14;
run;

proc logistic data = M5.Matched2;
class case (ref='0') exp14 (ref='0' param=ref) RACEGRP (Ref='W');
strata id;
model case = exp14 exp14*raceGRP;
oddsratio exp14;
run;


