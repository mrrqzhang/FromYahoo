pig -f aravind.pig -Dmapreduce.cluster.acls.enabled=false -Dmapreduce.job.acl-view-job=* -Dmapreduce.job.acl-modify-job=* -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec -Dfs.permissions.umask-mode=022 -Dmapred.job.queue.name=search_mlr -Dmapreduce.reduce.speculative=true -Dmapreduce.map.speculative=true -Dmapreduce.map.memory.mb=6072 -Dmapreduce.fileoutputcommitter.marksuccessfuljobs=true -Dmapreduce.reduce.failures.maxpercent=10 -Dmapreduce.job.reduces=100 -p COW_DATE=201511230000 -p root=/projects/qrw/ruiqiang/aravind/201511230000