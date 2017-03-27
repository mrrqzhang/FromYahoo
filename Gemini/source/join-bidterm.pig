-- Google = load 'hdfs://phazonred-nn1.red.ygrid.yahoo.com:8020/user/cb_qb/query_biddedterm/input/query_biddedterm_map.csv.broad' ;
-- Google = load 'hdfs://phazonred-nn1.red.ygrid.yahoo.com:8020/user/cb_qb/query_biddedterm/sqr/*.csv' using PigStorage(',') ;
-- Google = load 'hdfs://phazonred-nn1.red.ygrid.yahoo.com:8020/user/cb_qb/query_biddedterm/sqr_norm_after_spell_check/sqr_norm_with_spell_check.txt' ;
-- Google = foreach Google generate (chararray)$0 as type:chararray,LOWER((chararray)$1) as query:chararray, LOWER((chararray)$2) as bidterm:chararray ;

-- Google = foreach Google generate (chararray)$0 as type:chararray,(chararray)$1 as query:chararray, REPLACE((chararray)$2,'\\+','')  as bidterm:chararray ;


-- Google = filter Google by type == 'broad' ;

Google = load 'google-key-words.txt' ;

Google = foreach Google generate (chararray)$0 as query:chararray, REPLACE((chararray)$1,'\\+','')  as bidterm:chararray ;


Bidterm = load '/projects/qrw/ruiqiang/Gemini/AllBidTerms/fullbidterms/normal-advertiser' ;
Bidterm = foreach Bidterm generate  (chararray)$0 as bidterm:chararray ;
Bidterm = distinct Bidterm ;

JoinGoogle = join Bidterm by (bidterm) ,Google by (bidterm);

JoinGoogle = foreach JoinGoogle generate  (chararray)$1 as query:chararray, (chararray)$2 as bidterm:chararray ;


rmf /projects/qrw/ruiqiang/googlekeyword/smtmatch/bidtermonly ;
store JoinGoogle into '/projects/qrw/ruiqiang/googlekeyword/smtmatch/bidtermonly' ;



