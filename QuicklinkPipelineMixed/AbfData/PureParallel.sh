mode=${1:-"master"} # mapper, reducer
if [[ $mode == "mapper" ]] ; then
    cat
elif [[ $mode == "reducer" ]] ; then
    outputhdfsdir=$2
    cmd=$3
    while read fn ; do 
        fnt=`echo $fn | awk -F '-' '{print $NF}' | awk -F '\\.' '{print $1}'`
        echo $fn, $fnt
        hadoop fs -cat $fn | $cmd > /dev/stdout | hadoop fs -put /dev/stdin $outputhdfsdir/part-r-$fnt
    done
else

    inputhdfsdir=$2
    outputhdfsdir=$3
    

    reducer=${4:-"cat"}
    import=${5:-""}
    files=PureParallel.sh
    arrIn=(${import//,/ })
    for i in $arrIn ; do
        files=$files,$i
    done
    echo files=$files
    nreduce=${6:-"100"}
    queue=${7:-"default"}
    hadoop fs -mkdir -p $outputhdfsdir
    hadoop fs -chmod -R 777 $outputhdfsdir

    hadoop fs -ls $inputhdfsdir | grep $inputhdfsdir | awk '{print $NF}' | grep part > /dev/stdout | hadoop fs -put /dev/stdin $outputhdfsdir/inputfiles.txt

    hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=-k1,1 -Dmapreduce.job.reduces=$nreduce -Dmapred.job.queue.name=$queue -file $files -input $outputhdfsdir/inputfiles.txt -output $outputhdfsdir/output.log -mapper "sh PureParallel.sh mapper" -reducer "sh PureParallel.sh reducer $outputhdfsdir $reducer"
fi
