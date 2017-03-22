#filter by active advertiser only
sh suite-smt-rewrite.sh -m test -q default -s 2.2 -e 2.6  -g 100  -n 100 -b 1000 -d decode -l 3000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_auto -P  /projects/qrw/ruiqiang/Advertiser/car_bid_terms//auto/201509140000/bid_term/part* -Q /projects/qrw/ruiqiang/Advertiser/car_bid_terms//auto/201509140000/bid_term/part* -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part*  -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/car-cb-canon.20150912.txt

#minizie smt model 2015/11/20
#sh suite-smt-rewrite.sh -m train -q default -s 4 -e 4  -g 100  -n 100 -b 1000 -d decode -l 3000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_auto -P  /projects/qrw/ruiqiang/Advertiser/car_bid_terms//auto/201509140000/bid_term/part* -Q /projects/qrw/ruiqiang/Advertiser/car_bid_terms//auto/201509140000/bid_term/part* -w /user/ruiqiang/all_bid_terms/201509110000.bz2/part*  -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/car-cb-canon.20150912.txt


#hadoop fs -cat webhdfs://phazonred-nn1.red.ygrid.yahoo.com/user/mmorais/traffic_shaping/canon_generation_data/car/2015091200/raw_query_with_all_canon_forms/part* | gunzip | cut -f5 >  car-cb-canon.20150912.txt
#hadoop fs -rm  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/car-cb-canon.20150912.txt
#hadoop fs -copyFromLocal car-cb-canon.20150912.txt  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/.

#sh suite-smt-rewrite.sh -m test -q search_mlr -s 1 -e 2.4  -g 100  -n 100 -b 1000 -d decode -l 3000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_auto -P  /projects/qrw/ruiqiang/Advertiser/car_bid_terms//auto/201509140000/bid_term/part* -Q /projects/qrw/ruiqiang/Advertiser/car_bid_terms//auto/201509140000/bid_term/part* -w /user/ruiqiang/all_bid_terms/201509110000.bz2/part*  -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/car-cb-canon.20150912.txt  

