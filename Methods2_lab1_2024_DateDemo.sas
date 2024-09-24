/*Methods 2 LAB: date formatting example*/ 
/* NAME: Yao Xin             */
/* Date created: 01/10/2024  */
/* Last revised: 01/10/2024  */
/* Dataset: yellowstone, input below */


data FamilyDutton_1;
   infile datalines delimiter=',' ; 
   length name relation $25;
   input name $ relation $ dob :date9. sex $;
   
   datalines;                      
JOHN,Grandfather,'02Nov1953'd,M
BETH,Daughter,'18Jul1984'd,F
JAMIE,Son,'12May1979'd,M
RIP,Employee,'13Aug1975'd,M
KASEY,Son,'24Apr1990'd,M
MONICA,Daughter-in-Law,'02Feb1992'd,F
TATE,Grandson,'10Jan2012'd,M
;
run;

proc contents data=familydutton_1;
run;

/*format DOB into date */
DATA FAMILYDUTTON_2;	
SET FAMILYDUTTON_1;
  FORMAT DOB mmddyy10.;
RUN;

proc contents data=familydutton_2;
run;
proc print data=familydutton_2;
run;


/*how old are they today?*/
data familydutton_3;
SET familydutton_2;
	date0 = today(); 
	date1 = mdy(1, 10, 2024);
	/*  format date0 date1 mmddyy10.;  */
	num_of_years = intck("year",DOB, date0);
run;

proc contents data=familydutton_3;run;
proc print data=familydutton_3;







