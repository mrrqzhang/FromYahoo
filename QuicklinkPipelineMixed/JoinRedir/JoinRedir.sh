input=$1
output=$2
feats=$3
table=${4:-url} # crawledurl
wmv=${5:-wm-2014-12-02-02-43-09}
queue=${6:-default}
start=${7:-1}
end=${8:-4}

if [ 1 -eq "$(echo "1 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 1" | bc)" ]; then
    if [[ `hadoop fs -ls /webmap/batches/$wmv` == "" ]] ; then
        echo "Webmap version $wmv does not exist any more!" 
        exit 
    fi
    hadoop fs -rm -r $input.redir.0
    hadoop jar /home/jyj/mylib/jars/webmap-table-format-2.5.0.jar com.yahoo.corp.yst.webmap.input.example.FieldsDump -Dmapred.job.queue.name=$queue -Dfieldsdump.maps=200 -Dfieldsdump.reduces=1000 -Dmapred.map.tasks=200 -Dmapred.reduce.tasks=1000 -Dfieldsdump.fields=url,redirtarget -Dfieldsdump.map=$table -Dfieldsdump.atoms=/webmap/batches/$wmv/atoms -Dfieldsdump.mode=iterate -Dfieldsdump.input=$input -Dfieldsdump.output=$input.redir.0
fi

if [ 1 -eq "$(echo "2 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 2" | bc)" ]; then

    hadoop fs -rm -r $input.combined $input.redir
    bash dopig.sh CombineUrlRedir.pig $queue 100 0 0 "-p in1=$input -p in2=$input.redir.0 -p out=$input.combined -p out2=$input.redir"
fi

if [ 1 -eq "$(echo "3 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 3" | bc)" ]; then

    if [[ `hadoop fs -ls /webmap/batches/$wmv` == "" ]] ; then
        echo "Webmap version $wmv does not exist any more!"
        exit
    fi


    hadoop fs -rm -r $output.combined
    hadoop jar /home/jyj/mylib/jars/webmap-table-format-2.5.0.jar com.yahoo.corp.yst.webmap.input.example.FieldsDump -Dmapred.job.queue.name=$queue -Dfieldsdump.maps=200 -Dfieldsdump.reduces=1000 -Dmapred.map.tasks=200 -Dmapred.reduce.tasks=1000 -Dfieldsdump.fields=url,$feats -Dfieldsdump.map=$table -Dfieldsdump.atoms=/webmap/batches/$wmv/atoms -Dfieldsdump.mode=iterate -Dfieldsdump.input=$input.combined -Dfieldsdump.output=$output.combined
fi 

if [ 1 -eq "$(echo "4 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 4" | bc)" ]; then
    hadoop fs -rm -r $output
    bash dopig.sh JoinRedir.pig $queue 100 0 0 "-p in1=$output.combined -p in2=$input.redir -p out=$output"
fi
