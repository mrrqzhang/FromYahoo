dryrun=${1:-0}
start=${2:-1}
end=${3:-3}
root=${4:-"AllBuckets.2"}
filenametrunk=${5:-"ctr-by-domclicks"}
queue=${6:-"search_mlr"}
startdate=${7:-"20141110"}
#startdate=${7:-"20140901"}
enddate=${8:-"20150206"}
#enddate=${8:-"20141225"}
defbucid=${9:-"all"}
now=$startdate

daterange=$startdate-$enddate
trunk1=$root/merged-ctr-by-domviews-$defbucid
trunk2=$root/merged-ctr-by-domclicks-$defbucid
out1=$trunk1-$daterange
out2=$trunk2-$daterange

mylibloc=/homes/jyj/mylib
if [ ! -e $mylibloc ] ; then
    mylibloc=/home/jyj/mylib
fi

compress="-Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.BZip2Codec"

# blocks of 20 days
if [ 1 -eq "$(echo "0 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 0" | bc)" ]; then

    while (( now <= enddate )) ; do
        date1=$now
        date2=$now
        datetime="$now" 
        now=`date +"%Y%m%d" -d "$now + 1 day"`
        for i in {2..20} ; do
            if (( now > enddate )) ; then
                break
            fi 
            datetime=$datetime,$now
            date2=$now
            now=`date +"%Y%m%d" -d "$now + 1 day"`
        done
        cmd="bash dopig.sh AbfAggCtr_query.pig $queue 2000 1 True \"-p root=$root -p defbucid=$defbucid -p DATETIME=$datetime -p daterange=$date1-$date2\""
        echo $cmd
        if [ $dryrun == 0 ] ; then
            hadoop fs -rm -r $root/dom-query-ctr-$defbucid-$date1-$date2
            eval $cmd
        fi
    done

fi


# blocks of 20 days
if [ 1 -eq "$(echo "1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1" | bc)" ]; then

    while (( now <= enddate )) ; do
        date1=$now
        date2=$now
        datetime="$now" 
        now=`date +"%Y%m%d" -d "$now + 1 day"`
        for i in {2..20} ; do
            if (( now > enddate )) ; then
                break
            fi 
            datetime=$datetime,$now
            date2=$now
            now=`date +"%Y%m%d" -d "$now + 1 day"`
        done
        cmd="bash dopig.sh AbfAggCtr.pig $queue 2000 1 True \"-p root=$root -p defbucid=$defbucid -p DATETIME=$datetime -p daterange=$date1-$date2\""
        echo $cmd
        if [ $dryrun == 0 ] ; then
            hadoop fs -rm -r $trunk1-$date1-$date2 $trunk2-$date1-$date2
            eval $cmd
        fi
    done

fi

if [ 1 -eq "$(echo "2 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2" | bc)" ]; then

    cmd="bash dopig.sh MergeCtr.pig $queue 2000 0 True \"-p out1=$out1 -p out2=$out2 -p in=$root/$filenametrunk-$bucdates\""
    echo $cmd
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $out1 $out2
        eval $cmd
    fi
fi

if [ 1 -eq "$(echo "3 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3" | bc)" ]; then
    # input schema: parent_url	url	ql_txt	bucid	nviews	nviews_cond	nclicks	nviews_dom	nclicks_dom	ctr	ctr_cond
    # num.map.output.key.fields specifies the initial number of columns treated as key
    # this step normalizes the domains, so that mobile.facebook.com and www.facebook.com share the same quicklinks
    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar $compress -Dmapreduce.task.timeout=1200000 -Dstream.num.map.output.key.fields=7 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options=\"-k1,1 -k7,7nr\" -Dmapreduce.job.reduces=500 -Dmapred.job.queue.name=$queue -files $mylibloc/genLibs.py,AbfDedup.py -input $out2 -output $out2.dedup.ndom.tmp -mapper \"python genLibs.py ApplyFuncToCol normalize,0\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"python AbfDedup.py\""
    echo $cmd
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $out2.dedup.ndom.tmp
        eval $cmd
    fi
fi

