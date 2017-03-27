qlasroot=temp/qlasroot
qlasInput=to-qlas-83-55.txt
qlasroot=temp/qlasoutput-83-55

hadoop fs -rmr $qlasroot
    cmd="hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar \
                -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec \
                -Dmapred.job.queue.name=default -Dmapred.job.map.memory.mb=8168 -Dmapred.child.ulimit=7340032 \
                -Dmapred.child.java.opts=-Xmx8168m \
                -Dmapreduce.reduce.java.opts=-Xmx8168m \
                -Dmapreduce.reduce.memory.mb=8168 \
                -input $qlasInput \
                -output $qlasroot \
                -mapper 'cat' \
                -reducer qlasreducer.sh \
                -jobconf mapred.map.tasks=40 \
                -jobconf mapred.reduce.tasks=400 \
                -jobconf mapred.task.timeout=0 \
                -file qlasreducer.sh \
                -cacheArchive 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com/user/ruiqiang/qlas_on_grid/qlas_libs-4.7.3.21.jar#qlas' \
                -cacheArchive 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com/user/ruiqiang/qlas_on_grid/qlas_data-us-latest.jar#datapack' "
    echo $cmd
    eval $cmd

