REGISTER smt_udf.py USING jython AS pyudf ;

%default out ''
%default input ''
%default clickroot ''



click = load '$clickroot' using PigStorage('\t','-noschema') as (q:chararray, f:chararray) ;

rewriteorg = load '$input' using PigStorage('\t','-noschema') ;

rewriteorg = foreach rewriteorg generate (chararray)$0 as q:chararray, (chararray)$1 as r:chararray, ( $2 is not null ? (float)$2 : 0 ) as value:float  ;

rewriteorg = distinct rewriteorg ;

rewrite = foreach rewriteorg generate (chararray)$0 as q:chararray, (chararray)$1 as r:chararray ;
r1 = foreach rewrite generate $0 as q:chararray;
r2 = foreach rewrite generate $1 as q:chararray;
ra = union r1, r2  ;

ra = distinct ra ;

click = join ra by q, click by q ;
click = foreach click generate $1 as q:chararray, $2 as f:chararray ;

rewrite = join rewriteorg by q, click by q ;

rewrite = foreach rewrite generate rewriteorg::q as q:chararray, rewriteorg::r as r:chararray, click::f as f:chararray, rewriteorg::value as value:chararray ;

rewrite = join rewrite by r, click by q ;

rewrite = foreach rewrite generate rewrite::q, rewrite::r, rewrite::f  as qf:chararray, click::f as rf:chararray, rewrite::value ;

rewrite = foreach rewrite generate q,r, value, pyudf.numerical_cosine(qf, rf) as score:double ;


rewrite = order rewrite by q, score DESC ;


rmf $out
store  rewrite into '$out/full' using  PigStorage('\t','-noschema') ; 



rewrite_cut = filter rewrite by score >= 0.8 ;

rewrite_cut = foreach (group rewrite_cut by q ) {
              tmp = TOP (50,2,rewrite_cut) ;
              generate flatten(tmp) ;
}

rewrite_cut = order rewrite_cut by q, value DESC ;
store  rewrite_cut into '$out/thresholdcut' using  PigStorage('\t','-noschema') ;

