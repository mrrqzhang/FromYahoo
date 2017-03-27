%default input ''
%default out ''

Q = load '$input' using PigStorage('\t','-noschema') ;

Q = foreach Q generate (chararray)$0 as q:chararray, (chararray)$1 as r:chararray ;
Q = distinct Q ;

B = load '/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201512050000/normal-advertiser' using PigStorage('\t','-noschema') ;
B = foreach B generate (chararray)$0 as b:chararray, (chararray)$1 as adv:chararray, (chararray)$2 as adgroup:chararray ;

C =  foreach (cogroup Q by r inner, B by b inner) generate flatten(Q.q) as b:chararray, flatten(B.(adv,adgroup)) as ( adv:chararray, adgroup:chararray) ;

C1 = foreach C generate b, adv ;
C1 = distinct C1 ;
C1 = foreach (group C1 by b) generate flatten(group) as b, COUNT(C1) as advcnt:long ;

C2 = foreach C generate b,adgroup ;
C2 = distinct C2 ;
C2 = foreach (group C2 by b) generate flatten(group) as b, COUNT(C2) as adgroupcnt:long ;

C = foreach (group C1 by b, C2 by b) generate group as b, flatten(C1.advcnt) as advcnt:long, flatten(C2.adgroupcnt) as adgroupcnt:long ;


rmf $out ;

store C into '$out' using PigStorage('\t') ;
