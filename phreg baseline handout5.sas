data Myeloma;
         input Time VStatus LogBUN HGB Platelet Age LogWBC Frac
               LogPBM Protein SCalc;
         label Time='Survival Time'
               VStatus='0=Alive 1=Dead';
         datalines;
       1.25  1  2.2175   9.4  1  67  3.6628  1  1.9542  12  10
       1.25  1  1.9395  12.0  1  38  3.9868  1  1.9542  20  18
       2.00  1  1.5185   9.8  1  81  3.8751  1  2.0000   2  15
       2.00  1  1.7482  11.3  0  75  3.8062  1  1.2553   0  12
       2.00  1  1.3010   5.1  0  57  3.7243  1  2.0000   3   9
       3.00  1  1.5441   6.7  1  46  4.4757  0  1.9345  12  10
       5.00  1  2.2355  10.1  1  50  4.9542  1  1.6628   4   9
       5.00  1  1.6812   6.5  1  74  3.7324  0  1.7324   5   9
       6.00  1  1.3617   9.0  1  77  3.5441  0  1.4624   1   8
       6.00  1  2.1139  10.2  0  70  3.5441  1  1.3617   1   8
       6.00  1  1.1139   9.7  1  60  3.5185  1  1.3979   0  10
       6.00  1  1.4150  10.4  1  67  3.9294  1  1.6902   0   8
       7.00  1  1.9777   9.5  1  48  3.3617  1  1.5682   5  10
       7.00  1  1.0414   5.1  0  61  3.7324  1  2.0000   1  10
       7.00  1  1.1761  11.4  1  53  3.7243  1  1.5185   1  13
       9.00  1  1.7243   8.2  1  55  3.7993  1  1.7404   0  12
      11.00  1  1.1139  14.0  1  61  3.8808  1  1.2788   0  10
      11.00  1  1.2304  12.0  1  43  3.7709  1  1.1761   1   9
      11.00  1  1.3010  13.2  1  65  3.7993  1  1.8195   1  10
      11.00  1  1.5682   7.5  1  70  3.8865  0  1.6721   0  12
      11.00  1  1.0792   9.6  1  51  3.5051  1  1.9031   0   9
      13.00  1  0.7782   5.5  0  60  3.5798  1  1.3979   2  10
      14.00  1  1.3979  14.6  1  66  3.7243  1  1.2553   2  10
      15.00  1  1.6021  10.6  1  70  3.6902  1  1.4314   0  11
      16.00  1  1.3424   9.0  1  48  3.9345  1  2.0000   0  10
      16.00  1  1.3222   8.8  1  62  3.6990  1  0.6990  17  10
      17.00  1  1.2304  10.0  1  53  3.8808  1  1.4472   4   9
      17.00  1  1.5911  11.2  1  68  3.4314  0  1.6128   1  10
      18.00  1  1.4472   7.5  1  65  3.5682  0  0.9031   7   8
      19.00  1  1.0792  14.4  1  51  3.9191  1  2.0000   6  15
      19.00  1  1.2553   7.5  0  60  3.7924  1  1.9294   5   9
      24.00  1  1.3010  14.6  1  56  4.0899  1  0.4771   0   9
      25.00  1  1.0000  12.4  1  67  3.8195  1  1.6435   0  10
      26.00  1  1.2304  11.2  1  49  3.6021  1  2.0000  27  11
      32.00  1  1.3222  10.6  1  46  3.6990  1  1.6335   1   9
      35.00  1  1.1139   7.0  0  48  3.6532  1  1.1761   4  10
      37.00  1  1.6021  11.0  1  63  3.9542  0  1.2041   7   9
      41.00  1  1.0000  10.2  1  69  3.4771  1  1.4771   6  10
      41.00  1  1.1461   5.0  1  70  3.5185  1  1.3424   0   9
      51.00  1  1.5682   7.7  0  74  3.4150  1  1.0414   4  13
      52.00  1  1.0000  10.1  1  60  3.8573  1  1.6532   4  10
      54.00  1  1.2553   9.0  1  49  3.7243  1  1.6990   2  10
      58.00  1  1.2041  12.1  1  42  3.6990  1  1.5798  22  10
      66.00  1  1.4472   6.6  1  59  3.7853  1  1.8195   0   9
      67.00  1  1.3222  12.8  1  52  3.6435  1  1.0414   1  10
      88.00  1  1.1761  10.6  1  47  3.5563  0  1.7559  21   9
      89.00  1  1.3222  14.0  1  63  3.6532  1  1.6232   1   9
      92.00  1  1.4314  11.0  1  58  4.0755  1  1.4150   4  11
       4.00  0  1.9542  10.2  1  59  4.0453  0  0.7782  12  10
       4.00  0  1.9243  10.0  1  49  3.9590  0  1.6232   0  13
       7.00  0  1.1139  12.4  1  48  3.7993  1  1.8573   0  10
       7.00  0  1.5315  10.2  1  81  3.5911  0  1.8808   0  11
       8.00  0  1.0792   9.9  1  57  3.8325  1  1.6532   0   8
      12.00  0  1.1461  11.6  1  46  3.6435  0  1.1461   0   7
      11.00  0  1.6128  14.0  1  60  3.7324  1  1.8451   3   9
      12.00  0  1.3979   8.8  1  66  3.8388  1  1.3617   0   9
      13.00  0  1.6628   4.9  0  71  3.6435  0  1.7924   0   9
      16.00  0  1.1461  13.0  1  55  3.8573  0  0.9031   0   9
      19.00  0  1.3222  13.0  1  59  3.7709  1  2.0000   1  10
      19.00  0  1.3222  10.8  1  69  3.8808  1  1.5185   0  10
      28.00  0  1.2304   7.3  1  82  3.7482  1  1.6721   0   9
      41.00  0  1.7559  12.8  1  72  3.7243  1  1.4472   1   9
      53.00  0  1.1139  12.0  1  66  3.6128  1  2.0000   1  11
      57.00  0  1.2553  12.5  1  66  3.9685  0  1.9542   0  11
      77.00  0  1.0792  14.0  1  60  3.6812  0  0.9542   0  12
      ;
