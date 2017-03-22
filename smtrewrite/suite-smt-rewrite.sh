#!/bin/sh

USAGE="Usage: `basename $0` -:r:P:Q:s:e:a:c:v:b:d:f:g:l:n:w:m:M:i:q:i:t:T:h"

#root="/tmp/cb_nctr/ruiqiang/smtrewrite"
root="ss/match/smt/smtrewrite/trv"
dectag='decode'
#queue=curveball_small
#queue=curveball_med
queue=search_mlr

compress="-Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec"
start=0
end=0
#cobidtermInput=/user/cb_nctr/ruiqiang_gemini/bidtermpairs/
#bidtermInput=/tmp/bidTermsNew/
bidtermInput=ss/match/scrape_qbert/trv/canon.qbert

rwbidterm=$bidtermInput

mode=
#trainingreducernumber=100
trainingreducernumber=20
decodeInput=/tmp/cb_nctr/ruiqiang/input.txt
nmreducer=3000
nmodel=$trainingreducernumber
nbest=1000
diffscore=-5
numRw=100
fullbidterm=hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/haocheng/ss/match/adhoc/cow/data/all_bid_terms/201508260000.bz2/
unit_weight=hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020/projects/clickmodel/ckang/usmlr/gen_clicksim/unit_weight.txt
unit_vector=hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020/projects/clickmodel/ckang/usmlr/gen_clicksim/unit_vector_truncated.gz
query_vector=hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020/projects/clickmodel/ckang/usmlr/sim_20150826/query_qvec_out_combined
btfilterroot=
vertical=auto
verticaladvertiserlist=auto.txt
cowdate=201512110000
arbitriage=hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/advertiser-blacklist-binlu.txt


while getopts "r:P:Q:s:e:a:c:v:b:d:f:g:l:n:w:m:M:i:q:i:t:T:h" OPT; do
     case "$OPT" in
        r)
          root=$OPTARG
          ;;
        b)
          nbest=$OPTARG
          ;;
        q)
          queue=$OPTARG
          ;;
        a)
          verticaladvertiserlist=$OPTARG
          ;;
	T)
	  arbitriage=$OPTARG
          ;;
        P)
          bidtermInput=$OPTARG
          ;;
        Q)
	  rwbidterm=$OPTARG
	  ;;
        s)
          start=$OPTARG
          ;;
        e)
          end=$OPTARG
          ;;
        f)
          diffscore=$OPTARG
          ;;
        g)
          numRw=$OPTARG
          ;;
        d)
          dectag=$OPTARG
          ;;
        l)
          nmreducer=$OPTARG
          ;;
        n)
          trainingreducernumber=$OPTARG
          ;;
        m)
          mode=$OPTARG
          ;;
        w)
          fullbidterm=$OPTARG
          ;;
        M)
          modelInput=$OPTARG
          ;;
        i) 
          decodeInput=$OPTARG
          ;;
        t)
          btfilterroot=$OPTARG
          ;;
        v)
          vertical=$OPTARG
          ;;
        c)
          cowdate=$OPTARG
          ;;

        h)
          echo "$USAGE"
          exit 1
          ;;

        \?)
          echo "$USAGE"
          exit 1
          ;;
     esac
done

nmodel=$trainingreducernumber
cowroot=$root/cow
broot=$root/train/bidterms
adgroot=$root/train/adgrouproot
smtroot=$root/train/smt_model
w2vroot=$root/train/word2vec
minroot=$root/train/minroot
onlinemodelroot=$root/train/onlinemodel

qfroot1=$root/$dectag/qfile1  #queryfile
qfroot2=$root/$dectag/qfile2
decoderoot=$root/$dectag/translations
qrwroot=$root/$dectag/qrw
qadroot=$root/$dectag/qadscore
toprewriteroot=$root/$dectag/toprewrite
bidpricezmroot=$root/$dectag/bidpricezeromatch
zmroot=$root/$dectag/zeromatch
if [ ! $btfilterroot  ]; then
    btfilterroot=$root/$dectag/btfilter
fi
dftoprewriteroot=$root/$dectag/domainfreetoprewriter
clickroot=$root/$dectag/clickfeatures
bidpricetoprewriteroot=$root/$dectag/bidpricetoprewriter
postclickroot=$root/$dectag/postclickrewrite
clickgreedy=$root/greedy/clickfeatures
greedyroot=$root/greedy



