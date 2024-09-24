filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdate disdate fdate los dstat lenfol fstat;
run;

/*micro*/
%macro lrtest(data, time, censor, xvar, var_to_test);
  %if "&var_to_test" ="" %then %do;
    data _null_;
	  file print;
	  put "There is no variable to be tested";
	run;
  %goto exit;
 %end; /*end of if statement*/

  %let varcount = 1;
  %let varname = %scan(&var_to_test, &varcount);
  %do %while ("&varname" ~="");
     %let varcount =%eval(&varcount + 1);
     %let varname = %scan(&var_to_test, &varcount);
   %end;
   %let varcount = %eval(&varcount - 1);
  
   %if "&xvar"="" %then %do; /*comparing with the null model*/

   ods listing close;
   ods output fitstatistics = rfit; 
   proc phreg data = &data;
   model &time*&censor(0) = &var_to_test;
   run;
   ods listing;
   data _null_;
      file print;
      set rfit;
      if _n_ = 1 then do;
        p_value= put(1- probchi(withoutcovariates - withcovariates ,&varcount), F4.3);
        put "Full model:  "  "&var_to_test";
        put "Test variables:  " "&var_to_test " ;
        put "Degrees of freedom:  "  "&varcount"   ;
        put "P value:  " p_value ;
      end;
   run;
  %end;
  %else %do;
  ods listing close;
  ods output fitstatistics = rfit; 
  proc phreg data = &data;
  model &time*&censor(0) = &xvar;
  run;
  ods output fitstatistics = fit;  
  proc phreg data = &data;
  model &time*&censor(0) = &xvar &var_to_test;
  run;
  data _null_;
    set rfit;
    if _n_ = 1 then call symput('less', withcovariates);
    set fit;
    if _n_ = 1 then call symput('more', withcovariates);
  run;
  ods listing;
  data _null_;
    file print;
    p_value= put(1- probchi(&less - &more ,&varcount), F4.3);
  put "Full model:     "  "&xvar  &var_to_test";
  put "Reduced model:  "  "&xvar";
  put "Test variables:  " "&var_to_test" ;
  put "Degrees of freedom:  "  "&varcount"   ;
  put "P value:  " p_value ;
run;
%end;
%exit: %mend lrtest;


/*Table 5.2 on page 143 using the whas500 data and the lrtest macro which is used to get the p-values in the right-most column of the table.
NOTE: We use the ods select statement to limit the output to just the part presented in the table. 	*/

data whas500_t52;
set whas500;
age5 = age/5;
hr10 = hr/10;
sysbp10 = sysbp/10;
diasbp10 = diasbp/10;
bmi5 = bmi/5;
run;
* age;
ods select ParameterEstimates;
proc phreg data = whas500_t52;
model lenfol*fstat(0) = age5 / risklimits;
run;
%lrtest(whas500_t52, lenfol, fstat, , age5);
* heart rate;
ods select ParameterEstimates;
proc phreg data = whas500_t52;
model lenfol*fstat(0) = hr10 / risklimits;
run;
%lrtest(whas500_t52, lenfol, fstat, , hr10);
* sysbp;
ods select ParameterEstimates;
proc phreg data = whas500_t52;
model lenfol*fstat(0) = sysbp10 / risklimits;
run;
%lrtest(whas500_t52, lenfol, fstat, , sysbp10);
* diasbp;
ods select ParameterEstimates;
proc phreg data = whas500_t52;
model lenfol*fstat(0) = diasbp10 / risklimits;
run;
%lrtest(whas500_t52, lenfol, fstat, , diasbp10);
* bmi;
ods select ParameterEstimates;
proc phreg data = whas500_t52;
model lenfol*fstat(0) = bmi5 / risklimits;
run;
%lrtest(whas500_t52, lenfol, fstat, , bmi5);
