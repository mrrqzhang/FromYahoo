# This script generates titles for the quicklink candidates from clickonly-wmfeats
# All the pig script arguments can be replaced by -p root=$root
# For joining redirects, I decide not to use QuicklinkPipeline/JoinRedir suite because wmdata needs to be truncated at an early stage
start=${1:-2.1}
end=${2:-2.8}

wmfile=${3:-"wm-2014-12-08-02-01-03"}
root=${4:-"QuicklinkTitles"}
prevroot=${5:-"clickedcrawledfeats"}
topk=${6:-"1000"}
table=${7:-"url"}   # the other choice is crawledurl, which is unstable over webmap versions but is faster
modelxml=${8:-"gbdt.xml"}
rmtmp=${9:-0}
queue=${10:-"webmap"}    # alternative queue is default, which is not slow either
inputqls=${11:-"$prevroot/clicked-immchildren.sr.top-$topk.dedup/part*,$prevroot/singlelayer-quicklink/part*"}

# ================================================= #
# Get all raw data from webmap for title generation #
# ================================================= #

# Get urls from the candidates file
if [ 1 -eq "$(echo "2.1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.1" | bc)" ]; then
    if [[ $rmtmp == 1 ]] ; then hadoop fs -rm -r "$root/urls.domqls" ; fi
    if [[ $rmtmp == 1 ]] ; then hadoop fs -rm -r "$root/domql" ; fi
    bash dopig.sh GetUrls4TitleWmdataRedir.pig $queue 100 0 0 "-p domqlf=$inputqls -p out=$root/urls.domqls -p out2=$root/domql"
fi

# Generate redirect urls, page title and wmdata
if [ 1 -eq "$(echo "2.2 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.2" | bc)" ]; then
     if [[ $rmtmp == 1 ]] ; then hadoop fs -rm -r "$root/url.redir.title.wmdata" ; fi
    hadoop jar /home/jyj/mylib/jars/webmap-table-format-2.5.0.jar com.yahoo.corp.yst.webmap.input.example.FieldsDump -Dfieldsdump.maps=200 -Dfieldsdump.reduces=1000 -Dmapred.map.tasks=200 -Dmapred.reduce.tasks=1000 -Dfieldsdump.fields=url,redirtarget,title,wmdata -Dfieldsdump.map=$table -Dfieldsdump.atoms=/webmap/batches/$wmfile/atoms -Dfieldsdump.mode=iterate -Dfieldsdump.input=$root/urls.domqls -Dfieldsdump.output=$root/url.redir.title.wmdata
fi


# Get urls from the output of previous step using pig, since output of hadoop streaming has extra tab at the end
if [ 1 -eq "$(echo "2.3 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.3" | bc)" ]; then
    if [[ $rmtmp == 1 ]] ; then hadoop fs -rm -r "$root/redirurls" ; fi
    bash dopig.sh StripRedirUrls.pig $queue 100 0 0 "-p input=$root/url.redir.title.wmdata -p out=$root/redirurls"
fi

# Get page title and wmdata for the redirect urls 
if [ 1 -eq "$(echo "2.4 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.4" | bc)" ]; then
    if [[ $rmtmp == 1 ]] ; then hadoop fs -rm -r "$root/redirurl.title.wmdata" ; fi
    hadoop jar /home/jyj/mylib/jars/webmap-table-format-2.5.0.jar com.yahoo.corp.yst.webmap.input.example.FieldsDump -Dfieldsdump.maps=10 -Dfieldsdump.reduces=1000 -Dmapred.map.tasks=10 -Dmapred.reduce.tasks=1000 -Dfieldsdump.fields=url,title,wmdata -Dfieldsdump.map=$table -Dfieldsdump.atoms=/webmap/batches/$wmfile/atoms -Dfieldsdump.mode=iterate -Dfieldsdump.input=$root/redirurls -Dfieldsdump.output=$root/redirurl.title.wmdata
fi

# Join redirect url columns with original url columns
if [ 1 -eq "$(echo "2.5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.5" | bc)" ]; then
    if [[ $rmtmp == 1 ]] ; then hadoop fs -rm -r "$root/combined.redir.title.wmdata" ; fi
    bash dopig.sh JoinRedir.pig $queue 1000 0 0 "-p out=$root/combined.redir.title.wmdata -p rawf=$root/url.redir.title.wmdata -p redirf=$root/redirurl.title.wmdata -p domqlf=$root/domql -p nitems=100 -p buffersize=10000" 
fi


# ================= #
# Apply title model #
# ================= #

# Clean wmdata and page title to get features and a select set of title candidates
if [ 1 -eq "$(echo "2.6 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.6" | bc)" ]; then
    if [[ $rmtmp == 1 ]] ; then hadoop fs -rm -r "$root/traindata" ; fi
    hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -Dmapreduce.task.timeout=12000000 -Dstream.num.map.output.key.fields=7 -Dmapred.text.key.partitioner.options=-k1,1 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options="-k1,2" -Dmapreduce.job.reduces=10000 -Dmapred.job.queue.name=$queue -files GenTrainToken.py,Combined-en.py,totalclicks.topdomains.onejson,/home/jyj/mylib/genLibs.py -cacheArchive /user/jyj/distcachesrc/localpython3.tar.gz#local-py -input $root/combined.redir.title.wmdata -output $root/traindata -mapper "cat" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer "./local-py/bin/python Combined-en.py totalclicks.topdomains.onejson 1"
fi

# Use the title model to decide the best title candidate to use

if [ 1 -eq "$(echo "2.7 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.7" | bc)" ]; then
    modelxmlshort=`echo $modelxml | tr '/' '\n' | tail -1`
    if [ ! -e $modelxmlshort ] ; then cp $modelxml . ; fi
    if [[ $rmtmp == 1 ]] ; then hadoop fs -rm -r "$root/decided" ; fi
    bash dopig.sh DecideTitles.pig $queue 1000 0 0 "-p out=$root/decided -p input=$root/traindata -p modelxml=$modelxmlshort"
fi

# Join titles with original candidate scores
if [ 1 -eq "$(echo "2.8 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.8" | bc)" ]; then
    if [[ $rmtmp == 1 ]] ; then hadoop fs -rm -r "$root/scoretitle" ; fi
    bash dopig.sh JoinScore.pig $queue 100 0 0 "-p titlef=$root/decided -p out=$root/scoretitle -p scoref=$inputqls -p topk=$topk"
fi
