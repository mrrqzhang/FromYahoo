DEFINE EXTRACT `python extract-match.py` ship('extract-match.py'); ;

A = load 'hdfs://nitroblue-nn1.blue.ygrid.yahoo.com:8020/projects/qrw/ruiqiang/Gemini/smtrewrite_trv/train/smt_model/part*' using PigStorage('\t','-noschema') ;

A = stream A through EXTRACT ;
A = order A by $5 ASC parallel 400 ;

rmf temp;
store A into 'temp' using PigStorage('\t','-noschema') ;
