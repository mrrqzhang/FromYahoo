#join by active advertisers 2015/11/20
sh suite-smt-rewrite.sh -m test -q default -s 2.2 -e 2.6  -g 100 -n 50 -b 2000 -d decode-nb2000-3 -l 1000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_fin -P /projects/qrw/ruiqiang/Advertiser/fin_bid_terms//fin/201509140000/bid_term -Q /projects/qrw/ruiqiang/Advertiser/fin_bid_terms//fin/201509140000/bid_term -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part*  -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/fin-cb-canon.txt 

#minize model 2015/11/20
#sh suite-smt-rewrite.sh -m train -q default -s 4 -e 4  -g 100 -n 50 -b 2000 -d decode-nb2000-3 -l 1000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_fin -P /projects/qrw/ruiqiang/Advertiser/fin_bid_terms//fin/201509140000/bid_term -Q /projects/qrw/ruiqiang/Advertiser/fin_bid_terms//fin/201509140000/bid_term -w /user/ruiqiang/all_bid_terms/201509110000.bz2/part*   -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/fin-cb-canon.txt 

#hadoop fs -cat webhdfs://phazonred-nn1.red.ygrid.yahoo.com/user/mmorais/traffic_shaping/canon_generation_data/fin/2015091100/raw_query_with_all_canon_forms/part* | gunzip | cut -f5 | sort | uniq  >  fin-cb-canon.txt
#hadoop fs -rm  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/fin-cb-canon.txt
#hadoop fs -copyFromLocal fin-cb-canon.txt  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/.

#sh suite-smt-rewrite.sh -m test -q search_mlr -s 2.2 -e 2.4  -g 100 -n 50 -b 2000 -d decode-nb2000-3 -l 1000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_fin -P /projects/qrw/ruiqiang/Advertiser/fin_bid_terms//fin/201509140000/bid_term -Q /projects/qrw/ruiqiang/Advertiser/fin_bid_terms//fin/201509140000/bid_term -w /user/ruiqiang/all_bid_terms/201509110000.bz2/part*   -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/fin-cb-canon.txt  

