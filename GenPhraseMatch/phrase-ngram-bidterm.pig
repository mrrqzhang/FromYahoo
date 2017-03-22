%default input '/tmp/data_for_hong_new/'
%default golden '/projects/qrw/ruiqiang/DirForPhraseGolden/phrasematchgolenset.txt'
%default out ''

REGISTER /homes/ruiqiang/pythonlib/myfunc.py USING jython AS pyudf ;

DEFINE QuerySplit  `python query-split.py` ship('query-split.py'); ;

GoldenSet = load '$golden' using PigStorage('\t','-noschema') as (query:chararray, phrase:chararray) ;

GoldenSetFlat = foreach GoldenSet generate query, flatten(pyudf.tokenize(phrase,'_')) as phrase:chararray ;

QuadTbl = load '$input' using PigStorage('\t','-noschema') ;
Query = foreach QuadTbl generate (chararray)$0 as query:chararray ;
Query = distinct Query ;
-- generate ngram
QueryPhrase = stream Query through QuerySplit as (q:chararray, p:chararray) ;

QueryPhrase = union QueryPhrase, GoldenSetFlat ;
QueryPhrase = distinct QueryPhrase ;

store QueryPhrase into '$out' ;



