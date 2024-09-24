proc factex; 
factors block / nlev=5;       
output out=blocks      
       block nvals=(1 2 3 4 5 ); 
run; 
factors trt / nlev=6;         
output out=rcbd             
       designrep=blocks       
       randomize (525)          
       trt cvals=('Red' 'Blue' 'Blue' 'Red' 'Red' 'Blue'); 
run; 
 
proc print data=rcbd; 
title "Allocation schedule for Vesicare";
run;
