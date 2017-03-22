source config.sh
set dir = $1
set input_file = $2
set query_file = $3
set output = $4
scp $query_file $gateway_dir
ssh $grid 'hadoop fs -rm '"$dir"'/'"$query_file"''
ssh $grid 'hadoop fs -rm -r '"$dir"'/'"$output"''
ssh $grid 'cd '"$gateway_working_dir"';hadoop fs -copyFromLocal '"$query_file"' '"$dir"''
scp filter_qry.pig $gateway_dir
ssh $grid 'cd '"$gateway_working_dir"';pig -param input='"$dir"'/'"$input_file"' -param output='"$dir"'/'"$output"' -param query_file='"$dir"'/'"$query_file"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=1000 filter_qry.pig'
