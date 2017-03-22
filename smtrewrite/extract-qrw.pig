-- extract smt translation and convert the output to a new format

%default input '/tmp/cb_nctr/ruiqiang/mosesdecode/travel_nb1000/part*' ;
%default out '/tmp/cb_nctr/ruiqiang/queryadgroup/qrw' ; 

%default NumTopNRewrite '10000' ;


SmtTranslations = load '$input' using PigStorage('|', '-noschema') ;
Rewrite = foreach SmtTranslations generate TRIM($0) as query:chararray, TRIM($3) as rw:chararray, (double)TRIM($9) as score:double ;


-- RewriteGrp = group Rewrite by (query,rw) parallel 2000 ;
-- may have duplicate (qry, rewrite) pair due to multiple translation models
BestQryRewrite = foreach (group Rewrite by (query,rw) parallel 2000 ) {
   tmp = TOP(1,2,Rewrite) ;
   generate flatten(tmp) as  (query:chararray,  rw:chararray,  score:double) ;
}

-- output only top 2000 rewrites

-- BestQryRewriteGrp = group BestQryRewrite by query parallel 2000 ;
BestRewrite = foreach (group BestQryRewrite by query parallel 2000) {
    tmp = TOP($NumTopNRewrite,2,BestQryRewrite) ;
    generate flatten(tmp) as  (query:chararray,  rw:chararray,  score:double) ;
}

BestRewrite = order BestRewrite by query,score DESC parallel 100 ;

store BestRewrite into '$out' using PigStorage('\t','-schema') ;

