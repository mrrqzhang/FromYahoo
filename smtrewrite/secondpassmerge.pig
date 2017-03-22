
%default first '' ;
%default second '' ;
%default out '' ;

A = load '$first' using PigStorage('\t') as (q:chararray, r:chararray, score:float, cs:float) ;

B = load '$second' using PigStorage('\t') as (q:chararray, r:chararray, score:float, cs:float) ;

M = union A, B ;

M = foreach (group M by ($0,$1)) generate flatten(group) as (q:chararray, r:chararray), MAX(M.$2) as score:float, MAX(M.$3) as cs:float ;

M = order M by q, score DESC ;

rmf $out ;
store M into '$out' using  PigStorage('\t') ;
