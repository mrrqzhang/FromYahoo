
%default qbertInput 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/cb_qb/fd/BROAD/mobile/nonqbertquad/part*' 
%default smtInput '/projects/qrw/ruiqiang/Gemini/smtrewrite_trv/decode-quadfreedom/toprewrite'
%default out '/projects/qrw/ruiqiang/Gemini/smtrewrite_trv/decode-quadfreedom/fandnf'

A = load 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/cb_qb/fd/BROAD/mobile/nonqbertquad/part*' using PigStorage('\t','-noschema') ;
A = foreach A generate $0 as query:chararray, $3 as rewrite:chararray ;

A = distinct A ;

B = load '$smtInput' using PigStorage('\t','-noschema') ;
B = foreach B generate $0 as query:chararray, $1 as rewrite:chararray ;


C = cogroup A by (query, rewrite) outer, B by (query,rewrite) outer;


FOUND = filter C by  IsEmpty(A)==false and IsEmpty(B)==false ;
FOUND = foreach FOUND generate flatten(group) ;

NON = filter C by IsEmpty(B)==true and IsEmpty(A)==false ;
NON = foreach NON generate flatten(group) ;
 

 
rmf $out
store FOUND into '$out/found' using PigStorage('\t','-noschema') ;
store NON into '$out/nonfound' using PigStorage('\t','-noschema') ;


