
*Example 76.3 Ordinal Logistic Regression: 
Consider a study of the effects on taste of various cheese additives. Researchers tested four cheese additives and obtained52 response ratings for each additive. 
Each response was measured on a scale of nine categories ranging from strong dislike(1) to excellent taste (9). 
The data, given in McCullagh and Nelder (1989, p. 175) in the form of a two-way frequency table of additive by rating, are saved in the data set Cheese 
by using the following program. The variable y contains the response rating. The variable Additive specifies the cheese additive (1, 2, 3, or 4). 
The variable freq gives the frequency with which each additive received each rating. ;

*pr{(y>1)/pr(y<=1)}=B_01 + B_1*Add where B_1 is a vector comparing A1,A2,A3 to A4;
.;
.;
*pr{(y>8)/pr(y<=8)}=B_08 + B_8*Add;
* POM assumes that B_j is the same across the several outcome categories and interpertation is the odds of low ordered categories to high ordred;
* The  "Additive 1 vs 4" odds ratio says that the first additive has 5.017 times the odds of receiving a lower score than the fourth additive 
  that is, the first additive is 5.017 times more likely than the fourth additive to receive a lower score.;
data Cheese;
   do Additive = 1 to 4;
      do y = 1 to 9;
         input freq @@;
         output;
      end;
   end;
   label y='Taste Rating';
   datalines;
0  0  1  7  8  8 19  8  1
6  9 12 11  7  6  1  0  0
1  1  6  8 23  7  5  1  0
0  0  0  1  3  7 14 16 11
;

ods graphics on;
proc logistic data=Cheese plots(only)=oddsratio(range=clip); *the range of the confidence limits is truncated by the RANGE=CLIP option, 
so you can see that "1" is not contained in any of the intervals. ;
   freq freq;
   class Additive (param=ref ref='4');
   model y=Additive / covb nooddsratio;
   oddsratio Additive;
   *effectplot / ;
   title 'Multiple Response Cheese Tasting Experiment';
run;

proc logistic data=Cheese plots(only)=oddsratio(range=clip); *the range of the confidence limits is truncated by the RANGE=CLIP option, 
so you can see that "1" is not contained in any of the intervals. ;
   freq freq;
   class Additive (param=ref ref='4');
   model y=Additive / covb ; *removing nooddsratio;
   oddsratio Additive;
   *effectplot / ;
   title 'Multiple Response Cheese Tasting Experiment';
run;
* Multinomial logit;
ods graphics on;
proc logistic data=Cheese plots(only)=oddsratio;
   freq freq;
   class Additive (ref='4')/param=ref;
   model y=Additive / link=glogit covb nooddsratio;
   oddsratio Additive;
   *effectplot / ;
   title 'Multiple Response Cheese Tasting Experiment';
run;
ods graphics off;

*Example 48.4 Ordinal Model for Multinomial Data:
This example illustrates how you can use the GENMOD procedure to fit a model to data measured on an ordinal scale. The followingstatements create a SAS data set 
called Icecream. The data set contains the results of a hypothetical taste test of three brands of ice cream. The three brands are ratedfor taste 
on a five-point scale from very good (vg) to very bad (vb). An analysis is performed to assess the differences inthe ratings of the three brands. 
The variable taste contains the ratings, and the variable brand contains the brands tested. The variable count contains the number of testers rating 
each brand in each category. The following statements create the Icecream data set: ;

data Icecream;
   input count brand$ taste$;
   datalines;
70  ice1 vg
71  ice1 g
151 ice1 m
30  ice1 b
46  ice1 vb
20  ice2 vg
36  ice2 g
130 ice2 m
74  ice2 b
70  ice2 vb
50  ice3 vg
55  ice3 g
140 ice3 m
52  ice3 b
50  ice3 vb
;

proc genmod data=Icecream rorder=data;
   freq count;
   class brand;
   model taste = brand / dist=multinomial
                         link=cumlogit
                         aggregate=brand
                         type1;
   estimate 'LogOR12' brand 1 -1 0 / exp;
   estimate 'LogOR13' brand 1  0  -1 / exp;
   estimate 'LogOR23' brand 0  1  -1 / exp;
run;


* Example 76.18 Partial Proportional Odds Model: 
Cameron and Trivedi (1998, p. 68) studied the number of doctor visits from the Australian Health Survey 1977–78. 
The data set contains a dependentvariable, 
dvisits, which contains the number of doctor visits in the past two weeks (0, 1, or 2, where 2 represents two or more visits) and
the following explanatory variables: 
*sex, which indicates whether the patient is female age, which contains the patient’s age in years divided by 100; 
*income, which contains the patient’s annual income (in units of $10,000); 
*levyplus, which indicates whether the patient has private health insurance; 
*freepoor, which indicates that the patient has free government health insurance due to low income; 
*freerepa, which indicates that the patient has free government health insurance for other reasons; 
*illness, which contains the number of illnesses in the past two weeks; 
*actdays, which contains the number of days the illness caused reduced activity; 
*hscore, which is a questionnaire score; 
*chcond1, which indicates a chronic condition that does not limit activity; 
*and chcond2, which indicates a chronic condition that limits activity. 
;
*reading data from sashelp library;

*The following steps list all the datasets that are available;
* https://support.sas.com/documentation/onlinedoc/stat/151/sashelp.pdf;
ods select none; 
proc contents data=sashelp._all_; 
ods output members=m; 
run; ods select all; 
proc print; where memtype='DATA'; 
run;
data docvisit;
set sashelp.docvisit;
run;

*The following statements fit a proportional odds model to this data: ;
proc logistic data=docvisit;
   model dvisits = sex age agesq income levyplus freepoor freerepa illness actdays hscore chcond1 chcond2;
run;

*The following statements fit the general model by relaxing the POM assumption with the unequalslopes statment: ;
proc logistic data=docvisit;
   model dvisits = sex age agesq income levyplus
                   freepoor freerepa illness actdays hscore
                   chcond1 chcond2 / unequalslopes;
   sex:      test sex_0     =sex_1;
   age:      test age_0     =age_1;
   agesq:    test agesq_0   =agesq_1;
   income:   test income_0  =income_1;
   levyplus: test levyplus_0=levyplus_1;
   freepoor: test freepoor_0=freepoor_1;
   freerepa: test freerepa_0=freerepa_1;
   illness:  test illness_0 =illness_1;
   actdays:  test actdays_0 =actdays_1;
   hscore:   test hscore_0  =hscore_1;
   chcond1:  test chcond1_0 =chcond1_1;
   chcond2:  test chcond2_0 =chcond2_1;
run;

*fitting this partial proportional odds model ;
proc logistic data=docvisit;
   model dvisits= sex age agesq income levyplus freepoor
         freerepa illness actdays hscore chcond1 chcond2
   / unequalslopes=(actdays agesq income);
run;

*You can also specify the following code to let stepwise selection determine which parameters have unequal slopes:; 
proc logistic data=docvisit;
   model dvisits= sex age agesq income levyplus freepoor
         freerepa illness actdays hscore chcond1 chcond2
   / equalslopes unequalslopes selection=stepwise details;
run;