if [ $mode == "train" ]; then
    if [ 1 -eq "$(echo "1 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 1" | bc)" ]; then
        cwd=`pwd`
        cd $cwd/cow
        sh suite-cow.sh -s 1 -e 5 -r $cowroot -a $verticaladvertiserlist -v $vertical -w vertical -c $cowdate
        cd $cwd 
    fi
    if [ 1 -eq "$(echo "2 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 2" | bc)" ]; then
        hadoop fs -rm -r -skipTrash $broot
        sh dopig.sh co-bidterm-pair.pig "-p input=$cowroot/$vertical/$cowdate/bid_term -p out=$broot" $queue
    fi
    if [ 1 -eq "$(echo "3 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 3" | bc)" ]; then
        hadoop fs -rm -r -skipTrash $adgroot
        sh dopig.sh recap-train-id.pig "-p input=$broot -p out=$adgroot" $queue
    fi


    if [ 1 -eq "$(echo "4 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 4" | bc)" ]; then
        hadoop fs -rm -r -skipTrash $smtroot
        hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar \
                -libjars $PWD/jyjudfs.jar \
                -files smtreducer.sh,insert-null.py \
                -Dfs.permissions.umask-mode=022 \
                -Dmapred.child.java.opts=-Xmx4096m \
                -Dmapreduce.reduce.java.opts=-Xmx4096m \
                -Dmapred.job.queue.name=$queue -Dmapred.job.map.memory.mb=4096 -Dmapreduce.reduce.memory.mb=4096 -Dmapred.child.ulimit=7340032 \
                -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec \
                -Dmapreduce.cluster.acls.enabled=false \
                -Dmapred.text.key.partitioner.options=-k1,1 \
                -Dmapreduce.job.acl-view-job=* \
                -Dmapreduce.job.acl-modify-job=* \
                -input $adgroot/data \
                -output $smtroot \
                -mapper "cat" \
                -reducer smtreducer.sh \
		-partitioner jyjudfs.SimplePartitioner \
                -jobconf mapred.reduce.tasks=$trainingreducernumber \
                -jobconf mapreduce.task.timeout=0 \
                -cacheArchive 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com/user/ruiqiang/distcachesrc/moses-bin-scripts.jar#moses' \
                -cacheArchive 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com/user/ruiqiang/distcachesrc/mgiza.jar#mgiza'
    fi
#minimize translation table
    if [ 1 -eq "$(echo "5 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 5" | bc)" ]; then
        hadoop fs -rm -r -skipTrash $minroot
        sh dopig.sh minimize-table.pig "-p smtroot=$smtroot/part* -p out=$minroot"
    fi
fi

