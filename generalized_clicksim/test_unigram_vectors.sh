scp gen_test_unigrams.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/test_unigrams.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/test_unigrams.gz -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=5000 gen_test_unigrams.pig'

scp eval.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/avg_sim_unigrams'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/avg_sim_unigrams -Dmapred.job.queue.name='"$queue"' -param input='"$output_hdfs_dir"'/test_unigrams.gz -Dmapred.reduce.tasks=5000 eval.pig'