if [ 1 -eq "$(echo "4 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4" | bc)" ]; then
    # there seems no way to sort by hadoop without pig
    # sort by aggregate ql click count by domain, domain, and then individual ql click count.
    cmd="pig -Dmapred.job.queue.name=$queue -Dmapreduce.map.memory.mb=6072 $compress Sort.pig.py $out2.dedup.ndom.tmp $out2.dedup.ndom \"-k9rg -k1 -k7rg\" 100 100"
    echo $cmd
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $out2.dedup.ndom
        eval $cmd False
    else
        eval $cmd True
    fi
fi 


# seeds for high ctr quicklinks
if [ 1 -eq "$(echo "5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 5" | bc)" ]; then
    ctrth=0.1
    viewsth=200
    clicksth=100
    #domviewsth=200
    domclicksth=20

    ctridx=10

    domviewsidx=8
    domclicksidx=9
    clicksidx=7
    viewsidx=5
    # $outpu2.dedup.ndom must be sorted
    fn=highctr.$ctrth.$clicksth.$viewsth
    cmd1="hadoop jar $mylibloc/jars/hadoop-streaming.jar -Dmapred.job.queue.name=$queue -Dmapreduce.map.memory.mb=6072 -input $out2.dedup.ndom -output $root/$fn.unsorted -mapper \"awk -F '\\t' -v viewsth=$viewsth -v domclicksth=$domclicksth -v ctrth=$ctrth -v clicksth=$clicksth 'BEGIN{OFS=\\\"\\t\\\"; dom="None"}{if (\\$"1" != dom ) {nbql = 0 ; dom = \\$"1" } ; if ( ( \\$"$clicksidx" >= clicksth || \\$"$ctridx" >= ctrth ) && \\$"$viewsidx" >= viewsth && nbql < 6) { print \\$"1",\\$"2",\\$"3",\\$"$clicksidx",\\$"$ctridx",\\$"$domclicksidx",\\$"$viewsidx" ; nbql = nbql + 1 } }'\" -reducer NONE"
    cmd2="pig -Dmapred.job.queue.name=$queue -Dmapreduce.map.memory.mb=6072 Sort.pig.py $root/$fn.unsorted $root/$fn \"-k6rg -k1 -k4rg -k5rg\" 100 100"

    echo $cmd1
    echo $cmd2
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $root/$fn.unsorted
        hadoop fs -rm -r $root/$fn
        eval $cmd1
        eval $cmd2
    fi
    hadoop fs -cat $root/$fn/par* > /tmp/$USER/$fn
    # now ship /tmp/$USER/$fn to webmap machine 

 fi

# unnormalized domains for adding missing domains in PostProcess step
if [ 1 -eq "$(echo "6 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 6" | bc)" ]; then
    ctrth=0.0000001
    viewsth=100
    clicksth=1
    domclicksth=20

    ctridx=10
    domviewsidx=8
    domclicksidx=9
    clicksidx=7
    viewsidx=5
    # $outpu2.dedup.ndom must be sorted
    fn=highctr.$ctrth.$clicksth.$viewsth
    cmd1="hadoop jar $mylibloc/jars/hadoop-streaming.jar -Dmapred.job.queue.name=$queue -Dmapreduce.map.memory.mb=6072 -input $out2.dedup.ndom -output $root/$fn.unsorted -mapper \"awk -F '\\t' -v viewsth=$viewsth -v domclicksth=$domclicksth -v ctrth=$ctrth -v clicksth=$clicksth 'BEGIN{OFS=\\\"\\t\\\"; dom="None"}{if (\\$"1" != dom ) {nbql = 0 ; dom = \\$"1" } ; if ( ( \\$"$clicksidx" >= clicksth || \\$"$ctridx" >= ctrth ) && \\$"$viewsidx" >= viewsth && nbql < 6) { print \\$"1",\\$"2",\\$"3",\\$"$clicksidx",\\$"$ctridx",\\$"$domclicksidx",\\$"$viewsidx" ; nbql = nbql + 1 } }'\" -reducer NONE"
    cmd2="pig -Dmapred.job.queue.name=$queue -Dmapreduce.map.memory.mb=6072 Sort.pig.py $root/$fn.unsorted $root/$fn \"-k6rg -k1 -k4rg -k5rg\" 100 100"

    echo $cmd1
    echo $cmd2
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $root/$fn.unsorted
        hadoop fs -rm -r $root/$fn
        eval $cmd1
        eval $cmd2
    fi
    hadoop fs -cat $root/$fn/par* > /tmp/$USER/$fn
    # now ship /tmp/$USER/$fn to webmap machine 
 fi




