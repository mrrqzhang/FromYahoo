REGISTER smt_udf.py USING jython AS pyudf ;

%default out /projects/qrw/ruiqiang/temp2
-- %default out temp

click = load '/projects/qrw/ruiqiang/temp/*' using PigStorage('\t','-noschema') as (q:chararray, f:chararray) ;

-- click = load 'a.1' using PigStorage('\t','-noschema') as (q:chararray, f:chararray) ;

rewriteorg = load '/projects/qrw/ruiqiang/Gemini/smtrewrite_rtl/decode-rtl-minroot/domainfreetoprewriter/part*' using PigStorage('\t','-noschema') ;

-- rewrite = load 'a.2' using PigStorage('\t','-noschema') ;

rewriteorg = foreach rewriteorg generate (chararray)$0 as q:chararray, (chararray)$1 as r:chararray, (chararray)$2 as value:float  ;

rewrite = join rewriteorg by q, click by q ;

rewrite = foreach rewrite generate rewriteorg::q as q:chararray, rewriteorg::r as r:chararray, click::f as f:chararray, rewriteorg::value as value:chararray ;

rewrite = join rewrite by r, click by q ;

rewrite = foreach rewrite generate rewrite::q, rewrite::r, rewrite::f  as qf:chararray, click::f as rf:chararray, rewrite::value ;

rewrite = foreach rewrite generate q,r, value, pyudf.numerical_cosine(qf, rf) as score:float ;


remn = cogroup rewriteorg by (q,r) OUTER, rewrite by (q,r) OUTER;

remn = filter remn by IsEmpty(rewrite)==true ; 

remn = foreach remn generate flatten(rewriteorg) ; 

rewrite = order rewrite by q, score DESC ;

rmf $out
store rewrite into '$out/rewrite' using  PigStorage('\t','-noschema') ; 

store remn into '$out/remn' using  PigStorage('\t','-noschema') ;

