%default input '/tmp/data_for_hong_new/'

%default out ''
DEFINE QuerySplit  `python query-split.py` ship('query-split.py'); ;



QuadTbl = load '$input' using PigStorage('\t','-schema') ;
Query = foreach QuadTbl generate canonicalQuery as query:chararray ;
Query = distinct Query ;
#generate ngram
QueryPhrase = stream Query through QuerySplit as (q:chararray, p:chararray) ;

QueryPhrase = distinct QueryPhrase ;

store QueryPhrase into '$out' ;



