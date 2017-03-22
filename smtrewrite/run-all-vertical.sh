#run google key word match
#hadoop fs -cat hdfs://phazonred-nn1.red.ygrid.yahoo.com:8020/user/cb_qb/query_biddedterm/input/query_biddedterm_map.csv.broad | cut -f 1 | sort | uniq > keyword.txt
#hadoop fs -copyFromLocal keyword.txt
sh suite-smt-rewrite.sh -m onlinetest -q default -s 9 -e 9 -g 20 -n 1 -b 5000 -d decode-keyword -l 100 -c 201603290000 -r /projects/qrw/ruiqiang/Gemini/AllBidTerms -w  /projects/qrw/ruiqiang/Gemini/AllBidTerms/fullbidterms   -i keyword.txt

#test rewrite
#sh suite-smt-rewrite.sh -m onlinetest -q default -s 3 -e 3 -g 20 -n 1 -b 5000 -d decode -l 500 -c 201602070000 -r /projects/qrw/ruiqiang/Gemini/AllBidTerms -w  /projects/qrw/ruiqiang/Gemini/AllBidTerms/fullbidterms   -i /projects/qrw/ruiqiang/Gemini/all-qbert-query/part*$number.gz


# use 3G all bid term model to translate all qbert
#for number in   08 ; do 
#     sh suite-smt-rewrite.sh -m onlinetest -q default -s 1 -e 9 -g 20 -n 1 -b 5000 -d decode -l 500 -c 201602070000 -r /projects/qrw/ruiqiang/Gemini/AllBidTerms -w  /projects/qrw/ruiqiang/Gemini/AllBidTerms/fullbidterms   -i /projects/qrw/ruiqiang/Gemini/all-qbert-query/part*$number.gz
#     hadoop fs -rm -r  /projects/qrw/ruiqiang/Gemini/AllBidTerms/savedrewrite/ecpm-$number
#     hadoop fs -cp  /projects/qrw/ruiqiang/Gemini/AllBidTerms/greedy/ecpm /projects/qrw/ruiqiang/Gemini/AllBidTerms/savedrewrite/ecpm-$number
#done


#regenerate a small size minroot. Now the file size=16G. can't run locally 2016/01/27
#sh suite-smt-rewrite.sh -m train -q default -s 5 -e 5 -g 100 -n 1600 -b 200 -d decode -l 2000 -r /projects/qrw/ruiqiang/Gemini/AllBidTerms/ -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part*   -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/

#retrain all bidterms for phrase match. use GizeMaxPhraseLen=6
#sh suite-smt-rewrite.sh -m train -q default -s 2 -e 4 -g 100 -n 1600 -b 200 -d decode -l 2000 -r /projects/qrw/ruiqiang/Gemini/AllBidTerms/ -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part*   -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/

#output rewrite if query==rewrite 
#sh suite-smt-rewrite.sh -m onlinetest -q default -s 2.4 -e 2.6 -g 100 -n 1 -b 2000 -d decode -l 200 -r /projects/qrw/ruiqiang/Gemini/AllBidTerms/ -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part*   -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/all-vertical-wl.txt

#hcat webhdfs://phazonred-nn1.red.ygrid.yahoo.com/user/mmorais/traffic_shaping/canon_generation_data/*/*/raw_query_with_all_canon_forms/part*.gz | gunzip | cut -f5 | sort | uniq > all-vertical-wl.txt
#use minization to translate all wl
#sh suite-smt-rewrite.sh -m onlinetest -q default -s 0 -e 2.6 -g 100 -n 1 -b 2000 -d decode -l 200 -r /projects/qrw/ruiqiang/Gemini/AllBidTerms/ -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part*   -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/all-vertical-wl.txt


#minimize all vertical smt model. use new threshold WL1CNT=float(5) (before 12)  WL2CNT=float(3) (6) WL3CNT=float(2)(4) WL4CNT=float(2)(3)
#sh suite-smt-rewrite.sh -m train -q default -s 4 -e 4 -g 100 -n 1600 -b 200 -d decode -l 2000 -r /projects/qrw/ruiqiang/Gemini/AllBidTerms/ -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part*   -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/





