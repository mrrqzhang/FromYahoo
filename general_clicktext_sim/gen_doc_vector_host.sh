set OUTDIR=$2
set INPUT=$1
hadoop fs -rm -r -skipTrash $OUTDIR
hadoop jar $HADOOP_HOME/hadoop-streaming.jar -Dmapred.job.queue.name=$3 -Dmapred.reduce.tasks=100 -input $INPUT -output $OUTDIR -mapper 'python clicktext_host_mapper.py english.stop.txt' -file 'clicktext_host_mapper.py' -file 'english.stop.txt' -file 'clicktext_reducer.py' -reducer 'python clicktext_reducer.py'

