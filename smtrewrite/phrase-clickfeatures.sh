input=/projects/qrw/ruiqiang/Gemini/AllBidTerms/train/smt_model/part*
outPhrase=/projects/qrw/ruiqiang/GeminiPhraseMatch/smt_phrase

outClick=/projects/qrw/ruiqiang/GeminiPhraseMatch/phraseclickfeatures

final=/projects/qrw/ruiqiang/GeminiPhraseMatch/queryphrasescoring



hadoop fs -rmr $outPhrase
cmd="hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar \
                -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec \
                -Dmapred.job.queue.name=default -Dmapred.job.map.memory.mb=8168 -Dmapred.child.ulimit=7340032 \
                -Dmapred.child.java.opts=-Xmx8168m \
                -Dmapreduce.reduce.java.opts=-Xmx8168m \
                -Dmapreduce.reduce.memory.mb=8168 \
                -Dmap.output.key.field.separator=' ' \
                -input $input \
                -output $outPhrase \
                -mapper 'cut -f2' \
                -reducer \"python phrase-extract.py\" \
                -jobconf mapred.map.tasks=40 \
                -jobconf mapred.reduce.tasks=400 \
                -jobconf mapred.task.timeout=0 \
                -file greedy/phrase-extract.py
"
echo $cmd
eval $cmd


sh dopig.sh predict_query_vector.pig "-param output=$outClick  -param input=$outPhrase"

sh dopig.sh joinclickfeature.pig "-Dmapred.output.compress=false -p input=$outPhrase -p clickroot=$outClick -p out=$final" 
