LIBNAME D XPORT 'C:\Users\royv\Desktop\NHANES\P_DEMO.XPT';
LIBNAME F XPORT 'C:\Users\royv\Desktop\NHANES\P_FOLATE.XPT';
LIBNAME L XPORT 'C:\Users\royv\Desktop\NHANES\P_LUX.XPT';
LIBNAME H XPORT 'C:\Users\royv\Desktop\NHANES\P_MCQ.XPT';
LIBNAME OUT 'C:\Users\royv\Desktop\NHANESII';
DATA OUT.test;
   MERGE D.P_DEMO
         F.P_FOLATE
		 L.P_LUX
		 H.P_MCQ;
   BY SEQN;
   RUN;


