DEFINE QuerySplit  `python query-split.py` ship('query-split.py'); ;

phraseTable = load '/projects/qrw/ruiqiang/GeminiPhraseMatch/queryphrasescoring/thresholdcut/' ;
phraseTable = foreach phraseTable generate (chararray)$0 as q:chararray, (chararray)$1 as r:chararray ;

tailQuery = load 'tail2Mquery.txt' as q:chararray ;
tailQuery = stream tailQuery through QuerySplit as (q:chararray, p:chararray) ;
rmf temp ;

store tailQuery into 'temp/A' ;
tailQuery = load 'temp/A' as (q:chararray, p:chararray) ; 

JoinRes = join tailQuery by p, phraseTable by q parallel 1000 ;


JoinRes = foreach JoinRes generate tailQuery::q as q:chararray ;

JoinRes = group JoinRes by q ;

JoinRes = foreach JoinRes generate group as q:chararray, COUNT($1) as count:long ;

JoinRes = order JoinRes by count ;

store JoinRes into 'temp/B' ;

cnt = foreach JoinRes generate count ;
cnt = group cnt by count ;
cnt = foreach cnt generate group as count:long, COUNT($1) as count2:long ;
cnt = order cnt by count ;

store cnt into 'temp/C' ;



