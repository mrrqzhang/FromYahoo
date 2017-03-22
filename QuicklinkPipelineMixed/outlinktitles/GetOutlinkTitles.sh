# input format is domain (possibly normalized), quicklink (possibly http[s] stripped), other stuff
queue=default
root=QuickLinkGeneration.abf.bak
aroot=$root/AdhocTitles
oroot=$root/outlinktitles
urlfile=$oroot/urlfile
wmfile=wm-2015-02-10-21-07-25
inputfile=${4:-$aroot/joined-with-oldtitle}
dryrun=${1:-0}
start=${2:-1}
end=${3:-3}
exploreurls=${5:-"$oroot/explore"}
explored=${6:-"$oroot/explored"}


outlinkfile=$oroot/outlinks

mylibloc=/homes/jyj/mylib
if [ ! -e $mylibloc ] ; then
    mylibloc=/home/jyj/mylib
fi

if [ 1 -eq "$(echo "1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1" | bc)" ]; then

    hadoop fs -mkdir -p $oroot

    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -Dstream.num.map.output.key.fields=1 -Dmapreduce.job.reduces=100 -Dmapred.job.queue.name=$queue -outputformat jyjudfs.CustomOutputFormat -file $mylibloc/genLibs.py -input $inputfile -output $urlfile -mapper \"python genLibs.py ApplyFuncToCol urlfixesStrong,0\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"cut -f1\""
    echo $cmd
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $urlfile
        eval $cmd
    fi
fi

if [ 1  == 0 ] ; then 
    # we skip this in favor of the simpler approach of domain outlinks only

    # =========================== #
    # Explore domains and parents #
    # =========================== #

    if [ 1 -eq "$(echo "2.1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.1" | bc)" ]; then
        # try all kinds of domain possibilities
        cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -files ExploreDomains.py,$mylibloc/genLibs.py -libjars $mylibloc/jars/jyjudfs.jar -Dstream.num.map.output.key.fields=1 -Dmapreduce.job.reduces=100 -Dmapred.job.queue.name=$queue -outputformat jyjudfs.CustomOutputFormat -input $urlfile -output $exploreurls -mapper \"python ExploreDomains.py\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer NONE"

        echo $cmd

        if [ $dryrun == 0 ] ; then
            hadoop fs -rm -r $exploreurls
            eval $cmd
        fi
    fi

    if [ 1 -eq "$(echo "2.2 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.2" | bc)" ]; then
        cmd="hadoop jar /home/jyj/mylib/jars/webmap-table-format-2.5.0.jar com.yahoo.corp.yst.webmap.input.example.FieldsDump -Dmapred.job.queue.name=$queue -Dfieldsdump.maps=100 -Dfieldsdump.reduces=2000 -Dmapred.map.tasks=10 -Dmapred.reduce.tasks=2000 -Dfieldsdump.fields=url -Dfieldsdump.map=url -Dfieldsdump.atoms=/webmap/batches/$wmfile/atoms -Dfieldsdump.mode=iterate -Dfieldsdump.input=$exploreurls -Dfieldsdump.output=$explored"

        echo $cmd
        if [ $dryrun == 0 ] ; then
            hadoop fs -rm -r $explored
            eval $cmd
        fi
    fi

    ndomlist=explored.doms.onejson
    domqllist=domql.onejson

    if [ 1 -eq "$(echo "2.3 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.3" | bc)" ]; then
        hadoop fs -cat $explored/par* | python $mylibloc/genLibs.py ApplyFuncToCol normalize,0 | python $mylibloc/genLibs.py Stream2JsonList True > $ndomlist
    fi

    if [ 1 -eq "$(echo "2.4 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.4" | bc)" ]; then
        hadoop fs -cat $inputfile/par* | cut -f1,2 | python $mylibloc/genLibs.py Stream2JsonList True > $domqllist
    fi

    if [ 1 -eq "$(echo "2.5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.5" | bc)" ]; then
        # requires FilterUrlByDomQl.py, ndomlist, and domqllist
        cmd="bash $mylibloc/dopig.sh WebmapUrls.pig $queue 5000 0 0 \"-p wmfile=$wmfile -p mylibloc=$mylibloc -p ndomlist=$ndomlist -p domqllist=$domqllist -p out=$oroot/urls.filtered\""
        echo $cmd
        if [ $dryrun == 0 ] ; then
            hadoop fs -rm -r $oroot/urls.filtered
            eval $cmd
        fi
    fi

fi

if [ 1 -eq "$(echo "3 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3" | bc)" ]; then

    cmd="hadoop jar /home/jyj/mylib/jars/webmap-table-format-2.5.0.jar com.yahoo.corp.yst.webmap.input.example.FieldsDump -Dmapred.job.queue.name=$queue -Dfieldsdump.maps=100 -Dfieldsdump.reduces=2000 -Dmapred.map.tasks=10 -Dmapred.reduce.tasks=2000 -Dfieldsdump.fields=url,outlinks -Dfieldsdump.map=url -Dfieldsdump.atoms=/webmap/batches/$wmfile/atoms -Dfieldsdump.mode=iterate -Dfieldsdump.input=$urlfile -Dfieldsdump.output=$outlinkfile"
    echo $cmd
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $outlinkfile
        eval $cmd
    fi
fi

if [ 1 -eq "$(echo "4 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4" | bc)" ]; then

    cmd="bash $mylibloc/dopig.sh JoinOutlinkAnchors.pig $queue 100 0 0 \"-p input=$aroot/joined-with-oldtitle -p out=$oroot/joined -p outlinkfile=$outlinkfile mylibloc=$mylibloc\""
    echo $cmd
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $oroot/joined
        eval $cmd
    fi
fi
