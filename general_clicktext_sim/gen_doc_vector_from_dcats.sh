set OUTDIR=$2
set INPUT=$1
hadoop fs -rm -r -skipTrash $OUTDIR
hadoop jar $HADOOP_HOME/hadoop-streaming.jar -Dmapred.job.queue.name=$3 -Dmapred.reduce.tasks=100 -input $INPUT -output $OUTDIR -mapper 'cat' -reducer 'python gen_doc_vector_from_dcats.py '"$4"'' -file 'gen_doc_vector_from_dcats.py'
