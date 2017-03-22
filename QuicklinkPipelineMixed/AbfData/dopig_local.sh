queue=${2:-search_mlr}
params=$3
cmd="pig -f $1 $params -Dfs.permissions.umask-mode=022 -Dmapred.job.queue.name=$queue -Dmapreduce.reduce.speculative=true -Dmapreduce.map.speculative=true -Dmapreduce.map.memory.mb=4072 -Dmapreduce.fileoutputcommitter.marksuccessfuljobs=true -Dmapred.compress.map.output=true -Doutput.compression.enabled=true -Doutput.compression.codec=org.apache.hadoop.io.compress.GzipCodec -Dmapreduce.reduce.failures.maxpercent=10 -Dmapreduce.job.reduces=10 -Dpig.additional.jars=/homes/jyj/Projects/quicklinks/jyson-1.0.2.jar -x local"
echo $cmd
eval $cmd
