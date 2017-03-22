
DEFINE WordDeletion `python word-deletion2.py` ship('word-deletion2.py');

%default input 'bdroot'
%default out 'wdroot'

A = load '$input' using PigStorage('\t','-noschema') as (adgid:chararray, query:chararray, rewrite:chararray) ;
A = stream A through WordDeletion as (word:chararray, selfcount:int, delcount:int) ;

A = group A by word parallel 1000 ;

A = foreach A generate group as word:chararray, SUM(A.selfcount) as selfcount:int, SUM(A.delcount) as delcount:int, 
	(1.0-(double)SUM(A.delcount)/(double)SUM(A.selfcount)) as delprob:double ;
 
A  = order A by delprob DESC ;

store A into '$out' using PigStorage('\t','-noschema') ;

