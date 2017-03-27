--Google = load 'hdfs://phazonred-nn1.red.ygrid.yahoo.com:8020/user/cb_qb/query_biddedterm/input/query_biddedterm_map.csv.broad' ;
--Google = foreach Google generate (chararray)$0 as query:chararray, (chararray)$1 as bidterm:chararray ;

--Google = load 'hdfs://phazonred-nn1.red.ygrid.yahoo.com:8020/user/cb_qb/query_biddedterm/sqr_norm_after_spell_check/sqr_norm_with_spell_check.txt' ;

--Google = foreach Google generate (chararray)$0 as type:chararray,(chararray)$1 as query:chararray, REPLACE((chararray)$2,'\\+','')  as bidterm:chararray ;

--Google = filter Google by type == 'broad' ;

-- Google = foreach Google generate (chararray)$1 as query:chararray, REPLACE((chararray)$2,'\\+','')  as bidterm:chararray ;


Google = load 'google-key-words.txt' ;

Google = foreach Google generate (chararray)$0 as query:chararray, REPLACE((chararray)$1,'\\+','')  as bidterm:chararray ;


-- SMT = load '/projects/qrw/ruiqiang/Gemini/AllBidTerms/greedy/clickfeaturscore//thresholdcut';

SMT = load '/projects/qrw/ruiqiang/Gemini/AllBidTerms/greedy/qrw/part*' ;
SMT = foreach SMT generate (chararray)$0 as query:chararray, (chararray)$1 as bidterm:chararray;

JoinSmtGoogle = join SMT by (query,bidterm) ,Google by (query,bidterm) USING 'replicated';

JoinSmtGoogle = foreach JoinSmtGoogle generate  (chararray)$0 as query:chararray, (chararray)$1 as bidterm:chararray ;


rmf /projects/qrw/ruiqiang/googlekeyword/smtmatch/joinqrwquerybidterm ;
store JoinSmtGoogle into '/projects/qrw/ruiqiang/googlekeyword/smtmatch/joinqrwquerybidterm' ;