domainuniq=$root/domains.uniq  # two columns
domainfixed=$root/domains.fixed     # single column
domainparent=$root/domains.parent

# on webmap machine: hput merged-ctr-by-domclicks-all-20140901-20141225.dedup.ndom AllBuckets.2

if [ 1 -eq "$(echo "10 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 10" | bc)" ]; then
    # get alias dictionary from ABF
    th=0.001
    # input must be unnormalized, so we can join later 
    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -Dstream.num.map.output.key.fields=1 -Dmapreduce.job.reduces=10 -Dmapred.job.queue.name=$queue -input $out2 -output $domainuniq -mapper \"awk -F '\\t' '{if ( \\$"9" >= $th ) {print \\$"1"\\\"\\t\\\"\\$"9"}}'\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"uniq\""
    echo $cmd
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $domainuniq
        eval $cmd
        #hadoop jar $mylibloc/jars/hadoop-streaming.jar -Dstream.num.map.output.key.fields=1 -Dmapreduce.job.reduces=10 -Dmapred.job.queue.name=$queue -input $out2 -file awk-mapper.sh -output $domainuniq -mapper "bash awk-mapper.sh $th" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer "uniq"
    fi
fi

# ============================== #
# get dup parent for each domain #
# do this on webmap machine      #
# ============================== #

if [ 1 -eq "$(echo "20 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 20" | bc)" ]; then
    wmfile=${5:-"wm-2014-12-30-18-04-49"}
    queue=${6:-"default"}
    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -Dstream.num.map.output.key.fields=1 -Dmapreduce.job.reduces=100 -Dmapred.job.queue.name=$queue -outputformat jyjudfs.CustomOutputFormat -file $mylibloc/genLibs.py -input $domainuniq -output $domainfixed -mapper \"python genLibs.py ApplyFuncToCol AppendHttpAndHttps,0\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"cut -f1\""
    echo $cmd
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $domainfixed
        eval $cmd
    fi   
    cmd="hadoop jar /home/jyj/mylib/jars/webmap-table-format-2.5.0.jar com.yahoo.corp.yst.webmap.input.example.FieldsDump -Dmapred.job.queue.name=$queue -Dfieldsdump.maps=100 -Dfieldsdump.reduces=2000 -Dmapred.map.tasks=10 -Dmapred.reduce.tasks=2000 -Dfieldsdump.fields=url,parenturl -Dfieldsdump.map=url -Dfieldsdump.atoms=/webmap/batches/$wmfile/atoms -Dfieldsdump.mode=iterate -Dfieldsdump.input=$domainfixed -Dfieldsdump.output=$domainparent"
    echo $cmd
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $domainparent 
        eval $cmd
    fi
fi


# ======================================================== #
# construct rootdict, alias dict and perform sanity checks #
# webmap machine                                           # 
# ======================================================== #

if [ 1 -eq "$(echo "21 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 21" | bc)" ]; then
    dictflag=${7:-"abf"}
    dolower=${8:-"True"}
    if [[ "$dolower" == "True" ]] ; then
        mid='.lower'
    else
        mid=''
    fi
    
    cmd="hadoop fs -cat $domainparent/par* | python AliasRootDict.py aliasdict > aliasdict$mid.onejson.$dictflag"
    echo $cmd
    if [ $dryrun == 0 ] ; then
        eval $cmd
    fi
    # dolower =True, minimal = False
    # this is needed to get additional high ctr ABF (top10k) domains missing from pipeline
    cmd="hadoop fs -cat $domainparent/par* | python AliasRootDict.py aliasdict $dolower False > aliasdict$mid.verb.onejson.$dictflag"
    echo $cmd
    if [ $dryrun == 0 ] ; then
        eval $cmd
    fi


    cmd="hadoop fs -cat $domainparent/par* | python AliasRootDict.py rootdict $dolower > rootdict.norm$mid.onejson.$dictflag"
    echo $cmd
    if [ $dryrun == 0 ] ; then
        eval $cmd
    fi

    cmd="python AliasRootDict.py test rootdict.norm$mid.onejson.$dictflag seed_urls.top10k"
    if [ $dryrun == 0 ] ; then
        eval $cmd
    fi
