proc power;
      twosamplemeans
         groupmeans   = (30 31) 
         stddev       = 3
         power        = .8
		 ntotal       = .;
   run;

/****************************************************************

                          One Sample test

/*****************************************************************/

   proc power;
      onesamplemeans
         mean   = 8
         ntotal = 150
         stddev = 40
         power  = .;
   run;

      proc power;
      onesamplemeans
         mean   = 5 10
         ntotal = 150
         stddev =  30 50
         power  = .;
      plot x=n min=100 max=200;
   run;

 
