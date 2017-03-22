A = load '/projects/qrw/ruiqiang/PhraseGenGoldenSet2/phrasengram/part*' ;
ngram = foreach A generate (chararray)$1 as phrase:chararray ;
ngram = foreach (group ngram by phrase) generate group as phrase:chararray, COUNT(ngram) as count:long ;
ngram = order ngram by count DESC ;

rmf '/projects/qrw/ruiqiang/PhraseGenGoldenSet2/ngramcount' ;

store ngram into '/projects/qrw/ruiqiang/PhraseGenGoldenSet2/ngramcount' ;

