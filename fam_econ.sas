options ls=80 nodate pageno=1 NOFMTERR; 

libname will "I:\bmtry702\BMTRY702\Fall 2015\reading materials\Will PH6470 course";
 
data econ_longform;
set will.econ_longform;
run;
  title3;
 ************ Family Economic data: plots of families, means ***************;

 proc sort data=econ_longform;
    BY family_id cohort;

Proc SGplot data = econ_longform;
   series x=year y=income / group =family_id LineAttrs= (pattern=1 color="black");

  proc sort data=econ_longform;
   by year;

 proc means mean data=econ_longform;
   by year;
   var income;
   output out=m mean=mean_income;

 proc print data=m;

 data combined;
   set econ_longform m;

 Proc SGplot data = combined;
   series x=year y=income / group =family_id LineAttrs= (pattern=1 color="black");
   series x=year y=mean_income / LineAttrs= (pattern=1 color="blue" thickness=4);

Proc SGpanel data=econ_longform;
   PanelBy cohort / columns=2; 
   series x=year y=income / group=family_id LINEATTRS= (pattern=1 color="black");

 Proc SGpanel data=econ_longform;
   PanelBy cohort / rows=2; 
   series x=year y=income / group=family_id LINEATTRS= (pattern=1 color="black");
 proc sort data=econ_longform;
   by cohort year;

 proc means mean data=econ_longform;
   by cohort year;
   var income;
   output out=n mean=mean_income;

 proc print data=n;

 data combined2;
   set econ_longform n;

 Proc SGpanel data=combined2;
   PanelBy cohort / columns=2; 
   series x=year y=income / group=family_id LINEATTRS= (pattern=1 color="black");
   series x=year y=mean_income /  LINEATTRS= (pattern=1 color="blue" thickness=4);

 Proc SGplot data = N;
   series x=year y=mean_income / group=cohort LineAttrs= (pattern=1 thickness=2);

 run; quit;/*

 *************** BP example******************************;

 proc sort data=BP;  
   by sid Age_at_visit;

 data plot_sample;
   set BP;
   by sid Age_at_visit;
   if (first.sid=1) then U = ranuni(23407);
   retain U;

 proc print data=plot_sample (obs=50);
   var sid Age_at_visit SBP_percentile U;

  Proc SGplot noautolegend data=plot_sample;
     where U GE .95; 
    series x=Age_at_visit y=SBP_percentile / group=sid 
       LINEATTRS= (pattern=1 );

run; quit; */


 **************within-subj correlation plots *********;
 
 Proc Transpose data=econ_longform out=econ_wideform prefix=income_;
   ID year;
   VAR income;
   BY family_id cohort;

   run; 

 ODS graphics on;

 Proc Corr data=econ_wideform  plots=matrix;
   var income_1990-income_1995;
 run;
 Proc Corr data=ph6470.alz_wide  plots=matrix;
   var score1-score5;

run;

 ODS graphics off;
 run; quit;
* Matrix plot;
* set ODS graphics to landscape mode and designate output PDF file;
OPTIONS ORIENTATION=LANDSCAPE;
ODS GRAPHICS ON;
TITLE 'family income';
        PROC SGSCATTER DATA=econ_wideform;
        *MATRIX income_1990--income_1995 / DIAGONAL=(HISTOGRAM KERNEL);
		MATRIX income_1990--income_1995 ;
RUN;



***********family slopes:  econ example *************;

 proc sort data=econ_longform;
   by cohort family_id;
 
 Proc GLM data=econ_longform noprint;
   by cohort family_id;
   model income = year / solution;
   ODS output ParameterEstimates=income_slopes;

 proc print data=income_slopes(obs=10);
   
 data income_slopes1;
   set income_slopes;
   if parameter = "year";

  proc print data=income_slopes1(obs=5);

  Proc GLM data=income_slopes1;
    class cohort;
    model estimate = cohort;
    lsmeans cohort / stderr pdiff;
 run; quit;

