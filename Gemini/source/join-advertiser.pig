DEFINE  SELECTION `python select-advertiser.py` ship('select-advertiser.py');

%default out ''
%default rewrite '/projects/qrw/ruiqiang/GreedySelection-click//clickfeaturscore//thresholdcut/'
%default advertiser '/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201512050000/normal-advertiser'

rewrite = load '$rewrite' using PigStorage('\t','-noschema') as (q:chararray, r:chararray,score:double) ;

adv = load '$advertiser' using PigStorage('\t','-noschema') as (b:chararray, a:chararray, g:chararray, bid:double);

out = join rewrite by r, adv by b ;

out = foreach out generate rewrite::q as q:chararray, rewrite::r as r:chararray, adv::a as a:chararray, rewrite::score as score:double, 
			   adv::bid as bid:double, rewrite::score*adv::bid as relbid:double ; 

out = foreach (group out by q) {
	tmp = TOP(5000,5,out) ;
        generate flatten(tmp) ;
}

out = group out by q parallel 1000 ;

out = foreach out generate group, BagToTuple($1) ;


out = stream out through SELECTION as (q:chararray, r:chararray, cscore:double, bid:double) ;

out = order out by q, cscore DESC ;

rmf $out ;
store  out into '$out/rewrites' using  PigStorage('\t','-noschema') ;


D1 = foreach out generate $0 as (q:chararray) ;
D2 = foreach out generate $1 as (q:chararray) ;
D = union D1,D2 ;
D = distinct D ;
D = order D by $0 ;

store D into '$out/qlasqueries' using PigStorage('\t') ;
