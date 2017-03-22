REGISTER smt_udf.py USING jython AS pyudf ;

-- w1th=0, w2th=-0.3 w3th=-0.6 w4th=-0.9

%default second ''
%default first ''
%default out 'temp' ;

sndqrw = load '$second' using PigStorage('\t') as (q:chararray, r:chararray, score:float, bid:float) ;

fstqrw = load '$first' using PigStorage('\t') as (q:chararray, r:chararray, score:float, bid:float) ;

fstqrw = foreach fstqrw generate q,r, score ;

combine = join fstqrw by r, sndqrw by q ;

combine = foreach combine generate fstqrw::q as q, sndqrw::r as r, fstqrw::score+sndqrw::score as score, sndqrw::bid as bid ;

-- self = foreach combine generate q as q:chararray, q as r:chararray, (float)0 as score:float, (float)0 as bid:float ;
self = foreach combine generate q as q:chararray, q as r:chararray, (long)pyudf.wordcount(q) as cnt:long ;

self = distinct self ;

self = foreach self generate q, r, ( cnt == 1 ? (float)0 : (cnt==2 ? (float)-0.3 : (cnt==3 ? (float)-0.6 : (float)-0.9 ))) as  score:float, (float)0 as bid:float ;
 
combine = union combine, self ;

combine = foreach (group combine by ($0,$1) ) generate flatten(group) as (q:chararray,  r:chararray), MAX(combine.$2) as score:float, MAX(combine.$3) as bid:float ;

combine = order combine by q, score DESC ;

rmf $out ;

store combine into '$out' using PigStorage('\t', '-schema') ;


