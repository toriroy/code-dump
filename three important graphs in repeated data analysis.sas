
* THREE PLOTS FOR TWO WAY RM DATA *********
*ROW DATA;
ODS graphics on;
goptions reset=global ;
symbol i=join  r=10 ;  
axis1 label=( "HR") c=black;
axis2 label=( "B") c=black;
legend1 label=none ;

Proc gplot data=RM;
	plot Y*B=S/overlay legend=legend1  haxis=axis2 vaxis=axis1;
Run;
ods graphics off;
*MEANS;
proc means data=RM mean ;
class A B;
var Y ;
output out=meanbyB;
run;

Data meanbyB1;
	set meanbyB;
* if month=. or type=. then delete;
	If _stat_ ne "MEAN" then delete;
Run;

ODS graphics on;
goptions colors=(black) reset=global;
symbol1 value=plus interpol=join width=1 c=red line=1;
symbol2  value=x interpol=join width=1 c=blue line=2;
symbol3  value=star interpol=join width=1 c=green line=20;
axis1 label=( "HR") c=black;
axis2 label=( "B") c=black;
legend1 label=none ;

Proc gplot data=meanbyB1;
	plot (Y)*B=A/overlay legend=legend1  haxis=axis2 vaxis=axis1;
Run;
ods graphics off;


*Visualizing correlation patterns graphically;

proc mixed data=RM;
class A B S;
model Y=A|B;
repeated/type=un subject=S(A) sscp rcorr;
ods output covparms=cov;
ods output rcorr=corr;
run;

*The following code sets up the dataset for producing the plot for visualizing correlation patterns;
data times;
do time1=1 to 4;
 do time2=1 to time1;
  dist=time1-time2;
  output;
  end;
  end;
  run;

data covplot;
  merge times cov;
  proc print;
run;

axis1 value=(font=swiss2 h=2) label=(angle=90 f=swiss h=2 'Covariance of between Subj effects');
axis2 value=(font=swiss h=2) label=(f=swiss h=2 'Distance');
legend1 value=(font=swiss h=2) label=(f=swiss h=2 'From Time');
symbol1 color=black interpol=join line=1 value=square;
symbol2 color=black interpol=join line=2 value=circle;
symbol3 color=black interpol=join line=20 value=triangle;
symbol4 color=black interpol=join line=4 value=star;

proc gplot data=covplot;
plot estimate*dist=time2/vaxis=axis1 haxis=axis2 legend=legend1;
run;
