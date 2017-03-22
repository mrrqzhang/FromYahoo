#generate for all qbert
#for number in  00 01 02 03 04 05 06 07 08 09 10 11 12 13 ; do
#	sh suite-broad.sh -s 1 -e 8 -r /projects/qrw/ruiqiang/BroadGenQbertAll/ -w /projects/qrw/ruiqiang/Gemini/all-qbert-query/part*$number.gz
#	hadoop fs -rm -r /projects/qrw/ruiqiang/BroadGenQbertAll/$number
#	hadoop fs -mkdir /projects/qrw/ruiqiang/BroadGenQbertAll/$number
#	hadoop fs -mv /projects/qrw/ruiqiang/BroadGenQbertAll/rankedbyecpm /projects/qrw/ruiqiang/BroadGenQbertAll/$number/
#done

#bpb process after using new clicksim features  03/14/17
sh suite-broad.sh -s 9 -e 9 -r /projects/qrw/ruiqiang/BroadPhraseBroadNewClickSim -w /projects/qrw/ruiqiang/bpb-phrases.txt

#bpb post process
#sh suite-broad.sh -s 9 -e 9 -r /projects/qrw/ruiqiang/BroadPhraseBroad -w /projects/qrw/ruiqiang/bpb-phrases.txt

#sh suite-broad.sh -s 1 -e 8 -r /projects/qrw/ruiqiang/BroadPhraseBroad -w /projects/qrw/ruiqiang/bpb-phrases.txt

#sh suite-broad.sh -s 7 -e 8 -r /projects/qrw/ruiqiang/BroadGen10Mse  -w hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/all-vertical-wl.txt

#test ecpm rank
#sh suite-broad.sh -s 7 -e 8 -r /projects/qrw/ruiqiang/BroadGenVerify  -w hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/all-vertical-wl.txt

#sh suite-broad.sh -s 1 -e 7 -r /projects/qrw/ruiqiang/BroadGen10Mnose  -w hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/all-vertical-wl.txt

#sh suite-broad.sh -s 7 -e 7 -r /projects/qrw/ruiqiang/BroadGen  -w hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/all-vertical-wl.txt
 
