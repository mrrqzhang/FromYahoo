# scrape features for qu file
source config.sh
set qu_scrape = $1 
set output_hdfs_dir = usmlr/sim
set output_suffix = $2
set output_scrape = q_u_features_$qu_scrape$output_suffix

python add_url.py $qu_scrape $qu_scrape.1
cut -f3 $qu_scrape.1 | sed 's/\//\t/g' | awk -F\\t '{print $1}' > $qu_scrape.host
paste $qu_scrape.1 $qu_scrape.host > $qu_scrape.final
scp $qu_scrape.final $grid\:/grid/0/tmp/ckang
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/'"$qu_scrape"'.final'
ssh $grid 'cd '"$gateway_working_dir"';hadoop fs -copyFromLocal /grid/0/tmp/ckang/'"$qu_scrape"'.final '"$output_hdfs_dir"''

scp gen_sim_features.pig $gateway_dir
scp gen_sim_features.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/'"$output_scrape"''
ssh $grid 'cd '"$gateway_working_dir"';pig -param input_qu='"$qu_scrape"'.final -param output='"$output_scrape"' -param output_suffix='"$output_suffix"' -param output_hdfs_dir='"$output_hdfs_dir"' -param gateway_working_dir='"$gateway_working_dir"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=500 gen_sim_features.pig'
