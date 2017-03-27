%default out 'temp' ;

Google = load 'hdfs://phazonred-nn1.red.ygrid.yahoo.com:8020/user/cb_qb/query_biddedterm/sqr_norm_after_spell_check/sqr_norm_with_spell_check.txt' ;

Google = foreach Google generate (chararray)$0 as type:chararray,(chararray)$1 as query:chararray, REPLACE((chararray)$2,'\\+','')  as bidterm:chararray ;

Google = filter Google by type == 'phrase' ;

Google = foreach Google generate (chararray)$1 as query:chararray, REPLACE((chararray)$2,'\\+','')  as bidterm:chararray ;

Google = distinct Google ;

rmf $out ;
store Google into '$out/google' ;

Phrase = load '/user/cb_quad/gbdtFeatureDump.txt';

Phrase = foreach Phrase generate (chararray)$0 as query:chararray, (chararray)$1 as bidterm:chararray, (double)$2 as score:double ;

JoinPhraseGoogle = join Phrase by (query,bidterm) ,Google by (query,bidterm);

JoinPhraseGoogle = foreach JoinPhraseGoogle generate  (chararray)$0 as query:chararray, (chararray)$1 as bidterm:chararray, (double)$2 as score:double ;

store JoinPhraseGoogle into '$out/joinphrasegoogle' ;

HighScorePhrase = filter JoinPhraseGoogle by score>0.59 ;


store HighScorePhrase into '$out/highscore' ;


