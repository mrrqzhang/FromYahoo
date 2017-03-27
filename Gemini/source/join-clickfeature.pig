Google = load 'google-key-words.txt' ;

Google = foreach Google generate (chararray)$0 as query:chararray, REPLACE((chararray)$1,'\\+','')  as bidterm:chararray ;


clickfeature= load '/projects/qrw/ruiqiang/Gemini/AllBidTerms/greedy/clickfeature' ;
clickfeature = foreach clickfeature generate  (chararray)$0 as bidterm:chararray ;
clickfeature = distinct clickfeature ;

JoinGoogle = join clickfeature by (bidterm) ,Google by (bidterm);

JoinGoogle = foreach JoinGoogle generate  (chararray)$1 as query:chararray, (chararray)$2 as bidterm:chararray ;


rmf /projects/qrw/ruiqiang/googlekeyword/smtmatch/joinfeaturebidterm ;
store JoinGoogle into '/projects/qrw/ruiqiang/googlekeyword/smtmatch/joinfeaturebidterm' ;

JoinGoogle = join clickfeature by (bidterm) ,JoinGoogle by (query);
JoinGoogle = foreach JoinGoogle generate  (chararray)$1 as query:chararray, (chararray)$2 as bidterm:chararray ;
rmf /projects/qrw/ruiqiang/googlekeyword/smtmatch/joinfeaturequery ;
store JoinGoogle into '/projects/qrw/ruiqiang/googlekeyword/smtmatch/joinfeaturequerybidterm' ;



