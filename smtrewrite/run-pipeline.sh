# -m: mode (train/onlinetest) -s start_step -e end_step -g number_bidterm_output -n reducer_number_training -b smt_translation_number
# -d: smt_decode_folder -l reducer_number_decode -r root  -w cow_full_bidterm -i input_query -a vertical_advertiser_mdmid -c COW_DATE_VERSION -v vertical_id 
#sh suite-smt-rewrite.sh -m train -q default -s 2 -e 5 -g 50 -n 400 -b 200 -d decode -l 2000 -r /projects/qrw/ruiqiang/temp-pipeline-test -w  /projects/qrw/ruiqiang/temp-pipeline-test/fullbidterms  -a trv.csv -c 201601210000 -v trv   -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/travel-cb-canon-2015071500.txt


# -m: onlinetest use -n = 1 if onlinetest  -l=50
sh suite-smt-rewrite.sh -m onlinetest -q default -s 1 -e 9 -g 50 -n 1 -b 200 -d decode -l 50 -r /projects/qrw/ruiqiang/temp-pipeline-test -w  /projects/qrw/ruiqiang/temp-pipeline-test/fullbidterms  -a trv.csv -c 201601210000 -v trv   -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/travel-cb-canon-2015071500.txt
