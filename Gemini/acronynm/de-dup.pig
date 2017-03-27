DEFINE EXTRACT `python de-dup.py` ship('de-dup.py'); ;

%default out /projects/qrw/ruiqiang/Gemini/w2v-dedup

A = load 'hdfs://nitroblue-nn1.blue.ygrid.yahoo.com:8020/projects/qrw/ruiqiang/Gemini/w2v-test/part*' using PigStorage('\t','-noschema') ;



A = stream A through EXTRACT as (key:chararray, value:chararray, smt:double, w2v:double);

B = foreach A generate value as (key2:chararray) ;

B = distinct B ;

B = foreach (join A by key, B by key2) generate $0 as (key2:chararray) ;


B = distinct B ;

D = cogroup A by key outer, B by key2 outer parallel 200 ;

D = filter D by IsEmpty(B) ;

D = foreach D generate flatten(A.$1) ;

D = union B, D ;


A = foreach A generate value as key:chararray, smt as smt:double, w2v as w2v:double ;

A = foreach (group A by key) generate group as key:chararray, MIN(A.smt) as smt:double, MAX(A.w2v) as w2v:double ;
 
G = cogroup D by $0 inner,A by $0 inner parallel 200 ;

G = foreach G generate flatten(A) as (key:chararray, smt:double, w2v:double) ;






G = foreach G generate REPLACE($0,'_','\t'), $1,$2  ;

G = distinct G ;

rmf $out;
store G into '$out/G' using PigStorage('\t','-noschema') ;
