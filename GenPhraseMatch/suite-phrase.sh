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
highecpmroot=$root/ecpmbidterm
phrasengramroot=$root/phrasengram
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
	hadoop fs -rm -r $highecpmroot
	sh dopig.sh extract-phrase-ecpm.pig "-p  out=$highecpmroot -p input=/tmp/data_for_hong_new/"
fi
if [ 1 -eq "$(echo "2 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 2" | bc)" ]; then
	sh dopig.sh phrase-ngram.pig "-p  out=$phrasengramroot -p input=/tmp/data_for_hong_new/"
fi	

if [ 1 -eq "$(echo "3 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 3" | bc)" ]; then
     sh dopig.sh predict_query_vector2files.pig "-param output=$nwbidtermsroot -p wlist=$phrasengramroot -p bt=$highecpmroot"
fi

#this step takes 2hr
if [ 1 -eq "$(echo "4 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 4" | bc)" ]; then
    sh dopig.sh joinclickfeature2.pig "-p threshold=$nthreshold -p topn=$topn -p input=$phrasengramroot -p clickroot=$nwbidtermsroot -p out=$scoreroot"
fi

exit

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





