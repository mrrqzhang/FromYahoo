# join by active advertiser
sh suite-smt-rewrite.sh -m test -q default -s 2.2 -e 2.6 -g 100 -n 60 -b 1000 -d decode-nb1000 -l 500 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_tec -P /projects/qrw/ruiqiang/Advertiser/tec_bid_terms/tec/201509140000/bid_term/part* -Q /projects/qrw/ruiqiang/Advertiser/tec_bid_terms/tec/201509140000/bid_term/part* -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part*  -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/tec-cb-canon.txt



#minize model 2015/11/20
#sh suite-smt-rewrite.sh -m train -q default -s 4 -e 4 -g 100 -n 60 -b 1000 -d decode-nb1000 -l 500 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_tec -P  /projects/qrw/ruiqiang/Advertiser/tec_bid_terms/tec/201509140000/bid_term/part* -Q /projects/qrw/ruiqiang/Advertiser/tec_bid_terms/tec/201509140000/bid_term/part* -w   /user/ruiqiang/all_bid_terms/201509110000.bz2/part*  -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/tec-cb-canon.txt 

#hadoop fs -cat webhdfs://phazonred-nn1.red.ygrid.yahoo.com/user/mmorais/traffic_shaping/canon_generation_data/tec/2015082501/raw_query_with_all_canon_forms/part* | gunzip | cut -f5 | sort | uniq  >  tec-cb-canon.txt
#hadoop fs -rm  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/tec-cb-canon.txt
#hadoop fs -copyFromLocal tec-cb-canon.txt  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/.

#sh suite-smt-rewrite.sh -m test -q search_mlr -s 3 -e 3 -g 100 -n 60 -b 1000 -d decode-nb1000 -l 500 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_tec -P  /projects/qrw/ruiqiang/Advertiser/tec_bid_terms/tec/201509140000/bid_term/part* -Q /projects/qrw/ruiqiang/Advertiser/tec_bid_terms/tec/201509140000/bid_term/part* -w   /user/ruiqiang/all_bid_terms/201509110000.bz2/part*  -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/tec-cb-canon.txt  

