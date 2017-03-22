
%default wholeset '/tmp/cb_nctr/ruiqiang/mosesdecode/travel_nb1000/part*' ;
%default orig '/tmp/cb_nctr/ruiqiang/smtrewrite/input.txt'
%default rewrite '/tmp/cb_nctr/ruiqiang/smtrewrite/decode/toprewrite'
%default out '/tmp/cb_nctr/ruiqiang/smtrewrite/decode/zeromatch' ; 

orig = load '$orig' using PigStorage('\t', '-noschema') as query:chararray ;
rewrite = load '$rewrite' using PigStorage('\t', '-noschema') as query:chararray ;
rewrite = foreach rewrite generate $0 as query:chararray ;
rewrite = distinct rewrite ;

NI = cogroup orig by query, rewrite by query ;
NI = filter NI by IsEmpty(rewrite) ;
NI = foreach NI generate group as query:chararray ;

B = load '$wholeset' using PigStorage('|', '-noschema') ;
B = foreach B generate TRIM($0) as query:chararray, TRIM($3) as rw:chararray, (double)TRIM($9) as score:double ;

C = join NI by query, B by query parallel 100 ;

C = foreach C generate $0 as query:chararray, $2 as rw:chararray, $3 as score:double ; 

C = group C by (query,rw) parallel 100 ;
C = foreach C {
    tmp = TOP(1,2,C) ;
    generate flatten(tmp) as  (query:chararray,  rw:chararray,  score:double) ;
}

C = group C by query parallel 100 ;

C = foreach C {
    tmp = TOP(500,2,C) ;
    generate flatten(tmp) as  (query:chararray,  rw:chararray,  score:double) ;
 }


C = order C by query, score DESC;

D = filter C by score > -100 ;
D = foreach D generate $0 as query:chararray ;
D = distinct D ;

C = union D, C ;

store C into '$out' using PigStorage('\t','-schema') ;

