filename aaa 'C:\Users\vr02477\Desktop\whas500.dat';
data main;
infile aaa;
input id ent$ end$ stay time censor age gender bmi;
ods html ;/*path="e:\survival data"
         gpath="e:\survival data";*/
ods graphics on;
proc lifetest data=main method=pl;
time time*censor(0);
strata gender/test=(all); 
survival out=out confband=all stderr plots=all;
title1 "Plots all";
run;
ods graphics off;


filename aaa 'C:\Users\vr02477\Desktop\whas500.dat';
data main;
infile aaa;
input id ent$ end$ stay time censor age gender bmi;
ods html ;/*path="e:\survival data"
         gpath="e:\survival data";*/
ods graphics on;
proc lifetest data=main method=pl;
time time*censor(0);
strata gender/test=(all); 
survival out=out confband=all stderr plots=survival (cl  hwb);
title1 "Product limit survival analysis for WHAS500 data";
run;
ods graphics off;

filename aaa 'C:\Users\vr02477\Desktop\whas500.dat';
data main;
infile aaa;
input id ent$ end$ stay time censor age gender bmi;
ods html ;/*path="e:\survival data"
         gpath="e:\survival data";*/
ods graphics on;
proc lifetest data=main method=pl;
time time*censor(0);
strata gender/test=(all);
survival out=out confband=all stderr plots=(ls,lls,survival (cl  hwb
         epb));
title2 "Product limit survival analysis for WHAS500 data by Gender";
run;
ods graphics off;


filename aaa 'C:\Users\vr02477\Desktop\whas500.dat';
data main;
infile aaa;
input id ent$ end$ stay time censor age gender bmi;
ods html ;/*path="e:\survival data"
         gpath="e:\survival data";*/
ods graphics on;
proc lifetest data=main method=pl plots=(c s ls lls);
time time*censor(0);
strata gender/test=(logrank tarone peto wilcoxon);
title1 "Product limit survival analysis for WHAS data 4 group";
run;
proc lifetest data=main method=pl;
time time*censor(0);
strata gender/test=(logrank tarone peto wilcoxon)trend;
title1 "Product limit for WHAS data 4 group SAS trend test";
run;
ods graphics off;



filename aaa 'C:\Users\vr02477\Desktop\whas500.dat';
data main;
infile aaa;
input id ent$ end$ stay time censor age gender bmi;
proc lifetest data=main method=pl plots=(c s ls lls);
time time*censor(0);
survival out=out confband=all stderr;
title1 "Product limit survival analysis for WHAS500 data";
run;
proc print data=out;
run;
symbol1 l=1 v=square c=black interpol=stepJ;
symbol2 l=2 v=circle c=black interpol=stepJ;
symbol3 l=2 v=circle c=black interpol=stepJ;
axis1 label=('survival' );

proc gplot data=out;
plot  survival*time sdf_ucl*time sdf_lcl*time/overlay vaxis=axis1;
title2 "survival function with individual confidence limits";
run;
proc gplot data=out;
plot  survival*time hw_ucl*time hw_lcl*time/overlay vaxis=axis1;
title2 "survival function with Hall Wellner confidence limits";
run;
proc gplot data=out;
plot  survival*time ep_ucl*time ep_lcl*time/overlay vaxis=axis1;
title2 "survival function with equal precision confidence limits";
run;
ods html close;