fi

# ======================================== #
# domain selection based on three criteria #
# ======================================== #

outputfile=$root/domains.binaries
if [ 1 -eq "$(echo "30 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 30" | bc)" ]; then

    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -files $mylibloc/genLibs.py,SelectDomains.py -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options=\"-k1,1\" -Dmapreduce.job.reduces=753 -Dmapred.jobAllBuckets.2.queue.name=$queue -input $out2.dedup.ndom -output $outputfile -mapper \"cat\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"python SelectDomains.py map\""
    # print '\t'.join(map(str, [pd, nclicks_dom, nviews_dom, ctr_dom ] + binaries ) )
    echo $cmd
    hadoop fs -rm -r $outputfile
    eval $cmd
    #hadoop fs -cat $root/domains.binaries/par* | awk -F '\t' 'BEGIN{c=0;v=0}{c=c+$2; v=v+$3} END{print c,v, c/v}'
fi

if [ 1 -eq "$(echo "31 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 31" | bc)" ]; then
    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -files $mylibloc/genLibs.py,SelectDomains.py -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $outputfile -output $outputfile.reduced -mapper \"python SelectDomains.py reduce\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"awk -F '\\t' '{for (i=1;i<=NF;i++) arr[i]=arr[i] + \\$"i"}END{for (i=1;i<=NF-1;i++) printf arr[i]\\\"\\t\\\"; printf arr[NF]}' \""
    
    echo $cmd
    hadoop fs -rm -r $outputfile.reduced
    eval $cmd
    echo -e "nviews_dom\tnclicks_dom\tctr_dom\tid\tagg_ctr\tagg_nviews\tdom_cnt"
fi
if [ 1 -eq "$(echo "31.5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 31.5" | bc)" ]; then
    paste <( python SelectDomains.py params ) <( hadoop fs -cat $outputfile.reduced/par*00000 | awk -F '\t' '{for (i=1;i<=NF/3;i++) print i"\t"($(i+NF/3) / ( $i + 0.0000001))"\t"$i"\t"$(i+ 2 * NF / 3)}' )
fi

if [ 1 -eq "$(echo "32 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 32" | bc)" ]; then
    #finaldomains=$root/domains.0.1.100.1000
    #cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $outputfile -output $finaldomains -mapper \"awk -F '\\t' 'BEGIN{OFS=\\\"\\t\\\"}{if (\\$"277" == 1 ) print \\$"1",\\$"2",\\$"3"}'\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"cat\""
    #finaldomains=$root/domains.0.1.250.10000
    #cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $outputfile -output $finaldomains -mapper \"awk -F '\\t' 'BEGIN{OFS=\\\"\\t\\\"}{if (\\$"357" == 1 ) print \\$"1",\\$"2",\\$"3"}'\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"cat\""

    ## 80      100000  0.04    1941    0.140282        9.79177e+08     439761
    #finaldomains=$root/domains.0.04.80.100000
    #cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $outputfile -output $finaldomains -mapper \"awk -F '\\t' 'BEGIN{OFS=\\\"\\t\\\"}{if (\\$"1945" == 1 ) print \\$"1",\\$"2",\\$"3"}'\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"cat\""

    ## 150     1000000000      0.03    2453    0.146979        9.07239e+08     295513
    finaldomains=$root/domains.0.03.150.1b
    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $outputfile -output $finaldomains -mapper \"awk -F '\\t' 'BEGIN{OFS=\\\"\\t\\\"}{if (\\$"2457" == 1 ) print \\$"1",\\$"2",\\$"3"}'\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"cat\""


    echo $cmd
    hadoop fs -rm -r $finaldomains
    eval $cmd
