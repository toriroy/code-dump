filename aaa 'C:\Documents and Settings\lyu\My Documents\yulili\course\survival data\ch4\2009\gbcs.dat';
data gbcs;
infile aaa;
input id diagdate$ recdate$ deathdate$ age menopause hormone size grade nodes prog_recp estrg_recp rectime censrec time censor;
if hormone=1 then hormone=0;
if hormone=2 then hormone=1;

run;

/*Table 4.16 on page 120 using the gbcs data.  */

ods output covb = covb1;
proc phreg data = gbcs;
model rectime*censrec(0) = hormone nodes hn / covb;
hn = hormone*nodes;
run;
proc print data = covb1;
run;
data _null_;
  set covb1;
  if _n_= 1 then
    call symput('vhormone', hormone);
  if _n_ = 3 then do;
    call symput('vhn', hn);
    call symput('covhn_nodes', hormone);
   end;
run;
* see equation 4.20 on page 112;
data fig44;
  do nodes = 1 to 49 by 2;
   hz = -0.60600 + 0.03820*nodes;
   ul = hz + 1.96*sqrt(&vhormone+ nodes**2*&vhn +2*nodes*&covhn_nodes);
   ll = hz - 1.96*sqrt(&vhormone+ nodes**2*&vhn +2*nodes*&covhn_nodes);
   exphz=exp(hz);
   expul = exp(ul);
   expll =exp(ll);
   output;
  end;
run;

proc print data = fig44 noobs label;
where nodes <= 9;
var nodes exphz expll expul;
label nodes='Nodes' exphz='HR' expll='Lower Limit' expul='Upper Limit';
format exphz f8.2;
format expul expll f8.3;
run;

