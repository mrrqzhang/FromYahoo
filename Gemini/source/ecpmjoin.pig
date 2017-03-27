%default bt ''
%default ecpm ''
%default out 'temp' ;
%default topn '50'

B = load '$bt' using PigStorage('\t') ;

B = foreach B generate (chararray)$0 as q:chararray, (chararray)$1 as r:chararray, (float)$2 as score:float ;

E = load '$ecpm' using PigStorage('\t') as (r:chararray, ecpm:float, cnt:long) ;

M = cogroup B by r outer, E by r outer ;

N1 = foreach (filter M by IsEmpty(E) == false) generate flatten (B) as (q:chararray, r:chararray, score:float),flatten(E.(ecpm,cnt)) as (ecpm:float, cnt:long) ;

N2 = foreach (filter M by IsEmpty(E) == true) generate flatten (B) as (q:chararray, r:chararray, score:float) ; 
N2 = foreach N2 generate q, r, score, (float)(-1.0+score) as ecpm:float, (float)0 as cnt:long ;

N = union N1, N2 ;

N = foreach (group N by $0) {
    tmp = TOP($topn,3,N) ;
    generate flatten(tmp) as (q:chararray, r:chararray, score:float,ecpm:float,cnt:long) ;
}

N = order N by q, score DESC ;
rmf $out; 

store N into '$out' using PigStorage('\t') ;


