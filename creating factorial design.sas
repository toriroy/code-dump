data copter;
do BW=3.25 to 4.25 by .5;
 do WL=4 to 6 by 1;
 output;
 end;
 end;
 run;

data copter;
do BW=3.25 to 4.25 by .5;
 do WL=4 to 6 by 1;	
  do rep=1 to 2;
 u=ranun(0);
 output;
 end;
 end;
 end;
 run;

 proc sort data=copter;
 by u;
 run;

 data list;
 set copter;
 experiment=_n_;

 proc print data=list;
 var BW WL;
 id experiment;
 run;
* 3x3 design;
 proc factex;
 factors BW WL/nlev=3;
 model estimate=(BW|WL); *interaction model;
 output out=copter2 randomize designrep=2 BW nvals=(3.25 3.75 4.25) WL nvals=(4 5 6);
 run;

 proc print data=copter2;
 run;
* 2 x 2 desgin;
 proc factex;
 factors A B/nlev=2;
 model estimate=(A|B);
 output out=twotwo randomize designrep=2 A cvals=('a1' 'a2') B nvals=(1 2);
 run;

 proc print data=twotwo;
 run;
proc factex;
 factors A B/nlev=3;
 model estimate=(A|B);
 output out=twothree randomize designrep=2 A cvals=('a1' 'a2' 'a3') B nvals=(1 2);
 run;

 proc print data=twothree;
 run;

 *Now, suppose two machines (A and B) are used to complete the experiment, with four runs being performed on 
 each machine. As there is the possibility that the machine affects the part finish, you should consider machine 
 as a block factor and account for the block effect in assigning the runs to machines. ;

proc factex; 
       factors Speed FeedRate Angle; 
       blocks nblocks=2; 
       model resolution=max; 
       output out=BlockDesign 
	   randomize designrep=4
         Speed    nvals=(300 500) 
         FeedRate nvals=(20 30) 
         Angle    nvals=(6 8) 
         blockname=Machine cvals=('A' 'B'); 
    run; 
  
    proc print; 
    run;