fi

if [ 1 -eq "$(echo "33 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 33" | bc)" ]; then

    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -files $mylibloc/genLibs.py,SelectDomains.single.py -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $out2.dedup.ndom -output $outputfile.single -mapper \"python SelectDomains.single.py\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer NONE"
    echo $cmd
    hadoop fs -rm -r $outputfile.single
    eval $cmd
    #hadoop fs -cat $root/domains.binaries/par* | awk -F '\t' 'BEGIN{c=0;v=0}{c=c+$2; v=v+$3} END{print c,v, c/v}'
fi


# ======================================================= #
# Get all domains with vc < 150 and various ctr threshold #
# ======================================================= #
outputfile=$root/domains.binaries.refined
queue=search_general
startdate="20140901"
enddate="20141225"

daterange=$startdate-$enddate
trunk1=$root/merged-ctr-by-domviews-$defbucid
trunk2=$root/merged-ctr-by-domclicks-$defbucid
out1=$trunk1-$daterange
out2=$trunk2-$daterange
pyfile=SelectDomains.150vc.0.03ctr.py
filtered=qdcvctr.all.filtered


if [ 1 -eq "$(echo "39 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 39" | bc)" ]; then
    tmpfn=`mktemp ndoms.XXXX`
    echo "cut -f1 | uniq | python genLibs.py normalize,stream" > $tmpfn
    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -files $mylibloc/genLibs.py,$tmpfn -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapred.job.queue.name=$queue -Dmapreduce.job.reduces=100 -outputformat jyjudfs.CustomOutputFormat -input $filtered -output $filtered.ndom -mapper \"cut -f2\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"bash $tmpfn\""
    hadoop fs -rm -r $filtered.ndom
    echo $cmd
    eval $cmd
    rm $tmpfn
fi

if [ 1 -eq "$(echo "39.5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 39.5" | bc)" ]; then

    cmd="pig -Dmapred.job.queue.name=$queue -Dmapreduce.map.memory.mb=6072 $compress Filter.pig.py $out2.dedup.ndom $filtered.ndom $out2.dedup.ndom.filtered 0 0 \"-k9rg -k1 -k7rg\" 100 100"
    hadoop fs -rm -r $out2.dedup.ndom.filtered
    echo $cmd
    eval $cmd
fi

if [ 1 -eq "$(echo "40 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 40" | bc)" ]; then

    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -files $mylibloc/genLibs.py,$pyfile -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options=\"-k1,1\" -Dmapreduce.job.reduces=753 -Dmapred.jobAllBuckets.2.queue.name=$queue -input $out2.dedup.ndom.filtered -output $outputfile -mapper \"cat\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"python $pyfile map\""
    echo $cmd
    hadoop fs -rm -r $outputfile
    eval $cmd
    #hadoop fs -cat $root/domains.binaries/par* | awk -F '\t' 'BEGIN{c=0;v=0}{c=c+$2; v=v+$3} END{print c,v, c/v}'
fi

if [ 1 -eq "$(echo "41 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 41" | bc)" ]; then
    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -files $mylibloc/genLibs.py,$pyfile -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $outputfile -output $outputfile.reduced -mapper \"python $pyfile reduce\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"awk -F '\\t' '{for (i=1;i<=NF;i++) arr[i]=arr[i] + \\$"i"}END{for (i=1;i<=NF-1;i++) printf arr[i]\\\"\\t\\\"; printf arr[NF]}' \""
    
    echo $cmd
    hadoop fs -rm -r $outputfile.reduced
    eval $cmd
    
fi

if [ 1 -eq "$(echo "41.5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 41.5" | bc)" ]; then
    echo -e "ctr0\tid\tagg_ctr\tagg_nviews\tdom_cnt"
    paste <( python $pyfile params ) <( hadoop fs -cat $outputfile.reduced/par*00000 | awk -F '\t' '{for (i=1;i<=NF/3;i++) print i"\t"($(i+NF/3) / ( $i + 0.0000001))"\t"$i"\t"$(i+ 2 * NF / 3)}' )
fi


