%default out '/projects/qrw/ruiqiang/PhraseMatch/PhraseBidtermEcpm'
%default input '/tmp/data_for_hong_new/' 


QuadTbl = load '$input' using PigStorage('\t','-schema') ;
QryEcpm = foreach QuadTbl generate 
	phraseCanonicalBidTerm as bidterm:chararray,
	bidMatchType as matchType:chararray,
	ecpm as ecpm:double ; 

QryEcpmPhrase = filter QryEcpm by ( matchType ==  'PHRASE' ) ;

-- QryEcpm = filter QryEcpm by ( matchType ==  'BROAD' ) ;
-- rmf  '/projects/qrw/ruiqiang/PhraseMatch/PhraseBidtermEcpmAllMatchType' ;


QryEcpmPmGrouped = foreach (group QryEcpmPhrase by bidterm) generate group as bidterm:chararray, SUM(QryEcpmPhrase.ecpm)/COUNT(QryEcpmPhrase) as ecpm:double ;

QryEcpmPmGrouped = order QryEcpmPmGrouped by ecpm DESC ;
store QryEcpmPmGrouped into '$out' ;

