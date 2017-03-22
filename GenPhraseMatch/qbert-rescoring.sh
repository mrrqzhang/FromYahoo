root=/projects/qrw/ruiqiang/qbert-rescoring
qbert='hdfs://phazonblue-nn1.blue.ygrid.yahoo.com/projects/cb_qb/dev/scoring_jchaw/gm-daily/20161015/qbert.scores/part*'
featureroot=$root/features
scoreroot=$root/scores
nthreshold=0.9
topn=50

sh dopig.sh predict_query_vector.pig "-param output=$featureroot -p input=$qbert"
sh dopig.sh joinclickfeature2.pig "-p threshold=$nthreshold -p topn=$topn -p input=$qbert -p clickroot=$featureroot -p out=$scoreroot"
