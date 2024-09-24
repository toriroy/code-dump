* This example uses statements for the analysis of a randomized block with two treatment factors occurring in a 
factorial structure. The data, from Neter, Wasserman, and Kutner (1990, p. 941), are from an experiment 
examining the effects of codeine and acupuncture on post-operative dental pain in male subjects. Both 
treatment factors have two levels. 
* factor 1: The codeine levels are a codeine capsule or a sugar capsule. 
* factor 2: The acupuncture levels are two inactive acupuncture points or two active acupuncture points. 
There are four distinct treatment combinations due to the factorial treatment structure. The 32 subjects are 
assigned to eight blocks of four subjects each based on an assessment of pain tolerance.

The data for the analysis are balanced, so PROC ANOVA is used. The data are as follows:	;

   
   title1 'Randomized Complete Block With Two Factors';
   data Pain;
      input PainLevel Codeine Acupuncture Relief @@;
      datalines;
   1 1 1 0.0  1 2 1 0.5  1 1 2 0.6  1 2 2 1.2
   2 1 1 0.3  2 2 1 0.6  2 1 2 0.7  2 2 2 1.3
   3 1 1 0.4  3 2 1 0.8  3 1 2 0.8  3 2 2 1.6
   4 1 1 0.4  4 2 1 0.7  4 1 2 0.9  4 2 2 1.5
   5 1 1 0.6  5 2 1 1.0  5 1 2 1.5  5 2 2 1.9
   6 1 1 0.9  6 2 1 1.4  6 1 2 1.6  6 2 2 2.3
   7 1 1 1.0  7 2 1 1.8  7 1 2 1.7  7 2 2 2.1
   8 1 1 1.2  8 2 1 1.7  8 1 2 1.6  8 2 2 2.4
   ;

   * ignoring block leads to 8 replications per treatment;
ods graphics on;
proc glm data=pain;
class Codeine Acupuncture ;
model relief= Codeine|Acupuncture;
run;
ods graphics off;

* accounting for block leads to 1 replications per treatment;
ods graphics on;
proc glm data=pain;
class PainLevel Codeine Acupuncture;
model relief=PainLevel Codeine|Acupuncture;
run;
ods graphics off;
