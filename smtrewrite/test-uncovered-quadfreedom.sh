hadoop fs -cat  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/cb_qb/fd/BROAD/mobile/nonqbertquad/part* | cut -f1 | sort | uniq > nonqbertquad.txt 
hadoop fs -copyFromLocal nonqbertquad.txt /projects/qrw/ruiqiang/Gemini/nonqbertquad.txt

sh suite-smt-rewrite.sh -m test -q search_mlr -s 2.2 -e 2.4  -n 400 -b 200 -d decode-quadfreedom -l 2000 -r /projects/qrw/ruiqiang/Gemini/smtrewrite_trv -P  hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/travel/201508180000/bid_term/part* -Q hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/travel/201508180000/bid_term/part*  -i /projects/qrw/ruiqiang/Gemini/nonqbertquad.txt 

sh dopig.sh nonquadqbert-join.pig "-p smtInput=/projects/qrw/ruiqiang/Gemini/smtrewrite_trv/decode-quadfreedom/domainfreetoprewriter -p qbertInput=hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/cb_qb/fd/BROAD/mobile/nonqbertquad/part* -p out=/projects/qrw/ruiqiang/Gemini/smtrewrite_trv/decode-quadfreedom/fandnf"

