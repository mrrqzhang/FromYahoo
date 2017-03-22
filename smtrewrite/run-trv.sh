#minimize all vertical smt model. use new threshold

#translation by minimized model
sh suite-smt-rewrite.sh -m onlinetest -q default -s 0 -e 2.6  -g 100 -n 1 -b 5000 -d decode -l 50 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_trv -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part* -P  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/travel/201508180000/bid_term/part* -Q hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/travel/201508180000/bid_term/part*  -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/travel-cb-canon-2015071500.txt



#minize table 2015/11/30
#sh suite-smt-rewrite.sh -m train -q default -s 4 -e 4 -g 100 -n 400 -b 200 -d decode -l 2000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_trv -w  /user/ruiqiang/all_bid_terms/201509110000.bz2/part*  -P  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/travel/201508180000/bid_term/part* -Q hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/travel/201508180000/bid_term/part*  -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/travel-cb-canon-2015071500.txt

#sh suite-smt-rewrite.sh -m test -q search_mlr -s 2 -e 2.4 -g 100 -n 400 -b 200 -d decode -l 2000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_trv -w  /user/ruiqiang/all_bid_terms/201509110000.bz2/part*  -P  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/travel/201508180000/bid_term/part* -Q hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/travel/201508180000/bid_term/part*  -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/travel-cb-canon-2015071500.txt


