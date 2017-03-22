DEFINE  SELECTION `python select-advertiser.py` ship('select-advertiser.py');

%default out ''
%default rewrite '/projects/qrw/ruiqiang/GreedySelection-click//clickfeaturscore//thresholdcut/'
%default advertiser '/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201512050000/normal-advertiser'
%default MaxNumBidterm

rewrite = load '$rewrite' using PigStorage('\t','-noschema') as (q:chararray, r:chararray,score:double) ;

adv = load '$advertiser' using PigStorage('\t','-noschema') as (b:chararray, a:chararray, g:chararray, bid:double);

advjoin = join rewrite by r, adv by b ;

advjoin = foreach advjoin generate rewrite::q as q:chararray, rewrite::r as r:chararray, adv::a as a:chararray, rewrite::score as score:double, 
			   adv::bid as bid:double, rewrite::score*adv::bid as relbid:double ; 

topbid = foreach (group advjoin by q) {
	tmp = TOP($MaxNumBidterm,5,advjoin) ;  --high bid
        generate flatten(tmp) ;
}

topbid = group topbid by q parallel 1000 ;

topbid = foreach topbid generate group, BagToTuple($1) ;


diversifybidterm = stream topbid through SELECTION as (q:chararray, r:chararray, cscore:double, bid:double) ;

diversifybidterm = order diversifybidterm by q, cscore DESC ;

rmf $out ;
store  diversifybidterm into '$out/rewrites' using  PigStorage('\t','-noschema') ;


qrytoqlas1 = foreach out generate $0 as (q:chararray) ;
qrytoqlas2 = foreach out generate $1 as (q:chararray) ;
qrytoqlas = union qrytoqlas1,qrytoqlas2 ;
qrytoqlas = distinct qrytoqlas ;
qrytoqlas = order qrytoqlas by $0 ;

store qrytoqlas into '$out/qlasqueries' using PigStorage('\t') ;
