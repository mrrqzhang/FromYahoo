#create training data
perl ~/scripts/two-common-fields-join.pl all-judged.result.txt a.feature | cut -f 1,2,3,6- > a.1
perl ~/scripts/two-common-fields-diff.pl judge-pscore.txt a.1 | python generate-features.py feature-list.map.txt > feature-train.fv
perl ~/scripts/two-common-fields-included.pl judge-pscore.txt a.1 | python generate-features.py feature-list.map.txt > feature-test.fv


#if 0
export HADOOP_NAMENODE_OPTS="${HADOOP_DN_GC_OPTS} -Xmx10g -Dsecurity.audit.logger=ERROR,DRFAS -Dwebhdfs.datanode.logger=INFO,webhdfslog"
pig -f phrase-table-cov.pig -Dmapreduce.cluster.acls.enabled=false -Dmapreduce.job.acl-view-job=* -Dmapreduce.job.acl-modify-job=* -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec -Dfs.permissions.umask-mode=022 -Dmapred.job.queue.name=default -Dmapreduce.reduce.speculative=true -Dmapreduce.map.speculative=true  -Dmapreduce.reduce.memory.mb=8192 -Dmapreduce.child.ulimit=7340032   -Dmapred.child.java.opts=-Xmx2048m  -Dmapreduce.fileoutputcommitter.marksuccessfuljobs=true -Dmapreduce.reduce.failures.maxpercent=10 -Dmapreduce.job.reduces=100
