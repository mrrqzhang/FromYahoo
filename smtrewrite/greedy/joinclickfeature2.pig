REGISTER smt_udf.py USING jython AS pyudf ;

%default out ''
%default input ''
%default clickroot ''
%default threshold '0.8'
%default topn '80'

ClickFeature = load '$clickroot' using PigStorage('\t','-noschema') as (q:chararray, f:chararray) ;

RewriteInput = load '$input' using PigStorage('\t','-noschema') ;

RewriteInput = foreach RewriteInput generate (chararray)$0 as q:chararray, (chararray)$1 as r:chararray   ;

-- RewriteCopy = foreach RewriteInput generate (chararray)$0 as q:chararray, (chararray)$1 as r:chararray ;
r1 = foreach RewriteInput generate $0 as q:chararray;
r2 = foreach RewriteInput generate $1 as q:chararray;

-- total rewrites
ra = union r1, r2  ;

ra = distinct ra ;

ClickFeatureUsed = join ra by q, ClickFeature by q parallel 2000 ;
ClickFeatureUsed = foreach ClickFeatureUsed generate $1 as q:chararray, $2 as f:chararray ;

QueryFeature = join RewriteInput by q, ClickFeatureUsed by q parallel 2000 ;

QueryFeature = foreach QueryFeature generate RewriteInput::q as q:chararray, RewriteInput::r as r:chararray, ClickFeatureUsed::f as f:chararray ;


RewriteFeature = join QueryFeature by r, ClickFeatureUsed by q parallel 8000;

RewriteFeature = foreach RewriteFeature generate QueryFeature::q, QueryFeature::r, QueryFeature::f  as qf:chararray, ClickFeatureUsed::f as rf:chararray ;

RewriteFeature = foreach RewriteFeature generate q,r,  pyudf.numerical_cosine(qf, rf) as score:double ;


RewriteFeature = order RewriteFeature by q, score DESC ;


rmf $out
store  RewriteFeature into '$out/full' using  PigStorage('\t','-noschema') ; 



rewrite_cut = filter RewriteFeature by score >= $threshold ;

rewrite_cut = foreach (group rewrite_cut by q ) {
              tmp = TOP ($topn,2,rewrite_cut) ;
              generate flatten(tmp) ;
}

rewrite_cut = order rewrite_cut by q, score DESC ;
store  rewrite_cut into '$out/thresholdcut' using  PigStorage('\t','-noschema') ;

