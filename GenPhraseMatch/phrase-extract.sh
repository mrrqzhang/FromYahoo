out=/projects/qrw/ruiqiang/GeminiPhraseMatch/smt_phrase
input=/projects/qrw/ruiqiang/Gemini/AllBidTerms/train/minroot/part-v010-o000-r-00000.gz


hadoop fs -rmr $out
cmd="hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar \
                -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec \
                -Dmapred.job.queue.name=default -Dmapred.job.map.memory.mb=8168 -Dmapred.child.ulimit=7340032 \
                -Dmapred.child.java.opts=-Xmx8168m \
                -Dmapreduce.reduce.java.opts=-Xmx8168m \
                -Dmapreduce.reduce.memory.mb=8168 \
                -Dmap.output.key.field.separator=' ' \
                -input $input \
                -output $out \
                -mapper 'cut -f2' \
                -reducer \"python phrase-extract.py\" \
                -jobconf mapred.map.tasks=40 \
                -jobconf mapred.reduce.tasks=200 \
                -jobconf mapred.task.timeout=0 \
                -file phrase-extract.py
"
echo $cmd
eval $cmd
