* Density and histogram plots to check normality;

proc sgplot data = mylib.truncreg;
  histogram achiv / scale = count showbins;
  density achiv;
run;
