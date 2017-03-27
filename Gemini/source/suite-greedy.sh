#!/bin/sh

USAGE="Usage: `basename $0` -:r:s:e:h"



root=/projects/qrw/ruiqiang/GreedySelection-click/

inputroot=/projects/qrw/ruiqiang/Gemini/smtrewrite_*/decode-*-secondpass/postprocess/part*
nwbidtermsroot=''
bidtermSet=''
whitelist=''
start=0
end=0
mthreshold=0.9
nthreshold=0.8
topn=160
topm=50 
numSplit=4000


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
indexbidtermroot=$root/indexbidterm
queryfeatureroot=$root/queryfeature
#nwbidtermsroot=$root/nwbidterms
btselectroot=$root/bidtermselect
clickroot=$root/clickfeature
mergeroot=$root/merge
ecpmroot=$root/ecpm
scoreroot=$root/clickfeaturscore/
final=$root/final
qlasInput=$root/merge/qlasqueries
qlasroot=$root/qlas
locroot=$root/location
nonavroot=$root/nonav

# joined query list (clickfeature, whitelist, all bidterm ). only (whitelist, all bidterm) with click feature are output.
if [ 1 -eq "$(echo "1 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 1" | bc)" ]; then
	hadoop fs -rm -r $btselectroot
	sh dopig.sh bidtermreduction.pig "-p  out=$btselectroot -p input=$bidtermSet"
fi

if [ 1 -eq "$(echo "2 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 2" | bc)" ]; then
     sh dopig.sh predict_query_vector2files.pig "-param output=$nwbidtermsroot -p wlist=$whitelist -p bt=$btselectroot"
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
				        -Dmapreduce.job.reduces=1000 \
				        -Dmapred.text.key.partitioner.options=-k1,1 \
				        -jobconf mapreduce.task.timeout=0 \
				        -input $nwbidtermsroot \
				        -output $indexbidtermroot \
				        -mapper 'cat' \
				        -reducer "awk  -F '\\t' -v seg=$numSplit '{print NR%seg\"\\t\"\$0}'" 

fi
if [ 1 -eq "$(echo "2.4 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 2.4" | bc)" ]; then
#	sh dopig.sh joincfquery.pig "-p input=$whitelist -p clickroot=$nwbidtermsroot -p out=$queryfeatureroot"
	hadoop fs -rm /projects/qrw/ruiqiang/input-query-for-rewrite.txt
	hadoop fs -cat $queryfeatureroot/part* | gunzip > input-query-for-rewrite.txt
	hadoop fs -copyFromLocal input-query-for-rewrite.txt /projects/qrw/ruiqiang/input-query-for-rewrite.txt
	hadoop fs -rm -r $qrwroot
	cmd="hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec \
	                        -libjars $PWD/../jyjudfs.jar  -files 'join.sh,query-bidterm-distance.py,greedy-selection-token.py,hdfs://jetblue-nn1.blue.ygrid.yahoo.com/projects/qrw/ruiqiang/input-query-for-rewrite.txt'  -Dfs.permissions.umask-mode=022 -Dmapreduce.job.queue.name=$queue -Dmapreduce.reduce.memory.mb=8192 \
				-Dmapreduce.child.ulimit=7340032         -Dmapred.child.java.opts=-Xmx8192m  -Dmapreduce.cluster.acls.enabled=false -Dmapreduce.job.acl-view-job=* \
				-Dmapreduce.job.acl-modify-job=* -Dmapreduce.job.reduces=$numSplit -Dmapred.text.key.partitioner.options=-k1,1 -jobconf mapreduce.task.timeout=0 \
				-input $indexbidtermroot -output $qrwroot -mapper 'cat' -reducer \"sh join.sh\" -partitioner jyjudfs.SimplePartitioner "
       echo $cmd	
       eval $cmd	
fi
	
	#this step takes 10hr. generate all COW bidterms that similar to whitelist  
#if [ 1 -eq "$(echo "3 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 3" | bc)" ]; then
#     hadoop fs -rm -r $qrwroot
#     sh dopig.sh greedy-selection.pig "-p inputqry=$inputroot  -p inputbt=$nwbidtermsroot -p out=$qrwroot" 
#fi
#this step takes 2hr
if [ 1 -eq "$(echo "4 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 4" | bc)" ]; then
    sh dopig.sh joinclickfeature2.pig "-p threshold=$nthreshold -p topn=$topn -p input=$qrwroot -p clickroot=$nwbidtermsroot -p out=$scoreroot"
fi


if [ 1 -eq "$(echo "5 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 5" | bc)" ]; then
    sh dopig.sh join-advertiser.pig "-p rewrite=$scoreroot/thresholdcut -p out=$mergeroot"
fi

if [ 1 -eq "$(echo "6 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 6" | bc)" ];  then
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
fi

if [ 1 -eq "$(echo "7 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 7" | bc)" ]; then
    sh  dopig.sh  locationhandling.pig "-p out=$locroot -p qlas=$qlasroot -p input=$mergeroot/rewrites"
fi
if [ 1 -eq "$(echo "8 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 8" | bc)" ]; then
    sh dopig.sh ecpmjoin.pig "-Dmapred.output.compress=false -p topn=$topm  -p bt=$locroot -p ecpm=/projects/qrw/ruiqiang/ECPM/ -p out=$ecpmroot" 
fi

#if [ 1 -eq "$(echo "8 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 8" | bc)" ]; then
#    hadoop fs -copyFromLocal nav_query_entropy_filtered.tsv /projects/qrw/ruiqiang/Gemini/
#    sh dopig.sh remove-navi-query.pig "-Dmapred.output.compress=false -p input=$ecpmroot -p navq=/projects/qrw/ruiqiang/Gemini/nav_query_entropy_filtered.tsv  -p out=$nonavroot"
#fi




