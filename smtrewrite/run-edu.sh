#use advertiser status=on
sh suite-smt-rewrite.sh -m onlinetest -q default -s 2.2 -e 2.6  -g 300 -n 1 -b 5000 -d decode-edu -l 10 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_edu_nobl -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part*   -P /projects/qrw/ruiqiang/AdvertiserNoBL/edu_bid_terms//edu/201511120000/bid_term  -Q /projects/qrw/ruiqiang/AdvertiserNoBL/edu_bid_terms//edu/201511120000/bid_term -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/education-cb-canon.20150808.txt

#set nw=300
#sh suite-smt-rewrite.sh -m onlinetest -q default -s 0 -e 2.6  -g 300 -n 1 -b 5000 -d decode-edu -l 10 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_edu_nobl -w /projects/qrw/ruiqiang/all_bid_terms_include_blacklist/normal-advertiser/part*   -P /projects/qrw/ruiqiang/AdvertiserNoBL/edu_bid_terms//edu/201511120000/bid_term  -Q /projects/qrw/ruiqiang/AdvertiserNoBL/edu_bid_terms//edu/201511120000/bid_term -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/education-cb-canon.20150808.txt

#sh suite-smt-rewrite.sh -m train -q default -s 4 -e 4  -g 100 -n 100 -b 5000 -d decode-edu -l 500 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_edu_nobl -w /projects/qrw/ruiqiang/all_bid_terms_include_blacklist/normal-advertiser/part*   -P /projects/qrw/ruiqiang/AdvertiserNoBL/edu_bid_terms//edu/201511120000/bid_term  -Q /projects/qrw/ruiqiang/AdvertiserNoBL/edu_bid_terms//edu/201511120000/bid_term -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/education-cb-canon.20150808.txt

#sh suite-smt-rewrite.sh -m test -q search_mlr -s 0 -e 1  -g 100 -n 100 -b 1000 -d decode-edu -l 500 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_edu -w /user/ruiqiang/all_bid_terms/201509110000.bz2/part*  -P  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/edu/201508200000/bid_term/part*  -Q hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/edu/201508200000/bid_term/part* -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/education-cb-canon.20150808.txt


