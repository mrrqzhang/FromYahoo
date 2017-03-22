%default BTMAX 1000000 
%default out ''
%default input '/projects/qrw/ruiqiang/Gemini/AllBidTerms/fullbidterms/normal-advertiser/'

bset = load '$input' as (b:chararray, adv:chararray, ag:chararray, type:chararray, price:double) ;

advertisers = foreach bset generate b as bidterm:chararray, adv as adv:chararray ;
advertisers = distinct advertisers ;
advertisers = foreach (group advertisers by bidterm) generate group as bidterm:chararray, COUNT(advertisers) as cnt:long ;

adgroups = foreach bset generate b as bidterm:chararray, ag as ag:chararray ;
adgroups = distinct adgroups ;
adgroups = foreach (group adgroups by bidterm) generate group as bidterm:chararray, COUNT(adgroups) as cnt:long ;

bset = foreach bset generate b as bidterm:chararray, price as price:double ;
BidtermJoin = join bset by bidterm, advertisers by bidterm, adgroups by bidterm ;
BidtermJoin = foreach BidtermJoin generate bset::bidterm as bidterm:chararray, advertisers::cnt as advcnt:long, adgroups::cnt as agcnt:long, bset::price as price:double ;

BidtermUniq = distinct BidtermJoin ;
BidtermUniq = group BidtermUniq by (bidterm,advcnt,agcnt) ;
BidtermUniq = foreach BidtermUniq generate flatten(group) as (bidterm:chararray,advcnt:long,agcnt:long), MIN(BidtermUniq.price) as minprs:double, MAX(BidtermUniq.price) as maxprs:double  , AVG(BidtermUniq.price) as avgprs:double   ;

btrule1 = filter BidtermUniq by advcnt<=2 ;
btrule2 = filter BidtermUniq by agcnt<=2 ;
btrule3 = order BidtermUniq by advcnt ;
btrule3 = limit btrule3 $BTMAX ;
btrule4 = order BidtermUniq by agcnt ;
btrule4 = limit btrule4 $BTMAX ;

btrule5 = order BidtermUniq by avgprs ;
btrule5 = limit btrule5 $BTMAX ;

btall = union btrule3,btrule4,btrule5 ;
btall = distinct btall ;
btall = order btall by bidterm,advcnt DESC,agcnt DESC,avgprs DESC ;

rmf $out ;
store btall into '$out' ;                                     
 
