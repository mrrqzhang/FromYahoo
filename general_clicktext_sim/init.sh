source config.sh

ssh $grid 'mkdir '"$gateway_working_dir"''
ssh $grid 'mkdir '"$gateway_tmp"''

ssh $grid 'hadoop fs -mkdir '"$output_hdfs_dir"''
