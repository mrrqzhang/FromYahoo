queue=search_mlr
input=hdfs://nitroblue-nn1.blue.ygrid.yahoo.com:8020/projects/qrw/ruiqiang/Gemini/smtrewrite_trv/train/word2vec/part*
output=/projects/qrw/ruiqiang/Gemini/w2v-test

hadoop fs -rm -r -skipTrash $output
hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar \
                -files extract-match.py  \
                -Dmapred.job.queue.name=$queue -Dmapred.job.map.memory.mb=8168 -Dmapred.child.ulimit=7340032 \
                -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec \
                -Dmapreduce.cluster.acls.enabled=false \
                -Dmapreduce.job.acl-view-job=* \
                -Dmapreduce.job.acl-modify-job=* \
                -Dmapreduce.job.maps=400 \
                -jobconf mapred.task.timeout=0 \
                -input $input \
                -output $output \
                -mapper "python extract-match.py"

