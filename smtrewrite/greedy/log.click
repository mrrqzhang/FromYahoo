nohup: ignoring input
pig -f clickfeature-fullbt-join.pig -Dmapreduce.cluster.acls.enabled=false -Dmapreduce.job.acl-view-job=* -Dmapreduce.job.acl-modify-job=* -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec -Dfs.permissions.umask-mode=022 -Dmapred.job.queue.name=default -Dmapreduce.reduce.speculative=true -Dmapreduce.map.speculative=true -Dmapreduce.map.memory.mb=6072 -Dmapreduce.fileoutputcommitter.marksuccessfuljobs=true -Dmapreduce.reduce.failures.maxpercent=10 -Dmapreduce.job.reduces=
USING: /home/gs/pig/current
15/11/25 15:07:35 INFO pig.ExecTypeProvider: Trying ExecType : LOCAL
15/11/25 15:07:35 INFO pig.ExecTypeProvider: Trying ExecType : MAPREDUCE
15/11/25 15:07:35 INFO pig.ExecTypeProvider: Trying ExecType : TEZ_LOCAL
15/11/25 15:07:35 INFO pig.ExecTypeProvider: Trying ExecType : TEZ
15/11/25 15:07:35 INFO pig.ExecTypeProvider: Picked TEZ as the ExecType
2015-11-25 15:07:35,913 [main] INFO  org.apache.pig.Main - Apache Pig version 0.14.0.9.1511150240 (rexported) compiled Nov 15 2015, 03:34:58
2015-11-25 15:07:35,913 [main] INFO  org.apache.pig.Main - Logging error messages to: /tmp/ruiqiang/greedy/pig_1448464055911.log
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/home/y/var/TEZ_ROOTS/ytez-0.7.1.1.1511132139/libexec/tez/lib/slf4j-log4j12-1.7.5.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/home/Releases/hadoop-2.6.0.24.1509041917-20150909-000/share/hadoop-2.6.0.24.1509041917/share/hadoop/common/lib/slf4j-log4j12-1.7.5.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.slf4j.impl.Log4jLoggerFactory]
2015-11-25 15:07:36,663 [main] INFO  org.apache.pig.impl.util.Utils - Default bootup file /homes/ruiqiang/.pigbootup not found
2015-11-25 15:07:36,787 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - mapred.output.compress is deprecated. Instead, use mapreduce.output.fileoutputformat.compress
2015-11-25 15:07:36,788 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - mapred.output.compression.codec is deprecated. Instead, use mapreduce.output.fileoutputformat.compress.codec
2015-11-25 15:07:36,788 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - mapred.job.queue.name is deprecated. Instead, use mapreduce.job.queuename
2015-11-25 15:07:36,789 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - mapred.job.tracker is deprecated. Instead, use mapreduce.jobtracker.address
2015-11-25 15:07:36,789 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - fs.default.name is deprecated. Instead, use fs.defaultFS
2015-11-25 15:07:36,789 [main] INFO  org.apache.pig.backend.hadoop.executionengine.HExecutionEngine - Connecting to hadoop file system at: hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020
2015-11-25 15:07:38,145 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - fs.default.name is deprecated. Instead, use fs.defaultFS
2015-11-25 15:07:38,472 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - fs.default.name is deprecated. Instead, use fs.defaultFS
2015-11-25 15:07:38,597 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - fs.default.name is deprecated. Instead, use fs.defaultFS
2015-11-25 15:07:38,608 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - mapred.textoutputformat.separator is deprecated. Instead, use mapreduce.output.textoutputformat.separator
2015-11-25 15:07:38,620 [main] INFO  org.apache.hadoop.hdfs.DFSClient - Created HDFS_DELEGATION_TOKEN token 3378393 for ruiqiang on jetblue-nn1.blue.ygrid.yahoo.com:8020
2015-11-25 15:07:38,645 [main] INFO  org.apache.hadoop.mapreduce.security.TokenCache - Got dt for hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020; Kind: HDFS_DELEGATION_TOKEN, Service: jetblue-nn1.blue.ygrid.yahoo.com:8020, Ident: (HDFS_DELEGATION_TOKEN token 3378393 for ruiqiang)
2015-11-25 15:07:38,658 [main] INFO  org.apache.pig.tools.pigstats.ScriptState - Pig features used in the script: HASH_JOIN,ORDER_BY
2015-11-25 15:07:38,692 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - fs.default.name is deprecated. Instead, use fs.defaultFS
2015-11-25 15:07:38,696 [main] INFO  org.apache.pig.data.SchemaTupleBackend - Key [pig.schematuple] was not set... will not generate code.
2015-11-25 15:07:38,715 [main] INFO  org.apache.pig.newplan.logical.optimizer.LogicalPlanOptimizer - {RULES_ENABLED=[AddForEach, ColumnMapKeyPrune, ConstantCalculator, GroupByConstParallelSetter, LimitOptimizer, LoadTypeCastInserter, MergeFilter, MergeForEach, PartitionFilterOptimizer, PredicatePushdownOptimizer, PushDownForEachFlatten, PushUpFilter, SplitFilter, StreamTypeCastInserter]}
2015-11-25 15:07:38,818 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - fs.default.name is deprecated. Instead, use fs.defaultFS
2015-11-25 15:07:38,833 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher - Tez staging directory is /tmp/temp-850658025
2015-11-25 15:07:38,871 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.plan.TezCompiler - File concatenation threshold: 100 optimistic? false
2015-11-25 15:07:38,905 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.plan.optimizer.SecondaryKeyOptimizerTez - Using Secondary Key Optimization in the edge between vertex - scope-29 and vertex - scope-38
2015-11-25 15:07:38,923 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - mapreduce.inputformat.class is deprecated. Instead, use mapreduce.job.inputformat.class
2015-11-25 15:07:39,007 [main] INFO  org.apache.hadoop.hdfs.DFSClient - Created HDFS_DELEGATION_TOKEN token 3378394 for ruiqiang on jetblue-nn1.blue.ygrid.yahoo.com:8020
2015-11-25 15:07:39,008 [main] INFO  org.apache.hadoop.mapreduce.security.TokenCache - Got dt for hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020; Kind: HDFS_DELEGATION_TOKEN, Service: jetblue-nn1.blue.ygrid.yahoo.com:8020, Ident: (HDFS_DELEGATION_TOKEN token 3378394 for ruiqiang)
2015-11-25 15:07:39,582 [main] INFO  org.apache.hadoop.mapreduce.lib.input.FileInputFormat - Total input paths to process : 900
2015-11-25 15:07:39,582 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil - Total input paths to process : 900
2015-11-25 15:07:39,666 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil - Total input paths (combined) to process : 900
2015-11-25 15:07:39,748 [main] INFO  org.apache.hadoop.mapreduce.lib.input.FileInputFormat - Total input paths to process : 400
2015-11-25 15:07:39,748 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil - Total input paths to process : 400
2015-11-25 15:07:39,771 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil - Total input paths (combined) to process : 24
2015-11-25 15:07:40,257 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler - Local resource: pig.jar
2015-11-25 15:07:40,292 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - fs.default.name is deprecated. Instead, use fs.defaultFS
2015-11-25 15:07:40,316 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,316 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,316 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,316 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,316 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,316 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,316 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,316 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,316 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,316 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,317 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,317 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,317 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,317 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,317 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,317 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,317 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,317 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,404 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - For vertex - scope-27: parallelism=900, memory=6072, java opts=-XX:ErrorFile=<LOG_DIR>/hs_err_pid%p.log -XX:GCTimeLimit=50 -XX:ParallelGCThreads=4 -XX:NewRatio=8 -Djava.net.preferIPv4Stack=true -server -Xmx1024m -Djava.net.preferIPv4Stack=true -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
2015-11-25 15:07:40,404 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Processing aliases: A,C
2015-11-25 15:07:40,404 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Detailed locations: A[4,4],A[6,4],C[11,4]
2015-11-25 15:07:40,404 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Pig features in the vertex: 
2015-11-25 15:07:40,495 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,495 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,495 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,495 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,495 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,495 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,495 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,495 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,495 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,495 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,495 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,496 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,496 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,496 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,496 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,496 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,496 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,496 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,524 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - For vertex - scope-28: parallelism=24, memory=6072, java opts=-XX:ErrorFile=<LOG_DIR>/hs_err_pid%p.log -XX:GCTimeLimit=50 -XX:ParallelGCThreads=4 -XX:NewRatio=8 -Djava.net.preferIPv4Stack=true -server -Xmx1024m -Djava.net.preferIPv4Stack=true -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
2015-11-25 15:07:40,524 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Processing aliases: B,C
2015-11-25 15:07:40,524 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Detailed locations: B[8,4],B[9,4],C[11,4]
2015-11-25 15:07:40,524 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Pig features in the vertex: 
2015-11-25 15:07:40,540 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,540 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,540 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,540 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,540 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,541 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,541 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,541 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,541 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,541 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,541 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,541 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,541 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,541 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,541 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,541 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,542 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,542 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,579 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - For vertex - scope-29: parallelism=2000, memory=2048, java opts=-XX:ErrorFile=<LOG_DIR>/hs_err_pid%p.log -XX:GCTimeLimit=50 -XX:ParallelGCThreads=4 -XX:NewRatio=8 -Djava.net.preferIPv4Stack=true -server -Xmx1024m -Djava.net.preferIPv4Stack=true -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
2015-11-25 15:07:40,579 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Processing aliases: C
2015-11-25 15:07:40,579 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Detailed locations: C[11,4],C[13,4],C[15,4]
2015-11-25 15:07:40,579 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Pig features in the vertex: HASH_JOIN,SAMPLER
2015-11-25 15:07:40,600 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,600 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,600 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,600 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,600 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,601 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,621 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,622 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,623 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,623 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,641 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,642 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,659 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Estimate quantile for sample aggregation vertex scope-38
2015-11-25 15:07:40,672 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - For vertex - scope-38: parallelism=1, memory=2048, java opts=-XX:ErrorFile=<LOG_DIR>/hs_err_pid%p.log -XX:GCTimeLimit=50 -XX:ParallelGCThreads=4 -XX:NewRatio=8 -Djava.net.preferIPv4Stack=true -server -Xmx1024m -Djava.net.preferIPv4Stack=true -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
2015-11-25 15:07:40,672 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Processing aliases: 
2015-11-25 15:07:40,672 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Detailed locations: 
2015-11-25 15:07:40,672 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Pig features in the vertex: 
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,675 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,689 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,689 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,689 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,690 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,716 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - For vertex - scope-48: parallelism=-1, memory=2048, java opts=-XX:ErrorFile=<LOG_DIR>/hs_err_pid%p.log -XX:GCTimeLimit=50 -XX:ParallelGCThreads=4 -XX:NewRatio=8 -Djava.net.preferIPv4Stack=true -server -Xmx1024m -Djava.net.preferIPv4Stack=true -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
2015-11-25 15:07:40,716 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Processing aliases: C
2015-11-25 15:07:40,716 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Detailed locations: C[15,4]
2015-11-25 15:07:40,716 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Pig features in the vertex: 
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,717 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,718 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,718 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,718 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,718 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,718 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,730 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,742 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,743 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,772 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Set VertexManagerPlugin to PartitionerDefinedParallelismVertexManager for vertex scope-50
2015-11-25 15:07:40,773 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - For vertex - scope-50: parallelism=-1, memory=2048, java opts=-XX:ErrorFile=<LOG_DIR>/hs_err_pid%p.log -XX:GCTimeLimit=50 -XX:ParallelGCThreads=4 -XX:NewRatio=8 -Djava.net.preferIPv4Stack=true -server -Xmx1024m -Djava.net.preferIPv4Stack=true -Dlog4j.configuratorClass=org.apache.tez.common.TezLog4jConfigurator -Dlog4j.configuration=tez-container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dtez.root.logger=INFO,CLA 
2015-11-25 15:07:40,773 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Processing aliases: 
2015-11-25 15:07:40,773 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Detailed locations: 
2015-11-25 15:07:40,773 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezDagBuilder - Pig features in the vertex: ORDER_BY
2015-11-25 15:07:40,794 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.mb to 256 from MR setting mapreduce.task.io.sort.mb
2015-11-25 15:07:40,794 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.read.timeout to 180000 from MR setting mapreduce.reduce.shuffle.read.timeout
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead.bytes to 4194304 from MR setting mapreduce.ifile.readahead.bytes
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.ssl.enable to false from MR setting mapreduce.shuffle.ssl.enabled
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.sort.spill.percent to 0.8 from MR setting mapreduce.map.sort.spill.percent
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.ifile.readahead to true from MR setting mapreduce.ifile.readahead
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.merge.percent to 0.66 from MR setting mapreduce.reduce.shuffle.merge.percent
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.parallel.copies to 30 from MR setting mapreduce.reduce.shuffle.parallelcopies
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.shuffle-vertex-manager.min-src-fraction to 0.95 from MR setting mapreduce.job.reduce.slowstart.completedmaps
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.memory.limit.percent to 0.25 from MR setting mapreduce.reduce.shuffle.memory.limit.percent
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.io.sort.factor to 100 from MR setting mapreduce.task.io.sort.factor
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress to true from MR setting mapreduce.map.output.compress
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.connect.timeout to 180000 from MR setting mapreduce.reduce.shuffle.connect.timeout
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.task.input.post-merge.buffer.percent to 0.0 from MR setting mapreduce.reduce.input.buffer.percent
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.compress.codec to com.hadoop.compression.lzo.LzoCodec from MR setting mapreduce.map.output.compress.codec
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.merge.progress.records to 10000 from MR setting mapreduce.task.merge.progress.records
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.internal.sorter.class to org.apache.hadoop.util.QuickSort from MR setting map.sort.class
2015-11-25 15:07:40,795 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.util.MRToTezHelper - Setting tez.runtime.shuffle.fetch.buffer.percent to 0.6 from MR setting mapreduce.reduce.shuffle.input.buffer.percent
2015-11-25 15:07:40,806 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJobCompiler - Total estimated parallelism is 5924
2015-11-25 15:07:40,909 [PigTezLauncher-0] INFO  org.apache.pig.tools.pigstats.tez.TezScriptState - Pig script settings are added to the job
2015-11-25 15:07:40,921 [PigTezLauncher-0] INFO  org.apache.tez.client.TezClient - Tez Client Version: [ component=tez-api, version=0.7.1.1.1511132139, revision=2acbb7df0f8c2fe77d24dbc8c4a7dbeeb3424b24, SCM-URL=scm:git:https://git-wip-us.apache.org/repos/asf/tez.git, buildTime=20151113-2140 ]
2015-11-25 15:07:41,411 [PigTezLauncher-0] INFO  org.apache.hadoop.yarn.client.api.impl.TimelineClientImpl - Timeline service address: http://jetblue-jt1.blue.ygrid.yahoo.com:4080/ws/v1/timeline/
2015-11-25 15:07:41,550 [PigTezLauncher-0] INFO  org.apache.hadoop.yarn.client.RMProxy - Connecting to ResourceManager at jetblue-jt1.blue.ygrid.yahoo.com/10.213.61.83:8032
2015-11-25 15:07:41,668 [PigTezLauncher-0] INFO  org.apache.tez.client.TezClient - Using org.apache.tez.dag.history.ats.acls.EntityFileHistoryACLPolicyManager to manage Timeline ACLs
2015-11-25 15:07:41,673 [PigTezLauncher-0] INFO  org.apache.tez.client.TezClient - Session mode. Starting session.
2015-11-25 15:07:41,673 [PigTezLauncher-0] INFO  org.apache.tez.client.TezClientUtils - Using tez.lib.uris value from configuration: hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020/sharelib/v1/tez/ytez-0.7.1.1.1511132139/libexec/tez,hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020/sharelib/v1/tez/ytez-0.7.1.1.1511132139/libexec/tez/lib
2015-11-25 15:07:41,706 [PigTezLauncher-0] INFO  org.apache.hadoop.hdfs.DFSClient - Created HDFS_DELEGATION_TOKEN token 3378396 for ruiqiang on jetblue-nn1.blue.ygrid.yahoo.com:8020
2015-11-25 15:07:41,706 [PigTezLauncher-0] INFO  org.apache.tez.common.security.TokenCache - Got dt for hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020; Kind: HDFS_DELEGATION_TOKEN, Service: jetblue-nn1.blue.ygrid.yahoo.com:8020, Ident: (HDFS_DELEGATION_TOKEN token 3378396 for ruiqiang)
2015-11-25 15:07:42,030 [PigTezLauncher-0] INFO  org.apache.tez.client.TezClient - Tez system stage directory hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020/tmp/temp-850658025/.tez/application_1447892961767_893972 doesn't exist and is created
2015-11-25 15:07:42,054 [PigTezLauncher-0] INFO  org.apache.hadoop.conf.Configuration.deprecation - fs.default.name is deprecated. Instead, use fs.defaultFS
2015-11-25 15:07:42,204 [PigTezLauncher-0] INFO  org.apache.tez.dag.history.ats.acls.EntityFileHistoryACLPolicyManager - Writing domains for application_1447892961767_893972 to /mapred/timeline/active/application_1447892961767_893972/domainlog-application_1447892961767_893972
2015-11-25 15:07:42,344 [PigTezLauncher-0] INFO  org.apache.tez.dag.history.ats.acls.EntityFileHistoryACLPolicyManager - Created Timeline Domain for History ACLs, domainId=Tez_ATS_application_1447892961767_893972
2015-11-25 15:07:42,885 [PigTezLauncher-0] INFO  org.apache.hadoop.yarn.client.api.impl.YarnClientImpl - Submitted application application_1447892961767_893972
2015-11-25 15:07:42,887 [PigTezLauncher-0] INFO  org.apache.tez.client.TezClient - The url to track the Tez Session: http://jetblue-jt1.blue.ygrid.yahoo.com:8088/proxy/application_1447892961767_893972/
2015-11-25 15:07:48,069 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - Submitting DAG PigLatin:clickfeature-fullbt-join.pig-0_scope-0
2015-11-25 15:07:48,069 [PigTezLauncher-0] INFO  org.apache.tez.client.TezClient - Submitting dag to TezSession, sessionName=PigLatin:clickfeature-fullbt-join.pig, applicationId=application_1447892961767_893972, dagName=PigLatin:clickfeature-fullbt-join.pig-0_scope-0
2015-11-25 15:07:48,074 [PigTezLauncher-0] INFO  org.apache.tez.dag.api.DAG - Inferring parallelism for vertex: scope-48 to be 2000 from 1-1 connection with vertex scope-29
2015-11-25 15:07:48,441 [PigTezLauncher-0] INFO  org.apache.tez.client.TezClient - Submitted dag to TezSession, sessionName=PigLatin:clickfeature-fullbt-join.pig, applicationId=application_1447892961767_893972, dagName=PigLatin:clickfeature-fullbt-join.pig-0_scope-0
2015-11-25 15:07:48,633 [PigTezLauncher-0] INFO  org.apache.hadoop.yarn.client.api.impl.TimelineClientImpl - Timeline service address: http://jetblue-jt1.blue.ygrid.yahoo.com:4080/ws/v1/timeline/
2015-11-25 15:07:48,633 [PigTezLauncher-0] INFO  org.apache.hadoop.yarn.client.RMProxy - Connecting to ResourceManager at jetblue-jt1.blue.ygrid.yahoo.com/10.213.61.83:8032
2015-11-25 15:07:48,640 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - Submitted DAG PigLatin:clickfeature-fullbt-join.pig-0_scope-0. Application id: application_1447892961767_893972
2015-11-25 15:07:48,858 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher - HadoopJobId: job_1447892961767_893972
2015-11-25 15:07:49,641 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 0 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:08:09,641 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 0 Running: 924 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:08:29,642 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 1 Running: 923 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:08:49,642 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 7 Running: 917 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:09:09,642 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 24 Running: 900 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:09:29,643 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 644 Running: 280 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:09:49,642 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 908 Running: 1409 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:10:09,642 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 922 Running: 2002 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:10:29,643 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 924 Running: 2000 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:10:49,643 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 2921 Running: 4 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:11:09,643 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 2923 Running: 2 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:11:29,644 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4924 Succeeded: 2924 Running: 1 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:11:49,644 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4934 Succeeded: 4901 Running: 21 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:12:09,645 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4934 Succeeded: 4920 Running: 11 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:12:29,644 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4934 Succeeded: 4921 Running: 12 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:12:49,644 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4934 Succeeded: 4924 Running: 9 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:13:09,645 [Timer-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=RUNNING, progress=TotalTasks: 4934 Succeeded: 4925 Running: 9 Failed: 0 Killed: 0, diagnostics=, counters=null
2015-11-25 15:13:39,811 [PigTezLauncher-0] INFO  org.apache.tez.common.counters.Limits - Counter limits initialized with parameters:  GROUP_NAME_MAX=256, MAX_GROUPS=1000, COUNTER_NAME_MAX=128, MAX_COUNTERS=5000
2015-11-25 15:13:39,814 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob - DAG Status: status=SUCCEEDED, progress=TotalTasks: 4934 Succeeded: 4934 Running: 0 Failed: 0 Killed: 0, diagnostics=, counters=Counters: 59
	org.apache.tez.common.counters.DAGCounter
		NUM_SUCCEEDED_TASKS=4934
		TOTAL_LAUNCHED_TASKS=4934
		OTHER_LOCAL_TASKS=2041
		DATA_LOCAL_TASKS=592
		RACK_LOCAL_TASKS=291
		AM_CPU_MILLISECONDS=98010
		AM_GC_TIME_MILLIS=1888
	File System Counters
		FILE_BYTES_READ=1106695853240
		FILE_BYTES_WRITTEN=619636908880
		FILE_READ_OPS=0
		FILE_LARGE_READ_OPS=0
		FILE_WRITE_OPS=0
		HDFS_BYTES_READ=1791366329878
		HDFS_BYTES_WRITTEN=225569169
		HDFS_READ_OPS=1327
		HDFS_LARGE_READ_OPS=0
		HDFS_WRITE_OPS=18
	org.apache.tez.common.counters.TaskCounter
		REDUCE_INPUT_GROUPS=9042327389
		REDUCE_INPUT_RECORDS=9042327389
		COMBINE_INPUT_RECORDS=0
		SPILLED_RECORDS=27073820895
		NUM_SHUFFLED_INPUTS=89353
		NUM_SKIPPED_INPUTS=1782000
		NUM_FAILED_SHUFFLE_INPUTS=0
		MERGED_MAP_OUTPUTS=86000
		GC_TIME_MILLIS=1936594
		CPU_MILLISECONDS=161099960
		PHYSICAL_MEMORY_BYTES=4592861970432
		VIRTUAL_MEMORY_BYTES=14478017912832
		COMMITTED_HEAP_BYTES=4592861970432
		INPUT_RECORDS_PROCESSED=9042128742
		OUTPUT_RECORDS=9148249934
		OUTPUT_LARGE_RECORDS=0
		OUTPUT_BYTES=335293703548
		OUTPUT_BYTES_WITH_OVERHEAD=353497551249
		OUTPUT_BYTES_PHYSICAL=211067311995
		ADDITIONAL_SPILLS_BYTES_WRITTEN=327089375540
		ADDITIONAL_SPILLS_BYTES_READ=406942623307
		ADDITIONAL_SPILL_COUNT=3694000
		SHUFFLE_CHUNK_COUNT=4924
		SHUFFLE_BYTES=211028619699
		SHUFFLE_BYTES_DECOMPRESSED=353487992225
		SHUFFLE_BYTES_TO_MEM=210062980348
		SHUFFLE_BYTES_TO_DISK=846701420
		SHUFFLE_BYTES_DISK_DIRECT=118937931
		NUM_MEM_TO_DISK_MERGES=2000
		NUM_DISK_TO_DISK_MERGES=0
		SHUFFLE_PHASE_TIME=66298997
		MERGE_PHASE_TIME=67908857
		FIRST_EVENT_RECEIVED=615003
		LAST_EVENT_RECEIVED=64707128
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	org.apache.pig.PigWarning
		PROGRESS_REPORTER_NOT_PROVIDED=407
	org.apache.pig.backend.hadoop.executionengine.tez.plan.udf.FindQuantilesTez
		PROGRESS_REPORTER_NOT_PROVIDED=407
2015-11-25 15:13:40,000 [PigTezLauncher-0] INFO  org.apache.hadoop.conf.Configuration.deprecation - fs.default.name is deprecated. Instead, use fs.defaultFS
2015-11-25 15:13:40,936 [main] WARN  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher - Encountered Warning PROGRESS_REPORTER_NOT_PROVIDED 407 time(s).
2015-11-25 15:13:40,941 [main] INFO  org.apache.pig.tools.pigstats.tez.TezPigScriptStats - Script Statistics:

       HadoopVersion: 2.6.0.24.1509041917                                                                                 
          PigVersion: 0.14.0.9.1511150240                                                                                 
          TezVersion: 0.7.1.1.1511132139                                                                                  
              UserId: ruiqiang                                                                                            
            FileName: clickfeature-fullbt-join.pig                                                                        
           StartedAt: 2015-11-25 15:07:38                                                                                 
          FinishedAt: 2015-11-25 15:13:40                                                                                 
            Features: HASH_JOIN,ORDER_BY                                                                                  

Success!


DAG 0:
                                    Name: PigLatin:clickfeature-fullbt-join.pig-0_scope-0                                                     
                           ApplicationId: job_1447892961767_893972                                                                            
                      TotalLaunchedTasks: 4934                                                                                                
                           FileBytesRead: 1106695853240                                                                                       
                        FileBytesWritten: 619636908880                                                                                        
                           HdfsBytesRead: 1791366329878                                                                                       
                        HdfsBytesWritten: 225569169                                                                                           
      SpillableMemoryManager spill count: 0                                                                                                   
                Bags proactively spilled: 0                                                                                                   
             Records proactively spilled: 0                                                                                                   

DAG Plan:
Tez vertex scope-27	->	Tez vertex scope-29,
Tez vertex scope-28	->	Tez vertex scope-29,
Tez vertex scope-29	->	Tez vertex scope-38,Tez vertex scope-48,
Tez vertex scope-38	->	Tez vertex scope-48,
Tez vertex scope-48	->	Tez vertex scope-50,
Tez vertex scope-50

Vertex Stats:
VertexId Parallelism TotalTasks   InputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
scope-27         900        900     8708038240              0   888515605431     407127424520  1788223579429                0 A,C		
scope-28          24         24      281127877              0    18663853706      11410587136     3142750449                0 B,C		
scope-29        2000       2000              0              0   197302340382     198034713792              0                0 C	HASH_JOIN,SAMPLER	
scope-38           1          1              0              0        4626130          4623539              0                0 		
scope-48        2000       2000              0              0     1708041205       2560496187              0                0 C		
scope-50          -1          9              0       52961272      501386386        499063706              0        225569169 	ORDER_BY	/projects/qrw/ruiqiang/intersection-bidterm-clickfeature,

Input(s):
Successfully read 8708038240 records (1788223579429 bytes) from: "/projects/clickmodel/ckang/usmlr/sim_20150826/query_qvec_out_combined"
Successfully read 281127877 records (3142750449 bytes) from: "/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser"

Output(s):
Successfully stored 52961272 records (225569169 bytes) in: "/projects/qrw/ruiqiang/intersection-bidterm-clickfeature"

2015-11-25 15:13:40,960 [main] INFO  org.apache.pig.Main - Pig script completed in 6 minutes, 5 seconds and 186 milliseconds (365186 ms)
2015-11-25 15:13:40,960 [main] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezLauncher - Shutting down thread pool
2015-11-25 15:13:40,989 [Thread-11] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezSessionManager - Shutting down Tez session org.apache.tez.client.TezClient@500a9c82
2015-11-25 15:13:40,989 [Thread-11] INFO  org.apache.tez.client.TezClient - Shutting down Tez Session, sessionName=PigLatin:clickfeature-fullbt-join.pig, applicationId=application_1447892961767_893972
2015-11-25 15:13:41,017 [Thread-11] INFO  org.apache.tez.client.TezClient - Waiting until application is in a final state
