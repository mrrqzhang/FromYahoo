%default bt ''
%default ecpm ''
%default out 'temp' ;

B = load '$bt' using PigStorage('\t') as (q:chararray, r:chararray, score:float, bid:float) ;

E = load '$ecpm' using PigStorage('\t') as (r:chararray, ecpm:float, cnt:long) ;

M = cogroup B by r outer, E by r outer ;

N1 = foreach (filter M by IsEmpty(E) == false) generate flatten (B) as (q:chararray, r:chararray, score:float, bid:float),flatten(E.(ecpm,cnt)) as (ecpm:float, cnt:long) ;

N2 = foreach (filter M by IsEmpty(E) == true) generate flatten (B) as (q:chararray, r:chararray, score:float, bid:float), (float)0 as ecpm:float, (float)0 as cnt:long ;

N = union N1, N2 ;

rmf $out; 

store N into '$out' using PigStorage('\t') ;


