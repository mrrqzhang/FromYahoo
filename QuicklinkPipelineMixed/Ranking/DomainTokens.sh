troot=pipeline.1/QuicklinkTitles
rroot=QuicklinkFeatures

# output of the format: domain, json({token:freq})
hadoop jar ~/mylib/jars/hadoop-streaming.jar -Dmapreduce.task.timeout=12000000 -Dstream.num.map.output.key.fields=7 -Dmapred.text.key.partitioner.options=-k1,1 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options="-k1,2" -Dmapreduce.job.reduces=3000 -Dmapred.job.queue.name=default -files DomainTokens.py,/home/jyj/quicklinks/QuicklinkPipeline/addtitles/GenTrainToken.py,/home/jyj/mylib/genLibs.py -cacheArchive distcachesrc/localpython3.tar.gz#local-py -input $troot/combined.redir.title.wmdata/par* -output $rroot/domaintokens -mapper "cat" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer "./local-py/bin/python DomainTokens.py"
