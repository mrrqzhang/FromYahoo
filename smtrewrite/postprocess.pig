DEFINE  POSTPROCESS `python postprocess.py` ship('postprocess.py'); 



%default input ''
%default out  ''


A = load '$input' using PigStorage('\t','-noschema') as (q:chararray, r:chararray, score:float, cs:float) ;

B = stream A through POSTPROCESS as (q:chararray, r:chararray, score:float, cs:float) ;

B = order B by q, score DESC ;

rmf $out;
store B into '$out' using PigStorage('\t','-noschema') ;
