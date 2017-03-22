%default qrwroot 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/' ;
%default fullbidterm 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/all_bid_terms/201508260000.bz2/' ;
%default out 'temp' ;


qrw = load '$qrwroot'  using PigStorage('\t', '-noschema') as (query:chararray,  rw:chararray,  score:double) ; 

toprw = foreach (group qrw by query parallel 200 ) {
         tmp = TOP(1,2,qrw) ;
         generate flatten(tmp) as (query:chararray,  rewrite:chararray,  score:double), (double)0 as bid:double ;
}

bt = load '$fullbidterm' using PigStorage('\t','-noschema') ; -- as (bt:chararray,bid:double) ;
-- bt = filter bt by $1 matches '.*BROAD.*' ;
bt = foreach bt generate (chararray)$0 as bt:chararray, (double)$4 as bid:double ;


J = join qrw by rw, bt by bt  USING 'skewed' parallel 2000 ;



J = foreach J generate $0 as query:chararray, $1 as rewrite:chararray, $2 as score:double, $4 as bid:double ;

J = union toprw, J ;
J = foreach (group J by (query,rewrite) parallel 200 ) {
        tmp = TOP(1, 3, J) ;
        generate flatten(tmp) as (query:chararray,  rw:chararray,  score:double, bid:double) ;
}
   

J = order J by query, score DESC ;

rmf $out ;

store J into '$out' using PigStorage('\t','-noschema') ;
