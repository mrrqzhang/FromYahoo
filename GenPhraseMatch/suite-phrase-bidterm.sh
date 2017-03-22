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
ngrambidtermroot=$root/ngrambidterm
phrasengramroot=$root/phrasengram
indexbidtermroot=$root/indexbidterm
queryfeatureroot=$root/queryfeature
nwbidtermsroot=$root/clickfeatures
btselectroot=$root/bidtermselect
clickroot=$root/clickfeature
mergeroot=$root/merge
combinedroot=$root/combined
highrelroot=$root/highrel
scoreroot=$root/clickfeaturescore/
final=$root/final
qlasInput=$root/qlasqueries
qlasroot=$root/qlas
locroot=$root/location
nonavroot=$root/nonav


if [ 1 -eq "$(echo "1 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 1" | bc)" ]; then
	hadoop fs -rm -r $phrasengramroot
	sh dopig.sh phrase-ngram-bidterm.pig "-p  out=$phrasengramroot -p input=$whitelist -p golden=/projects/qrw/ruiqiang/DirForPhraseGolden/phrasematchgolenset.txt" 
fi

if [ 1 -eq "$(echo "2 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 2" | bc)" ]; then
	hadoop fs -rm -r $ngrambidtermroot
	sh dopig.sh join-bidterm.pig "-p bidterm=/projects/qrw/ruiqiang/phrase-bidterm-from-hong.txt -p phrases=$phrasengramroot -p out=$ngrambidtermroot"
fi

# use both q and p in scoring
if [ 1 -eq "$(echo "3 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 3" | bc)" ]; then
     sh dopig.sh predict_query_vector.pig "-param output=$nwbidtermsroot  -p input=$ngrambidtermroot"
fi


if [ 1 -eq "$(echo "4 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 4" | bc)" ]; then
	sh dopig.sh joinclickfeature2.pig " -p topn=$topn -p threshold=$MinRelScore -p input=$ngrambidtermroot -p clickroot=$nwbidtermsroot -p out=$scoreroot"	
fi




if [ 1 -eq "$(echo "5 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 5" | bc)" ]; then
	sh dopig.sh gen-qlas-query.pig "-p MinScore=0.8 -p input=$scoreroot/thresholdcut -p qlasout=$qlasInput -p scoreout=$mergeroot"
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

if [ 1 -eq "$(echo "8 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 8" | bc)" ]; then
    sh  dopig.sh  locationhandling.pig "-p out=$locroot -p qlas=$qlasroot -p input=$mergeroot"
fi

#ecpm join. ranked by ecpm and remove non-bidterm from whitelist
if [ 1 -eq "$(echo "9 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 9" | bc)" ]; then
	sh dopig.sh highrelscore.pig "-Dmapred.output.compress=true -p topn=$topm -p MinScore=$MinRelScore -p bt=$locroot  -p out=$highrelroot"
fi

if [ 1 -eq "$(echo "10 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 10" | bc)" ]; then
	sh dopig.sh merge_old_golden_set.pig "-p golden=/projects/qrw/ruiqiang/DirForPhraseGolden/phrasematchgolenset.txt -p input=$highrelroot/goldenset -p out=$combinedroot"
fi

