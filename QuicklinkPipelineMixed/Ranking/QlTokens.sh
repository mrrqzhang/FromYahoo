troot=pipeline.1/QuicklinkTitles
rroot=QuicklinkFeatures
mylibloc=/homes/jyj/mylib
if [ ! -e $mylibloc ] ; then
    mylibloc=/home/jyj/mylib
fi
# output of the format: domain, json({token:freq})
hadoop jar ~/mylib/jars/hadoop-streaming.jar -Dmapreduce.task.timeout=12000000 -Dstream.num.map.output.key.fields=7 -Dmapred.text.key.partitioner.options=-k1,1 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options="-k1,2" -Dmapreduce.job.reduces=3000 -Dmapred.job.queue.name=default -files DomainTokens.py,QlTokens.py,$mylibloc/quicklinks/QuicklinkPipeline/addtitles/GenTrainToken.py,$mylibloc/mylib/genLibs.py -cacheArchive distcachesrc/localpython3.tar.gz#local-py -input $troot/combined.redir.title.wmdata/par* -output $rroot/qltokens -mapper "cat" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer "./local-py/bin/python QlTokens.py"