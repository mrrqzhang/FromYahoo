set OUTDIR=$2
set INPUT=$1
hadoop fs -rm -r -skipTrash $OUTDIR
hadoop jar $HADOOP_HOME/hadoop-streaming.jar -Dmapred.reduce.tasks=100 -input $INPUT  -output $OUTDIR -mapper 'python clicktext_mapper.py exclude_terms.txt '"$4"' '"$3"'' -file 'clicktext_mapper.py' -file 'exclude_terms.txt' -file 'clicktext_reducer.py' -reducer 'python clicktext_reducer.py'

