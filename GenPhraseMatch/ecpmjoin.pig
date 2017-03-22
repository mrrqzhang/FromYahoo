%default bt ''
%default ecpm ''
%default out 'temp' ;
%default topn '50'
%default MinScore '0.9'


-- bidterm
B = load '$bt' using PigStorage('\t') ;

B = foreach B generate (chararray)$0 as q:chararray, (chararray)$1 as r:chararray, (float)$2 as score:float ;

B = filter B by score>=$MinScore ;

-- ecpm
E = load '$ecpm' using PigStorage('\t'); -- as (r:chararray, ecpm:float, cnt:long) ;
E = foreach E generate (chararray)$0 as r:chararray, (float)$1 as ecpm:float ;

M = cogroup B by r outer, E by r outer ;

N = foreach M  generate flatten (B) as (q:chararray, r:chararray, score:float),flatten(E.(ecpm)) as (ecpm:float) ;


TopRewrite = foreach (group N by $0) {
    tmp = TOP($topn,3,N) ;
    generate flatten(tmp) as (q:chararray, r:chararray, score:float,ecpm:float) ;
}

TopRewrite = distinct TopRewrite ;
TopRewrite = order TopRewrite by q, score DESC ;
rmf $out; 

store TopRewrite into '$out' using PigStorage('\t') ;


rmf $out/log ;
Query = foreach TopRewrite generate q ;
QueryCnt = foreach (group Query by q) generate group as q:chararray, COUNT(Query) as cnt:long ;
store QueryCnt into '$out/log' ;



