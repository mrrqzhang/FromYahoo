%default out /projects/qrw/ruiqiang/intersection-bidterm-clickfeature 
%default bt '/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/'
%default wlist ''
%default clickfeature '/projects/clickmodel/ckang/usmlr/sim_20150826/query_qvec_out_combined'

A = load '$clickfeature'  using PigStorage('\t') as (q:chararray,f:chararray) ;


B = load '$bt' using PigStorage('\t') ;
B = foreach B generate (chararray)$0 as (q:chararray) ;

B1 = load '$wlist' using PigStorage('\t') ;
B1 = foreach B1 generate (chararray)$0 as (q:chararray) ;

B = union B, B1 ;

B = distinct B ;

C = join A by q, B by $0 parallel 2000 ;

C = foreach C generate A::q as q:chararray, A::f as f:chararray ;


C = order C by q ;

rmf $out ;

store C into '$out' using PigStorage('\t') ;
