-- %default golden '/projects/qrw/ruiqiang/DirForPhraseGolden/phrasematchgolenset.txt'
%default golden '/projects/qrw/ruiqiang/PhraseGenGoldenSet2/combined/part*'
-- %default out '/projects/qrw/ruiqiang/phrasegoldenset_vcanon_smt'
%default out '/projects/qrw/ruiqiang/temp'

REGISTER /homes/ruiqiang/pythonlib/myfunc.py USING jython AS pyudf ;

DEFINE QuerySplit  `python query-split.py` ship('query-split.py'); ;

GoldenSet = load '$golden' using PigStorage('\t','-noschema') as (query:chararray, phrase:chararray) ;

GoldenSetFlat = foreach GoldenSet generate query, flatten(pyudf.tokenize(phrase,'_')) as phrase:chararray ;



post_canon = FOREACH GoldenSetFlat GENERATE 
    query as queryorig,
    phrase as phraseorig,
    (chararray)com.yahoo.curveball.common.GetVariantCanon('./canon/canon', query) as queryVariant,
    (chararray)com.yahoo.curveball.common.GetVariantCanon('./canon/canon', phrase) as phraseVariant;

QueryPhrase = foreach post_canon generate queryVariant, phraseVariant ;

QueryPhrase = distinct QueryPhrase ;

TopRewriteGroup = group QueryPhrase  by queryVariant ;
GoldenFormat = foreach TopRewriteGroup generate group, flatten(pyudf.join($1,'_')) ;

rmf $out ;
STORE post_canon into  '$out/postcanon' USING PigStorage();

STORE GoldenFormat into  '$out/final' USING PigStorage();
