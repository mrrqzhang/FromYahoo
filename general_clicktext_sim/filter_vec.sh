set OUTDIR=$2
set INPUT=$1
hadoop fs -rm -r -skipTrash $OUTDIR
hadoop jar $HADOOP_HOME/hadoop-streaming.jar -Dmapred.reduce.tasks=100 -input $INPUT -output $OUTDIR -mapper 'cat' -reducer 'python filter_vec.py '"$3"'' -file 'filter_vec.py'

