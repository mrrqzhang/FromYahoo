
QuadTbl = load '/tmp/data_for_hong_new/' using PigStorage('\t','-schema') ;
QryEcpm = foreach QuadTbl generate 
	phraseCanonicalBidTerm as bidterm:chararray,
	bidMatchType as matchType:chararray,
	ecpm as ecpm:double ; 

-- QryEcpm = filter QryEcpm by ( matchType ==  'PHRASE' ) ;

QryEcpm = filter QryEcpm by ( matchType ==  'BROAD' ) ;
rmf  '/projects/qrw/ruiqiang/PhraseMatch/PhraseBidtermEcpmAllMatchType' ;


QryEcpmPmGrouped = foreach (group QryEcpm by bidterm) generate group as bidterm:chararray, SUM(QryEcpm.ecpm)/COUNT(QryEcpm) as ecpm:double ;

QryEcpmPmGrouped = order QryEcpmPmGrouped by ecpm DESC ;
store QryEcpmPmGrouped into '/projects/qrw/ruiqiang/PhraseMatch/PhraseBidtermEcpmAllMatchType' ;