/* LogBUN and HGB were identified as the most important prognostic 
	  factors for the myeloma data. Suppose you are interested in 
	  obtaining the survivor function estimates for the following 
	  two realizations of LogBUN and HGB, which are saved in a SAS
	  data set called Inrisks. 
*/

data Inrisks; 
      input LogBUN HGB; 
      datalines; 
   1.00 10.0 
   1.80 12.0 
   ;

/*In the BASELINE statement, you specify the name of the data set 
   (COVARIATE=Inrisk) that contains the various sets of explanatory 
   variable values and the name of the output SAS data set (OUT=Pred1)
   that contains the survivor function estimates. The option SURVIVAL=S 
   puts the variable S containing the survivor function estimates in the
   output data set Pred1. Similarly, the options LOWER=S_lower and 
   UPPER=S_upper put the variables S_lower and S_upper in Pred1; these 
   variables contain, respectively, the lower and upper 95% confidence 
   limits for the survival. The NOPRINT option in the PROC PHREG statement 
   suppresses the displayed output.  NOTE: we could add the option /nomean
   in the baseline statement to suppress the printing of the mean values
   of logBUN and HGB.
*/ 
proc phreg data=Myeloma noprint; 
      model Time*VStatus(0)=LogBUN HGB; 
      baseline covariates=Inrisks out=Pred1 survival=S 
               lower=S_lower upper=S_upper; 
   run; 
   proc print data=Pred1; 
   run;

data Pred1; 
      set Pred1; 
      if      LogBUN= 1.0 and HGB=10.0 then Pattern=1; 
      else if LogBUN= 1.8 and HGB=12.0 then Pattern=2; 
      else                                  Pattern=3; 
 
   legend1 label=none shape=symbol(3, .8) 
      value=(f=swiss h=.8 'LogBUN=1.00 HGB=10.0' 
             'LogBUN=1.80  HGB=12.0' 'LogBUN=1.39 HGB=10.2'); 
   axis1 label=(h=1 f=swiss a=90) minor=(n=1); 
   axis2 label=(h=1 f=swiss 'Survival Time in Months') minor=(n=4);


 
   proc gplot data=Pred1; 
      plot S*Time=Pattern / legend=legend1 vaxis=axis1  
                            haxis=axis2    ; 
      symbol1 interpol=stepLJ h=1 v=square  c=black; 
      symbol2 interpol=stepLJ h=1 v=diamond c=black; 
      symbol3 interpol=stepLJ h=1 v=circle  c=black; 
      title1 f=swiss h=1.5 j=c 'Myeloma Study'; 
      footnote h=.8 f=duplex 
         'LogBUN=1.39 and HGB=10.2 correspond to the sample means'; 
   run;


