define ACRONYNM `python extract-equiv.py` ship('extract-equiv.py');

A = load '/projects/qrw/ruiqiang/Gemini/smtrewrite/train/smt_model/part*'  using PigStorage('\t','-noschema') ;

A = stream A through ACRONYNM as (query:chararray, rw:chararray, fscore:double, bscore:double) ;

A = group A by (query,rw) parallel 200 ;

A = foreach A generate flatten(group) as (query:chararray, rw:chararray), MAX(A.fscore), MAX(A.bscore) ;
store A into 'Gemini/acronynm'  using PigStorage('\t','-noschema') ;
