data flatdata;
input subj lf1 lf2 lf3;
datalines;
1 20 30 32
2 12 5 14
3 20 17 26
4 20 16 29
5 13 28 20
6 10 20 10
7 9 11 9
8 21 20 33
9 7 3 11
10 14 3 12
;
*creating univariate data from multivariate data;
data verticaldata;
set flatdata;
array x[3] lf1 lf2 lf3;
do group=1 to 3;
 response=x[group];
output;
end;
run;
proc print data=verticaldata;
*var group response;
run;

*creating flat(multivariate) from vertica(univariate);
data flatdata;
array xx[3] lf1 lf2 lf3;
do i= 1 to 3;
 set verticaldata;
xx[i]=response;
 end;
 run;
 proc print data=flatdata;
 run;


proc glm data=flatdata;
 model lf1 lf2 lf3= /p;
run;

proc glm data=verticaldata;
 model response=x /p;
run;

**using proc transpose;
proc transpose data=flatdata out=vertdata prefix=lf;
by subj;
var lf1 lf2 lf3;
run;

data vertdata;
set vertdata (rename=(col1=lf));
time=input(substr(_name_,3),5.);
keep subj time lf;
*drop _name_;