if [ 1 -eq "$(echo "42 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 42" | bc)" ]; then
    finaldomains=$root/domains.0.03.150.0.08.whtlst
    colidx=10
    colidx=$((colidx + 4))
    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $outputfile -output $finaldomains -mapper \"awk -F '\\t' 'BEGIN{OFS=\\\"\\t\\\"}{if (\\$"$colidx" == 1 ) print \\$"1",\\$"2",\\$"3"}'\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"cat\""


    echo $cmd
    hadoop fs -rm -r $finaldomains
    eval $cmd
fi



# ======================================================= #
# Get all domains with vc < 150 and various ctr threshold #
# ======================================================= #
outputfile=$root/domains.binaries.2bins
queue=search_general
startdate="20140901"
enddate="20141225"

daterange=$startdate-$enddate
trunk1=$root/merged-ctr-by-domviews-$defbucid
trunk2=$root/merged-ctr-by-domclicks-$defbucid
out1=$trunk1-$daterange
out2=$trunk2-$daterange
pyfile=SelectDomains.2bins.py
filtered=qdcvctr.all.filtered


if [ 1 -eq "$(echo "50 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 50" | bc)" ]; then

    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -files $mylibloc/genLibs.py,$pyfile -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options=\"-k1,1\" -Dmapreduce.job.reduces=753 -Dmapred.jobAllBuckets.2.queue.name=$queue -input $out2.dedup.ndom.filtered -output $outputfile -mapper \"cat\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"python $pyfile map\""
    echo $cmd
    hadoop fs -rm -r $outputfile
    eval $cmd
    #hadoop fs -cat $root/domains.binaries/par* | awk -F '\t' 'BEGIN{c=0;v=0}{c=c+$2; v=v+$3} END{print c,v, c/v}'
fi

if [ 1 -eq "$(echo "51 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 51" | bc)" ]; then
    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -files $mylibloc/genLibs.py,$pyfile -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $outputfile -output $outputfile.reduced -mapper \"python $pyfile reduce\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"awk -F '\\t' '{for (i=1;i<=NF;i++) arr[i]=arr[i] + \\$"i"}END{for (i=1;i<=NF-1;i++) printf arr[i]\\\"\\t\\\"; printf arr[NF]}' \""
    
    echo $cmd
    hadoop fs -rm -r $outputfile.reduced
    eval $cmd
    
fi

if [ 1 -eq "$(echo "51.5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 51.5" | bc)" ]; then
    echo -e "nviews_dom\tctr0_dom\tctr_dom\tid\tagg_ctr\tagg_nviews\tdom_cnt"
    paste <( python $pyfile params ) <( hadoop fs -cat $outputfile.reduced/par*00000 | awk -F '\t' '{for (i=1;i<=NF/3;i++) print i"\t"($(i+NF/3) / ( $i + 0.0000001))"\t"$i"\t"$(i+ 2 * NF / 3)}' )
fi


if [ 1 -eq "$(echo "52 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 52" | bc)" ]; then
    #finaldomains=$root/domains.0.03.300.0.06.whtlst
    #nviews_dom      ctr0_dom        ctr_dom id      agg_ctr agg_nviews      dom_cnt
    #300     0.06    0.03    1352    0.148037        9.12856e+08     769976
    #colidx=1352

    finaldomains=$root/domains.0.02.1000.0.09.whtlst
    #nviews_dom      ctr0_dom        ctr_dom id      agg_ctr agg_nviews      dom_cnt
    #1000    0.09    0.02    1891    0.134231        1.0201e+09      644202
    colidx=1891

    colidx=$((colidx + 4))
    cmd="hadoop jar $mylibloc/jars/hadoop-streaming.jar -libjars $mylibloc/jars/jyjudfs.jar -Dstream.num.map.output.key.fields=1 -Dmapred.text.key.partitioner.options=\"-k1,1\" -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $outputfile -output $finaldomains -mapper \"awk -F '\\t' 'BEGIN{OFS=\\\"\\t\\\"}{if (\\$"$colidx" == 1 ) print \\$"1",\\$"2",\\$"3"}'\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"cat\""
    echo $cmd
    hadoop fs -rm -r $finaldomains
    eval $cmd
fi

