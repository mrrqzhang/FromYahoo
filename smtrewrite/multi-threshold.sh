#/projects/qrw/ruiqiang/Gemini/smtrewrite_qbert_bidterms/decode-nb2000/toprewrite
for th in -0.8  -1.0 -1.2 -1.5 -1.8 -2.0 -2.2 -2.5 -2.8 -3.0 -3.2 -3.5 -3.8 -4.0 -4.5 -5.0 -5.5 -6.0 ; do 
#for th in -5.5 -6.0 -6.5 -7.0 -7.5 -8.0 -8.5 -9.0 ; do
   cd /tmp/ruiqiang/Gemini/smtrewrite_edu
   sh suite-smt-rewrite.sh -m test -q search_mlr -f $th -s 4 -e 4 -g 100 -n 100 -b 2000 -d decode-edu -l 6000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_edu -P  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/edu/201508200000/bid_term/part* -Q hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/edu/201508200000/bid_term/part*  -i hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/education-cb-canon.20150808.txt

   cd /tmp/ruiqiang/Gemini/GeminiEvaluation
   sh suite.sh -s 2 -e 2  -D 201505* -r Gemini/edu -b hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/edu/201508200000/bid_term/part* -T /projects/qrw/ruiqiang/Gemini/smtrewrite_edu/decode-edu/toprewrite

   echo "number rewrite:$th"
   hadoop fs -cat Gemini/edu/GeminiEvaluation/evaluation/part* | gunzip |  grep n1 | grep Broad |  python count-by-word.py 
done
