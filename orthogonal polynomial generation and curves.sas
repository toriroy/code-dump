* The following code and associated plot show how the contrast coefficients are related to the polynomial
terms.;
* this gives coefficients for orthogonal contrasts;
* The first column represents the intercept term.;
* Note that in SAS the treatment levels need not be equally spaced.;
proc iml;
x={10 20 30 40 50}; * five levels;
xp=orpol(x,4); * 5-1 orthogonal polynoials;
print xp;
run;
quit;

Title1 "Orthogonal Polynomials";
Title2 "5 Equallyspaced Levels";
Data Five;
Length Trend $9;
Input Trend @;
Do X=4,5,6,7,8;
Input Coef @;
Output;
End;
Datalines;
linear -0.632456 -0.316228 1.969E-17 0.3162278 0.6324555
quadratic 0.5345225 -0.267261 -0.534522 -0.267261 0.5345225
cubic -0.316228 0.6324555 6.501E-17 -0.632456 0.3162278
quartic 0.1195229 -0.478091 0.7171372 -0.478091 0.1195229
;
proc print;
run;
quit;
Proc GPlot Data=Five;
Plot Coef*X=Trend / VAxis=Axis1;
Axis1 Label=(A=90 "Coefficient") Order=(-1 To 1 By .1);
Symbol1 C=Black V=Triangle L=1 I=Spline;
Symbol2 C=Black V=Square L=1 I=Spline;
Symbol3 C=Black V=Diamond L=1 I=Spline;
Symbol4 C=Black V=Circle L=1 I=Spline;
Run;
Quit;
