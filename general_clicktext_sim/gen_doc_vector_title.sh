set OUTDIR=$1
hadoop fs -rm -r -skipTrash $OUTDIR
hadoop jar $HADOOP_HOME/hadoop-streaming.jar -Dmapred.job.queue.name=$2 -Dmapred.reduce.tasks=100 -input 'usmlr/session/url_title*/' -output $OUTDIR -mapper 'python title_mapper.py english.stop.txt' -file 'title_mapper.py' -file 'english.stop.txt' -file 'title_reducer.py' -reducer 'python title_reducer.py'

