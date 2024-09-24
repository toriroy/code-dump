filename aaa 'C:\Users\vr02477\Desktop\gbcs.dat';
data main;
infile aaa;
input id diagdate recdate deathdate age menopause hormone size grade nodes prog_recp estrg_recp rectime censrec survtime censdead;

proc phreg data = main;
model rectime*censrec(0) = age menopause hormone size grade nodes prog_recp estrg_recp;
run;

