filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdate disdate fdate los dstat lenfol fstat;
run;
/*Table 5.1 on page 142 using the whas500 data and the bcconf macro to obtain the Brookmeyer-Crowley confidence intervals. 
NOTE:  We use the ods select statement to limit the output to just the part presented in the table.	*/


data t51; set whas500;
lf = lenfol / 365.25; 
run;

* gender;
ods select CensoredSummary HomTests; 
proc lifetest data = t51;
strata gender / test=(logrank) nodetail;
time lf*fstat(0);
run;

/*micro*/
%macro bcconf(data, time, censor, byvar=, level=95, q=50);
   data _null_;
     call symput('crt', abs(probit((1-&level/100)/2)));
   run;
   %if "&byvar" = "" %then %do;
    * the default confidence type is log-log;
     ods listing close;
     ods output quartiles = _q_ (where = (percent=&q));
     proc lifetest data = &data;
       time &time.*&censor.(0);
	   survival stderr out = _s_ 
       (where = ( 0< survival <1 & sdf_stderr ~=. )) ;
     run;

    data  _sq_ ;
      set _s_  (keep = &time survival sdf_stderr) ;
      z = log(-log(survival));
	  *get the variance for log-log survival;
	  v = sdf_stderr**2/(survival**2*(log(survival))**2);
      z&q = abs(z - log(-log((100-&q)/100)))/sqrt(v);
    run;

  proc sql;
    create table _sq1_ as
    select max(&time) as bc_upper, min(&time) as bc_lower
    from _sq_
    where abs(z&q)<=&crt;
  quit;
  proc sql;
    create table _sq2_ as
	select sum(&censor) as total
	from &data;
  quit;
  data _sqall_;
    merge  _q_ (keep = estimate lowerlimit upperlimit)
          _sq1_  _sq2_;
  run;
  ods listing;
  options label;
  data _sqall_;	 
    set _sqall_;
	if bc_upper <=estimate then bc_upper = .;
	if bc_lower >=estimate then bc_lower = .;
	percentile = &q;
  run;

  title "Brookmeyer-Crowley &level% Confidence Interval";
  proc print data = _sqall_ noobs;
    var percentile total estimate lowerlimit upperlimit
	    bc_lower bc_upper;
  run;
  title;   
  %end;
   %else %do;
     proc sort data = &data;
       by &byvar;
     run;
    * the default confidence type is log-log;
     ods listing close;
     ods output quartiles = _q_ (where = (percent=&q));
     proc lifetest data = &data;
       time &time.*&censor.(0);
	   by &byvar;
	   survival stderr out = _s_ 
       (where = ( 0< survival <1 & sdf_stderr ~=. )) ;
     run;

    data  _sq_ ;
      set _s_  (keep = &time survival sdf_stderr &byvar) ;
      z = log(-log(survival));
	  *get the variance for log-log survival;
	  v = sdf_stderr**2/(survival**2*(log(survival))**2);
      z&q = abs(z - log(-log((100-&q)/100)))/sqrt(v);
    run;

  proc sql;
    create table _sq1_ as
    select max(&time) as bc_upper, min(&time) as bc_lower, &byvar
    from _sq_
    where abs(z&q)<=&crt
    group by &byvar;
  quit;
  proc sql;
    create table _sq2_ as
	select sum(&censor) as total, &byvar
	from &data
	group by &byvar;
  quit;
  proc sql;
    create table _sqall_ as
	select _q_.&byvar, total, estimate, lowerlimit, upperlimit, bc_lower, bc_upper
    from _q_, _sq1_, _sq2_
    where _q_.&byvar = _sq1_.&byvar & _sq1_.&byvar = _sq2_.&byvar;
  quit;
  ods listing;
  options label;
  data _sqall_;
    set _sqall_;
	if bc_upper <=estimate then bc_upper = .;
	if bc_lower >=estimate then bc_lower = .;
  run;

  title "Brookmeyer-Crowley &level% Confidence Interval";
  proc print data = _sqall_ noobs;
  run;
  title;   
  %end;
%mend bcconf;

%bcconf(t51, lf, fstat, byvar=gender);

* cvd;
ods select CensoredSummary HomTests; 
proc lifetest data = t51;
strata cvd / test=(logrank) nodetail;
time lf*fstat(0);
run;

%bcconf(t51, lf, fstat, byvar=cvd);

* afb;
ods select CensoredSummary HomTests; 
proc lifetest data = t51;
strata afb / test=(logrank) nodetail;
time lf*fstat(0);
run;

%bcconf(t51, lf, fstat, byvar=afb);
* sho;
ods select CensoredSummary HomTests; 
proc lifetest data = t51;
strata sho / test=(logrank) nodetail;
time lf*fstat(0);
run;

%bcconf(t51, lf, fstat, byvar=sho);
* chf;
ods select CensoredSummary HomTests; 
proc lifetest data = t51;
strata chf / test=(logrank) nodetail;
time lf*fstat(0);
run;
%bcconf(t51, lf, fstat, byvar=chf);
* av3;
ods select CensoredSummary HomTests; 
proc lifetest data = t51;
strata av3 / test=(logrank) nodetail;
time lf*fstat(0);
run;
%bcconf(t51, lf, fstat, byvar=av3);
* miord;
ods select CensoredSummary HomTests; 
proc lifetest data = t51;
strata miord / test=(logrank) nodetail;
time lf*fstat(0);
run;
%bcconf(t51, lf, fstat,byvar= miord);
* mitype;
ods select CensoredSummary HomTests; 
proc lifetest data = t51;
strata mitype / test=(logrank) nodetail;
time lf*fstat(0);
run;
%bcconf(t51, lf, fstat, byvar=mitype);
