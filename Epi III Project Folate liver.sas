LIBNAME D XPORT 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_DEMO.XPT';
LIBNAME F XPORT 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_FOLATE.XPT';
LIBNAME L XPORT 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_LUX.XPT';
LIBNAME G XPORT 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_FOLFMS.XPT';
LIBNAME H XPORT 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_MCQ.XPT';
LIBNAME I XPORT 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANES\P_DR2IFF.XPT';
LIBNAME out 'C:\Users\royv\OneDrive - Medical University of South Carolina\Desktop\NHANESII';
DATA OUT.test;
   MERGE D.P_DEMO
         F.P_FOLATE
		 L.P_LUX
		 G.P_FOLFMS
		 H.P_MCQ
		 I.P_DR2IFF;
   BY SEQN;
   RUN;

data out.test;
set folate;
if LBDRFO le '139' then folatecat = 1;
if LBDRFO ge '140' le '310' then folatecat = 2;
if LBDRFO ge '311' le '481' then folatecat = 3;
if LBDRFO ge '482' le '628' then folatecat = 4;
if LBDRFO ge '629' then folatecat = 5;
else folatecat = .;
run;



