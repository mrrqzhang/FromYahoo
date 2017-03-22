REGISTER  /home/ruiqiang/pigscripts/udf-pylibs.py USING jython AS pyudf;
--- REGISTER /home/jyj/mylib/hdstreamlib.py USING jython AS pyudf;

set default_parallel 1000;
SET pig.noSplitCombination true;
%default final_parallel 100 

%default croot clickedcrawledfeats
%default froot QuicklinkFeatures

%default topk 1000

%default input '$croot/clicked-immchildren.sr.top-$topk.dedup'    -- this one only has score

%default targetf 'AbfData/ctr-by-domviews'

%default logweight True

%default out '$froot/domqlwttgt'

%default out2 '$froot/urls'

%default wtindex 5
%default tgtindex 10


ret = load '$input' using PigStorage('\t','-noschema');
ret2 = load '$targetf' using PigStorage('\t','-noschema');

ret = foreach ret generate pyudf.Normalize($0)  , pyudf.Normalize($1)  ,  
  (((SUBSTRING((chararray)$0,0,7) == 'http://' ) or (SUBSTRING((chararray)$0,0,8) == 'https://' ))?(chararray)$0 : CONCAT('http://', $0)) ,      (((SUBSTRING((chararray)$1,0,7) == 'http://') or (SUBSTRING((chararray)$1,0,8) == 'https://')) ? (chararray)$1 : CONCAT('http://', $1)) , $2 .. ;

ret2 = foreach ret2 generate pyudf.Normalize($0) , pyudf.Normalize($1) , 
  (((SUBSTRING((chararray)$0,0,7) == 'http://' ) or (SUBSTRING((chararray)$0,0,8) == 'https://' ))?(chararray)$0 : CONCAT('http://', $0)) ,    
  (((SUBSTRING((chararray)$1,0,7) == 'http://') or (SUBSTRING((chararray)$1,0,8) == 'https://')) ? (chararray)$1 : CONCAT('http://', $1)) , $2 .. ;

ret2 = filter ret2 by $$tgtindex is not null ;

x = cogroup ret2 by ($0,$1) inner, ret by ($0,$1) ;

ret31 = foreach x {
        tmp = TOP(1,$tgtindex,ret2);
        generate flatten( ret2.($2,$3) )  as (domain, ql), flatten(tmp.($$wtindex,$$tgtindex)) as (weight, target);
}

--- wired codes due to some exact same domain-urls with trailing space, but has no features.
ret32 = foreach x {
        tmp = TOP(1,$tgtindex,ret2);
        generate flatten( ( IsEmpty(ret) ? ret2.($2,$3) : ret.($2,$3))) as (domain, ql), flatten(tmp.($$wtindex,$$tgtindex)) as (weight, target);
}

ret3 = union ret31, ret32 ;

ret3 = distinct ret3 parallel 100;



ret3 = foreach ret3 generate domain as domain, ql as ql, ( $logweight==True ? pyudf.piglog(weight) : pyudf.pigdouble(weight) ) as weight, target as target ;

ret3 = filter ret3 by weight>0 and target is not null  ;

ret3 = order ret3 by domain, target DESC parallel 100;

store ret3 into '$out' using PigStorage('\t','-schema');

ret4 = foreach ret3 generate domain as url;

ret5 = foreach ret3 generate ql as url;

ret6 = union ret4, ret5 ;

ret6 = group ret6 by url ; 

ret6 = foreach ret6 generate group as url ; 


ret6 = order ret6 by url parallel $final_parallel;

store ret6 into '$out2' using PigStorage('\t','-schema');

