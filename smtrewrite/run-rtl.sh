#use binlu's blacklist advertiser and advertiser status=on. Only 286M bidterms
sh suite-smt-rewrite.sh -m onlinetest -q default -s 2.6 -e 2.6  -g 300 -n 1 -b 5000 -d decode-rtl -l 50 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_rtl-nobl -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part* -P  /projects/qrw/ruiqiang/AdvertiserNoBL/rtl_bid_terms//rtl/201511120000/bid_term/part*  -Q /projects/qrw/ruiqiang/AdvertiserNoBL/rtl_bid_terms//rtl/201511120000/bid_term/part* -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/rtl.cb.canon.20150808.txt

#sh suite-smt-rewrite.sh -m onlinetest -q default -s 0 -e 2.6  -g 100 -n 1 -b 5000 -d decode-rtl-advertiser-status-on -l 50 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_rtl-nobl -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_advertiser_status_on/normal-advertiser/part* -P  /projects/qrw/ruiqiang/AdvertiserNoBL/rtl_bid_terms//rtl/201511120000/bid_term/part*  -Q /projects/qrw/ruiqiang/AdvertiserNoBL/rtl_bid_terms//rtl/201511120000/bid_term/part* -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/rtl.cb.canon.20150808.txt

# use 300 number rewrites
#sh suite-smt-rewrite.sh -m onlinetest -q default -s 2.4 -e 2.6  -g 300 -n 1 -b 5000 -d decode-rtl -l 50 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_rtl-nobl -w /projects/qrw/ruiqiang/all_bid_terms_include_blacklist/normal-advertiser/part* -P  /projects/qrw/ruiqiang/AdvertiserNoBL/rtl_bid_terms//rtl/201511120000/bid_term/part*  -Q /projects/qrw/ruiqiang/AdvertiserNoBL/rtl_bid_terms//rtl/201511120000/bid_term/part* -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/rtl.cb.canon.20150808.txt

#train use no BL. decode use all but BL bidterms(700M) 300 training reducer nbest=5000
#sh suite-smt-rewrite.sh -m train -q default -s 4 -e 4  -g 100 -n 300 -b 5000 -d decode-rtl -l 6000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_rtl-nobl -w /projects/qrw/ruiqiang/all_bid_terms_include_blacklist/normal-advertiser/part* -P  /projects/qrw/ruiqiang/AdvertiserNoBL/rtl_bid_terms//rtl/201511120000/bid_term/part*  -Q /projects/qrw/ruiqiang/AdvertiserNoBL/rtl_bid_terms//rtl/201511120000/bid_term/part* -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/rtl.cb.canon.20150808.txt


#sh suite-smt-rewrite.sh -m onlinetest -q default -s 2.5 -e 2.6  -g 50 -n 1 -b 5000 -d decode-rtl-minroot-lm -l 50 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_rtl -w /projects/qrw/ruiqiang/all_bid_terms_with_matchtype/201510120000.bz2/part* -P  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/rtl/201508200000/bid_term/part*  -Q hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/rtl/201508200000/bid_term/part* -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/rtl.cb.canon.20150808.txt


#sh suite-smt-rewrite.sh -m test -q search_mlr -s 3 -e 3  -g 100 -n 300 -b 200 -d decode-rtl -l 6000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_rtl -w /user/ruiqiang/all_bid_terms/201509110000.bz2/part* -P  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/rtl/201508200000/bid_term/part*  -Q hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/rtl/201508200000/bid_term/part* -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/rtl.cb.canon.20150808.txt

#sh suite-smt-rewrite.sh -m train -q default -s 4 -e 4  -g 100 -n 300 -b 200 -d decode-rtl -l 6000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_rtl -w /user/ruiqiang/all_bid_terms/201509110000.bz2/part* -P  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/rtl/201508200000/bid_term/part*  -Q hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/rtl/201508200000/bid_term/part* -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/rtl.cb.canon.20150808.txt
