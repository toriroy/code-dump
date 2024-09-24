filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch2\2009\whas100.dat';
data main;
infile aaa;
input id ent$ end$ stay time censor age gender bmi;
ods html ;/*path="e:\survival data"
         gpath="e:\survival data";*/
ods graphics on;
proc lifetest data=main method=pl;
time time*censor(0);
strata gender/test=(all); /* default is logrank, wilcoxon and likelihood only*/
survival out=out confband=all stderr plots=survival (cl  hwb);
title1 "Product limit survival analysis for WHAS100 data";
run;
ods graphics off;
ods html close;

