REGISTER smt_udf.py USING jython AS pyudf ;

%default out ''
%default input ''
%default clickroot ''

ClickFeature = load '$clickroot' using PigStorage('\t','-noschema') as (q:chararray, f:chararray) ;

QueryInput = load '$input' using PigStorage('\t','-noschema') ;

QueryInput = foreach QueryInput generate (chararray)$0 as q:chararray    ;


ClickFeatureUsed = join QueryInput by q, ClickFeature by q parallel 2000 ;
ClickFeatureUsed = foreach ClickFeatureUsed generate $1 as q:chararray, $2 as f:chararray ;
ClickFeatureUsed = order ClickFeatureUsed by q parallel 1 ;

rmf $out
store  ClickFeatureUsed into '$out' using  PigStorage('\t','-noschema') ; 




