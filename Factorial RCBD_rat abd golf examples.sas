
*** Text book examples ***;
* RCB in factorial designs;
/* Example 7 page 127                       */
data bha;
input strain $ bha $ block erod;
datalines;
A/J      Yes  1 18.7
A/J      No   1  7.7
A/J      Yes  2 16.7
A/J      No   2  6.4
129/Ola  Yes  1 17.9
129/Ola  No   1  8.4
129/Ola  Yes  2 14.4
129/Ola  No   2  6.7
NIH      Yes  1 19.2
NIH      No   1  9.8
NIH      Yes  2 12.0
NIH      No   2  8.1
BALB/c   Yes  1 26.3
BALB/c   No   1  9.7
BALB/c   Yes  2 19.8
BALB/c   No   2  6.0
;
proc print; run;
*RCBF;
proc glm data=bha; 
class strain bha block;
model erod=block bha strain bha*strain;
run;
*CRF;
proc glm data=bha; 
class strain bha;
model erod =bha strain bha*strain;
run;

/* Example 8  page 127                      */
ods graphics on;
proc sort data=bha; by bha strain;
proc means noprint; by bha strain; var erod;
  output out=mbha mean=bhamean;
proc sgplot data=mbha;
  series x=bha y=bhamean/group=strain;
  xaxis label='BHA Treated';
  yaxis label='average EROD';
run;
ods graphics off;

* replicated RCB or general RCBD;
/* Example 9  page 129                      */
data rcb;
input id teehgt cdistance;
datalines;
1       1        142.0
1       1        141.8
1       1        153.7
1       1        130.6
1       1        147.8
1       2        142.7
1       2        136.2
1       2        140.2
1       2        143.3
1       2        145.8
1       3        137.8
1       3        159.0
1       3        151.1
1       3        154.1
1       3        135.0
2       1        169.5
2       1        177.0
2       1        169.1
2       1        176.5
2       1        173.8
2       2        185.6
2       2        164.8
2       2        173.9
2       2        191.9
2       2        164.5
2       3        184.7
2       3        183.0
2       3        195.9
2       3        194.4
2       3        182.2
3       1        142.7
3       1        136.2
3       1        140.2
3       1        143.3
3       1        145.8
3       2        137.8
3       2        159.0
3       2        151.1
3       2        154.1
3       2        135.0
3       3        142.0
3       3        141.8
3       3        153.7
3       3        130.6
3       3        147.8
4       1        185.4
4       1        164.8
4       1        173.9
4       1        191.9
4       1        164.5
4       2        184.7
4       2        172.8
4       2        175.8
4       2        184.7
4       2        172.2
4       3        176.0
4       3        177.0
4       3        175.3
4       3        176.5
4       3        173.8
5       1        222.2
5       1        201.9
5       1        192.5
5       1        182.0
5       1        224.8
5       2        197.7
5       2        229.8
5       2        203.3
5       2        214.3
5       2        220.9
5       3        221.8
5       3        240.0
5       3        221.4
5       3        234.9
5       3        213.2
6       1        133.6
6       1        132.6
6       1        135.0
6       1        147.6
6       1        136.7
6       2        145.5
6       2        154.5
6       2        150.5
6       2        137.9
6       2        154.4
6       3        145.9
6       3        146.0
6       3        149.2
6       3        145.2
6       3        147.2
7       1        165.2
7       1        173.2
7       1        174.2
7       1        176.9
7       1        166.4
7       2        178.8
7       2        163.4
7       2        160.2
7       2        160.6
7       2        169.3
7       3        172.8
7       3        183.2
7       3        170.2
7       3        169.6
7       3        169.9
8       1        174.3
8       1        160.1
8       1        162.8
8       1        174.6
8       1        172.6
8       2        184.4
8       2        181.8
8       2        185.0
8       2        192.4
8       2        193.3
8       3        180.6
8       3        172.5
8       3        181.2
8       3        178.4
8       3        167.6
9       1        229.7
9       1        220.7
9       1        240.4
9       1        219.5
9       1        225.6
9       2        241.6
9       2        242.1
9       2        243.4
9       2        240.8
9       2        240.7
9       3        243.3
9       3        242.1
9       3        236.1
9       3        248.3
9       3        240.4
proc glm data=rcb;
  class id teehgt;
  model cdistance=id teehgt id*teehgt;
  test h=teehgt e=id*teehgt;
  lsmeans teehgt/pdiff adjust=tukey e=id*teehgt;
run;


/* Example 10 page 133                  */
proc plan seed=37430;
  factors rows=4 ordered cols=4 ordered / noprint;
  treatments tmts=4 cyclic;
  output out=lsd
  rows cvals=('Week 1' 'Week 2' 'Week 3' 'Week 4') ordered
  cols cvals=('Store 1' 'Store 2' 'Store 3' 'Store 4') random
  tmts nvals=( 1 2 3 4  ) random;
proc print;
run;


/* Example 11 page 134                   */
proc tabulate data=lsd;
  class rows cols;
  var tmts;
  table rows, cols*(tmts*f=8.) / rts=10;
run;


/* Example 12  page 136                  */
data bioeqv;
input subject  period  treat $  auc;
datalines;
1 1 A 1186
1 2 B  642
1 3 C 1183
2 1 B 1135
2 2 C 1305
2 3 A  984
3 1 C  873
3 2 A 1426
3 3 B  1540
proc glm;
  class subject period treat;
  model auc = subject period treat;
  lsmeans treat/ pdiff adjust=tukey;
run;
