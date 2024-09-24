proc factex; 
factors block / nlev=7;       
output out=blocks      
       block nvals=(1 2 3 4 5 6 7 ); 
run; 
factors trt / nlev=4;         
output out=rcbd             
       designrep=blocks       
       randomize (1312)          
       trt cvals=('A' 'B' 'B' 'A'); 
run; 
 
proc print data=rcbd; 
title "Allocation schedule for Lyrica";
run;
