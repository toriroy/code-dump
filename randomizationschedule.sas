data one;
do I=1 to 20;
patient =I;
random=ranuni(2028);
if random lt 0.5 then treatment= 'A';
else treatment='B';
output;
end;
proc print; id patient; var treatment;
title "Allocation schedule for Tegaserod";
run;