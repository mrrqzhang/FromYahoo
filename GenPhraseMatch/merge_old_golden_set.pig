%default input '/tmp/data_for_hong_new/'
%default golden '/projects/qrw/ruiqiang/DirForPhraseGolden/phrasematchgolenset.txt'
%default out ''

REGISTER /homes/ruiqiang/pythonlib/myfunc.py USING jython AS pyudf ;


GoldenSet = load '$golden' using PigStorage('\t','-noschema') as (query:chararray, phrase:chararray) ;

GoldenSetFlat = foreach GoldenSet generate query, flatten(pyudf.tokenize(phrase,'_')) as phrase:chararray ;

NewPhrase = load '$input' using PigStorage('\t','-noschema') ;


NewPhrase = foreach NewPhrase generate (chararray)$0 as query:chararray, (chararray)$1 as phrase:chararray ;

NewPhrase = foreach NewPhrase generate query, flatten(pyudf.tokenize(phrase,'_')) as phrase:chararray ;

QueryPhrase = union NewPhrase, GoldenSetFlat ;
QueryPhrase = distinct QueryPhrase ;

TopRewriteGroup = group QueryPhrase  by query ;
GoldenFormat = foreach TopRewriteGroup generate group, flatten(pyudf.join($1,'_')) ;

rmf $out ;

store GoldenFormat into '$out' ;



