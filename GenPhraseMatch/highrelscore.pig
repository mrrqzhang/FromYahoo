REGISTER /homes/ruiqiang/pythonlib/myfunc.py USING jython AS pyudf ;

%default bt ''
%default ecpm ''
%default out 'temp' ;
%default topn '50'
%default MinScore '0.9'


-- bidterm
B = load '$bt' using PigStorage('\t') ;

B = foreach B generate (chararray)$0 as q:chararray, (chararray)$1 as r:chararray, (float)$2 as score:float ;

N = filter B by score>=$MinScore ;


TopRewrite = foreach (group N by $0) {
    tmp = TOP($topn,2,N) ;
    generate flatten(tmp) as (q:chararray, r:chararray, score:float) ;
}

TopRewrite = distinct TopRewrite ;
TopRewrite = order TopRewrite by q, score DESC ;
rmf $out; 

store TopRewrite into '$out/withscore' using PigStorage('\t') ;

TopRewriteGroup = group (foreach TopRewrite generate q,r) by q ;
GoldenFormat = foreach TopRewriteGroup generate group, flatten(pyudf.join($1,'_')) ;
 
store GoldenFormat into '$out/goldenset' ;


Query = foreach TopRewrite generate q ;
QueryCnt = foreach (group Query by q) generate group as q:chararray, COUNT(Query) as cnt:long ;
store QueryCnt into '$out/log' ;



