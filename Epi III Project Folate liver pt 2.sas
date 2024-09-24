proc import datafile="C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\combdata.csv"
        out=comb
        dbms=csv
        replace;
     getnames=yes;
run;

proc print data=work.comb;
run;
