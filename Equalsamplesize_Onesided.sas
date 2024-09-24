
/************************************************************************************************************************

								Continous Variable -- Equal Sample Size & One Sided Test

*************************************************************************************************************************/
/* Calculate the power from Sample size */
proc power;
      twosamplemeans
         groupmeans   = (100 103) 
         stddev       = 10
         power        = .
		 sides = 1
         ntotal       = 60;
   run;


   /* Calculate the power from Sample size */
proc power;
      twosamplemeans
         groupmeans   = (100 103) 
         stddev       = 10
         power        = 0.8
		 sides = 1
         ntotal       = . ;
   run;


   /* Calculate the Sample Size with Different Power Combination*/
    proc power;
      twosamplemeans
         groupmeans   = (100 103) (100 104) (100 105)
         stddev       = 10
         power        = 0.8 0.85 0.9 0.95
		 sides = 1
         ntotal       = .;
   run;

/************************************************************************************************************************

								Binary Variable -- Equal Sample Size & One Sided Test

*************************************************************************************************************************/

/* Calculate the Sample Size with Different Power Combination*/
proc power; 
  twosamplefreq test=pchi 
  groupproportions = (.5 .5) 
  nullproportiondiff = 0.10
  power = .80
  sides = 1
  npergroup =.;
run;

/* Calculate the Sample Size with Different Power Combination*/
proc power; 
  twosamplefreq test=pchi 
  groupproportions = (.5 .5) 
  nullproportiondiff = 0.10 0.2 0.3
  power = .80 0.85 0.9 .95
  sides = 1
  npergroup =.;
run;
