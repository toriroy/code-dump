/************************************************************************************************************************

								Continous Variable -- UnEqual Sample Size & Two Sided Test

*************************************************************************************************************************/

/* Calculate the power from Sample size */
proc power;
      twosamplemeans
         groupmeans   = (100 103) 
         stddev       = 10
         power        = .
		 groupweights = (1 2)
         ntotal       = 60;
   run;


   /* Calculate the power from Sample size */
proc power;
      twosamplemeans
         groupmeans   = (100 103) 
         stddev       = 10
         power        = 0.8
		 groupweights = (1 2)
         ntotal       = . ;
   run;


   /* Calculate the Sample Size with Different Power Combination*/
    proc power;
      twosamplemeans
         groupmeans   = (100 103) (100 104) (100 105)
         stddev       = 10
         power        = 0.8 0.85 0.9 0.95
		 groupweights = (1 2)
         ntotal       = .;
   run;


   /************************************************************************************************************************

								Binary Variable -- UnEqual Sample Size & Two Sided Test

*************************************************************************************************************************/
/* Calculate the Sample Size with Different Power Combination*/

proc power; 
  twosamplefreq test=pchi
  groupproportions  = (0.50 0.50)   
  nullproportiondiff  = 0.1
  groupweights = (1 2)
  power  = .80 
  ntotal= .;
run;

proc power; 
  twosamplefreq test=pchi
  groupproportions  = (0.50 0.50)   
  nullproportiondiff  = 0.1
  groupweights = 1| 1 2 3
  power  = .80 .90
  ntotal= .;
run;


/* Calculate the Sample Size with Different Power Combination*/
proc power; 
  twosamplefreq test=pchi 
  groupproportions = (.5 .5) 
  nullproportiondiff = 0.10 0.2 0.3
  power = .80 0.85 0.9 .95
  groupweights = (1 2)
  npergroup =.;
run;
