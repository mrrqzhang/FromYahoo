/* Set B has priority */
A = load '$input1' USING PigStorage('\t') as (f1:chararray,f2:chararray,f3:chararray);;
B = load '$input2' USING PigStorage('\t') as (f1:chararray,f2:chararray,f3:chararray);;
C = join A by $0 FULL, B by $0;
/* set A/B */
D = filter C by $3 is null;
E = foreach D generate $0,$1,$2;
F = union B, E;
store F into '$output';
