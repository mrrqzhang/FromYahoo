#!/bin/sh

USAGE="Usage: `basename $0` -:r:s:e:h"



root=/projects/qrw/ruiqiang/GreedySelection-click/

inputroot=/projects/qrw/ruiqiang/Gemini/smtrewrite_*/decode-*-secondpass/postprocess/part*
nwbidtermsroot=''
bidtermSet=''
whitelist=''
start=0
end=0
MinRelScore=0.9
topn=160
topm=50 
numSplit=20000
HighEcpmBidterm=10000000 # max high ecpm bidterm

while getopts "s:e:r:i:b:m:n:w:W:h" OPT; do
     case "$OPT" in
        s)
          start=$OPTARG
          ;;
        e)
          end=$OPTARG
          ;;
        r)
          root=$OPTARG
          ;;
        i)
          inputroot=$OPTARG
          ;;
	w)
	  whitelist=$OPTARG
          ;;
        W)
          bidtermSet=$OPTARG
          ;;
        b)
          nwbidtermsroot=$OPTARG
          ;;
        m)
          mthreshold=$OPTARG
          ;;
        n) 
          nthreshold=$OPTARG
          ;;
        \?)
          echo "$USAGE"
          exit 1
          ;;
     esac
done

qrwroot=$root/qrw
highecpmroot=$root/ecpmbidterm
indexbidtermroot=$root/indexbidterm
queryfeatureroot=$root/queryfeature
nwbidtermsroot=$root/clickfeatures
btselectroot=$root/bidtermselect
clickroot=$root/clickfeature
mergeroot=$root/merge
ecpmroot=$root/rankedbyecpm
scoreroot=$root/clickfeaturscore/
final=$root/final
qlasInput=$root/qlasqueries
qlasroot=$root/qlas
locroot=$root/location
nonavroot=$root/nonav
postprocess=$root/postprocess-small

# joined query list (clickfeature, whitelist, all bidterm ). only (whitelist, all bidterm) with click feature are output.
if [ 1 -eq "$(echo "1 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 1" | bc)" ]; then
	hadoop fs -rm -r $highecpmroot
	sh dopig.sh extract-broad-ecpm.pig "-p  out=$highecpmroot -p input=/tmp/data_for_hong_new/ -p MaxBidterm=$HighEcpmBidterm"
fi

if [ 1 -eq "$(echo "2 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 2" | bc)" ]; then
     sh dopig.sh predict_query_vector2files.pig "-param output=$nwbidtermsroot -p wlist=$whitelist -p bt=$highecpmroot"
fi

if [ 1 -eq "$(echo "2.2 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 2.2" | bc)" ]; then
	hadoop fs -rm -r $indexbidtermroot
	hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec \
		                        -Dfs.permissions.umask-mode=022 \
					-Dmapreduce.job.queue.name=$queue -Dmapreduce.reduce.memory.mb=8192 -Dmapreduce.child.ulimit=7340032 \
					-Dmapred.child.java.opts=-Xmx8192m \
				        -Dmapreduce.cluster.acls.enabled=false \
				        -Dmapreduce.job.acl-view-job=* \
				        -Dmapreduce.job.acl-modify-job=* \
					-files 'split-reducer.sh' \
				        -Dmapreduce.job.reduces=1000 \
				        -Dmapred.text.key.partitioner.options=-k1,1 \
				        -jobconf mapreduce.task.timeout=0 \
				        -input $nwbidtermsroot \
				        -output $indexbidtermroot \
				        -mapper 'cat' \
					-reducer "sh split-reducer.sh $numSplit"
		#			-reducer "awk  -F '\\t' -v seg=$numSplit -v random=$RANDOM '{print (NR+random)%seg\"\\t\"\$0}'" 

fi
if [ 1 -eq "$(echo "3 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 3" | bc)" ]; then
	sh dopig.sh joincfquery.pig "-p input=$whitelist -p clickroot=$nwbidtermsroot -p out=$queryfeatureroot"
	hadoop fs -rm /projects/qrw/ruiqiang/input-query-for-rewrite.txt
	hadoop fs -cat $queryfeatureroot/part* | gunzip > input-query-for-rewrite.txt
	hadoop fs -copyFromLocal input-query-for-rewrite.txt /projects/qrw/ruiqiang/input-query-for-rewrite.txt
fi
if [ 1 -eq "$(echo "4 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 4" | bc)" ]; then
	hadoop fs -rm -r $qrwroot
	cmd="hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar -Dfs.permissions.umask-mode=022 -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec \
	                        -libjars $PWD/jyjudfs.jar  -files 'join.sh,query-bidterm-distance,hdfs://jetblue-nn1.blue.ygrid.yahoo.com/projects/qrw/ruiqiang/input-query-for-rewrite.txt'  -Dfs.permissions.umask-mode=022 -Dmapreduce.job.queue.name=$queue -Dmapreduce.reduce.memory.mb=2048 \
				-Dmapreduce.child.ulimit=7340032         -Dmapred.child.java.opts=-Xmx2048m  -Dmapreduce.cluster.acls.enabled=false -Dmapreduce.job.acl-view-job=* \
				-Dmapreduce.job.acl-modify-job=* -Dmapreduce.job.reduces=$numSplit -Dmapred.text.key.partitioner.options=-k1,1 -jobconf mapreduce.task.timeout=0 \
				-input $indexbidtermroot -output $qrwroot -mapper 'cat' -reducer \"sh join.sh\" -partitioner jyjudfs.SimplePartitioner "
       echo $cmd	
       eval $cmd	
fi
	


if [ 1 -eq "$(echo "5 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 5" | bc)" ]; then
	sh dopig.sh gen-qlas-query.pig "-p MinScore=0.8 -p input=$qrwroot -p qlasout=$qlasInput -p scoreout=$mergeroot"
fi

if [ 1 -eq "$(echo "6 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 6" | bc)" ];  then
    hadoop fs -rmr $qlasroot
    cmd="hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar -Dfs.permissions.umask-mode=022 \
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
fi

if [ 1 -eq "$(echo "7 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 7" | bc)" ]; then
    sh  dopig.sh  locationhandling.pig "-p out=$locroot -p qlas=$qlasroot -p input=$mergeroot"
fi

#ecpm join. ranked by ecpm and remove non-bidterm from whitelist
if [ 1 -eq "$(echo "8 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 8" | bc)" ]; then
	sh dopig.sh ecpmjoin.pig "-Dmapred.output.compress=true -p topn=$topm -p MinScore=$MinRelScore -p bt=$locroot -p ecpm=$highecpmroot -p out=$ecpmroot"
fi

#for bpb only
if [ 1 -eq "$(echo "9 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 9" | bc)" ]; then
#	sh dopig.sh postprocess-for-bpb.pig "-Dmapreduce.map.memory.mb=1024 -Dmapred.output.compress=true -p out=$postprocess  -p input=$ecpmroot/part*"
	hadoop fs -rmr $postprocess
	cmd="hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar -Dfs.permissions.umask-mode=022 -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec \
		-Dmapred.job.queue.name=default  \
		-files 'postprocess-for-bpb-small.py' \
		-input $ecpmroot/part* \
		-output  $postprocess \
		-mapper 'cat' \
		-jobconf mapred.reduce.tasks=100 \
		-reducer 'python postprocess-for-bpb-small.py'  "
	echo $cmd
	eval $cmd

fi

