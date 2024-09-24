filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\whas500.dat';
data whas500;
infile aaa;
input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord mitype year admitdate disdate fdate los dstat lenfol fstat;
run;

/*Table 5.10 on page 151 using the whas500 data and the lrtest macro.  */


data table510;
set whas500;
bmi2=(bmi/10)**2;
bmi3=(bmi/10)**3;

/* Creating age interactions */
bmi2age=age*(bmi/10)**2;
bmi3age=age*(bmi/10)**3;
hrage=age*hr;
diasbpage=age*diasbp;
genderage=age*gender;
chfage=age*chf;

/* Creating gender interactions */
bmi2gender=gender*(bmi/10)**2;
bmi3gender=gender*(bmi/10)**3;
hrgender=gender*hr;
diasbpgender=gender*diasbp;
chfgender=gender*chf;

run;

/* With Age Interactions */

%lrtest(table510, lenfol, fstat, bmi2 bmi3 age hr diasbp gender chf, bmi2age bmi3age);
%lrtest(table510, lenfol, fstat, bmi2 bmi3 age hr diasbp gender chf, hrage);
%lrtest(table510, lenfol, fstat, bmi2 bmi3 age hr diasbp gender chf, diasbpage);
%lrtest(table510, lenfol, fstat, bmi2 bmi3 age hr diasbp gender chf, genderage);
%lrtest(table510, lenfol, fstat, bmi2 bmi3 age hr diasbp gender chf, chfage);
/* With Gender Interactions */

%lrtest(table510, lenfol, fstat, bmi2 bmi3 age hr diasbp gender chf, bmi2gender bmi3gender);%lrtest(table510, lenfol, fstat, bmi2 bmi3 age hr diasbp gender chf, hrgender);
%lrtest(table510, lenfol, fstat, bmi2 bmi3 age hr diasbp gender chf, diasbpgender);
%lrtest(table510, lenfol, fstat, bmi2 bmi3 age hr diasbp gender chf, chfgender);