if [ $mode == "test" ] || [ $mode == "onlinetest" ] ; then
    if [ 1 -eq "$(echo "1 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 1" | bc)" ]; then
        hadoop fs -rm -r -skipTrash $qfroot1 $qfroot2
        nfs=$(( $nmreducer/$nmodel ))
        hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar \
                -Dfs.permissions.umask-mode=022 \
                -Dmapreduce.job.queue.name=$queue -Dmapreduce.reduce.memory.mb=4096 -Dmapreduce.child.ulimit=7340032 \
                -Dmapred.child.java.opts=-Xmx4096m \
                -Dmapreduce.cluster.acls.enabled=false \
                -Dmapreduce.job.acl-view-job=* \
                -Dmapreduce.job.acl-modify-job=* \
                -Dmapreduce.job.maps=$nfs \
                -Dmapreduce.job.reduces=$nfs \
                -jobconf mapreduce.task.timeout=0 \
                -input $decodeInput \
                -output $qfroot1 \
                -mapper 'cat' \
                -reducer 'cat'
        hadoop fs -mkdir $qfroot2
        sh file_id.sh $nfs $nmodel $qfroot1 $qfroot2
        #sh dopig.sh prepare-test-query.pig "-p INPUT=$decodeInput -p OUTPUT=$qfroot2 -p PARTITIONS=$nmodel" $queue
    fi

    if [ 1 -eq "$(echo "2 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 2" | bc)" ]; then
        hadoop fs -rm -r -skipTrash $decoderoot
        modelUsed=$smtroot
        if [ $mode == "onlinetest" ] ; then
                modelUsed=$minroot
        fi
        hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar $compress \
                -libjars $PWD/jyjudfs.jar \
                -files $PWD/mosesreducer.sh,$PWD/moses.ini \
                -Dfs.permissions.umask-mode=022 \
                -Dmapreduce.job.queue.name=$queue -Dmapreduce.reduce.memory.mb=8192 -Dmapreduce.child.ulimit=7340032 \
                -Dmapred.child.java.opts=-Xmx8192m \
                -Dmapreduce.cluster.acls.enabled=false \
                -Dmapreduce.job.acl-view-job=* \
                -Dmapreduce.job.acl-modify-job=* \
                -Dmapreduce.job.reduces=$nmreducer \
                -Dmapred.text.key.partitioner.options=-k1,1 \
                -jobconf mapreduce.task.timeout=0 \
                -input $qfroot2 \
                -output $decoderoot \
                -mapper 'cat' \
                -reducer "sh mosesreducer.sh $modelUsed $nmodel $nbest" \
                -partitioner jyjudfs.SimplePartitioner \
                -cacheArchive 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com/user/ruiqiang/distcachesrc/moses-bin-scripts.jar#moses'
    fi
        
    if [ 1 -eq "$(echo "3 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 3" | bc)" ]; then
        hadoop fs -rm -r -skipTrash $qrwroot
        sh dopig.sh extract-qrw.pig "-p out=$qrwroot -p input=$decoderoot" $queue 500 # number reducer
    fi

    if [ 1 -eq "$(echo "4 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 4" | bc)" ]; then
        cwd=`pwd`
        cd $cwd/cow
	sh dopig.sh all_bid_term_blackadvertiser_group_id.pig "-p arbitriage=$arbitriage -p COW_DATE=$cowdate -p root=$fullbidterm"
        cd $cwd
    fi

    if [ 1 -eq "$(echo "5 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 5" | bc)" ]; then
        hadoop fs -rm -r -skipTrash $btfilterroot
        sh dopig.sh bidterm-join.pig "-p qrwroot=$qrwroot -p out=$btfilterroot -p fullbidterm=$fullbidterm/normal-advertiser" $queue
    fi

    if [ 1 -eq "$(echo "6 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 6" | bc)" ]; then
        hadoop fs -rm -r -skipTrash $dftoprewriteroot
        hadoop fs -rm -r -skipTrash  $bidpricetoprewriteroot
        hadoop jar $HADOOP_PREFIX/share/hadoop/tools/lib/hadoop-streaming.jar \
                -files $PWD/select-top-rewrite-noadgroup.py \
                -Dfs.permissions.umask-mode=022 \
                -Dmapreduce.job.queue.name=$queue -Dmapreduce.reduce.memory.mb=4096 -Dmapreduce.child.ulimit=7340032 \
                -Dmapred.text.key.partitioner.options=-k1,1 \
                -Dmapred.child.java.opts=-Xmx4096m \
                -Dmapreduce.cluster.acls.enabled=false \
                -Dmapreduce.job.acl-view-job=* \
                -Dmapreduce.job.acl-modify-job=* \
                -Dmapreduce.job.reduces=1000 \
                -jobconf mapred.task.timeout=0 \
                -input $btfilterroot \
                -output $dftoprewriteroot \
                -mapper 'cat' \
                -reducer "python select-top-rewrite-noadgroup.py $numRw $diffscore"

    fi

    if [ 1 -eq "$(echo "7 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 7" | bc)" ]; then
	hadoop fs -rm -r -skipTrash $clickroot
        sh dopig.sh predict_query_vector.pig "-param output=$clickroot -param unit_weight=$unit_weight -param unit_vector=$unit_vector -param query_vector=$query_vector -param input=$dftoprewriteroot"
    fi

    if [ 1 -eq "$(echo "8 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 8" | bc)" ]; then
        hadoop fs -rm -r -skipTrash $postclickroot
	sh dopig.sh joinclickfeature.pig "-Dmapred.output.compress=false -p input=$dftoprewriteroot -p clickroot=$clickroot -p out=$postclickroot" 
    fi

    if [ 1 -eq "$(echo "9 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 9" | bc)" ]; then
        cwd=`pwd`
        cd $cwd/greedy
        sh suite-greedy.sh -s 1 -e 8 -r  $greedyroot -w $decodeInput -W $fullbidterm/normal-advertiser -b $clickgreedy -i $postclickroot
        cd $cwd 
    fi
fi
