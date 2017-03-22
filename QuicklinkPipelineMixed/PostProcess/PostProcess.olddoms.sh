# Essentially a grid version of AddHighCtr.py, plus alias joining, domain syncing, and tsv2xml conversion
root=/user/$USER/QuickLinkGeneration
troot=$root/QuicklinkTitles
froot=$root/QuicklinkFeatures
start=${1:-4.1}
end=${2:-4.2}

proot=${3:-"$root/QlPostProcess"}
#inputfile=${4:-"$troot/scoretitle"}  # this can be replaced by a ranked version
inputfile=${4:-"$froot/ranked"}
outputname=${5:-"processed"}
aliasdict=${6:-"../DomainSelection/alias.dict.onejson.pranav"}

# ================ #
# Python arguments #
# ================ #

# below file comes from cat append-editor-to-top.minus600.tsv override.600.tsv.3 | sort -k1,1 -k2,2 > editorial.8k.tsv
#whitelistfiles1="/home/jyj/quicklinks/QuicklinkPipeline/misc/1215/editorial.8k.tsv"

whitelistfiles1="editorial.8k.tsv"
wlfshort1=`echo $whitelistfiles1 | awk -F ',' '{for (i=1;i<=NF;i++){print $i}}' | awk -F '/' '{print $NF}' | tr '\n' ',' | sed 's/,$//g'`
BlackListFile=None
UseEditorTitle=True
pad1=100 # padding for editorial results
pad2=10 # padding for RankByScore
RankByCTR=False
RankByScore=True # order editorial results by sublink ranking when matched
topk=100

args1="$BlackListFile $wlfshort1 $UseEditorTitle $pad1 $pad2 $RankByCTR $RankByScore $topk" 

#whitelistfiles2="/home/jyj/quicklinks/QuicklinkPipeline/misc/1215/dqts.agree.cup.edit"

whitelistfiles2="dqts.agree.cup.edit"
wlfshort2=`echo $whitelistfiles2 | awk -F ',' '{for (i=1;i<=NF;i++){print $i}}' | awk -F '/' '{print $NF}' | tr '\n' ',' | sed 's/,$//g'`
pad1=10000
pad2=1000
RankByCTR=True
RankByScore=True
topk=10 # orig=10

args2="$BlackListFile $wlfshort2 $UseEditorTitle $pad1 $pad2 $RankByCTR $RankByScore $topk"


# ============================================= #
# Editorial/High CTR override + Post Processing #
# ============================================= #

#script=/home/jyj/quicklinks/QuicklinkPipeline/LocalJobs/AddHighCtr.py
script=AddHighCtr.py
script2="../AbfData/AbfDedup.py"
# To change editorial file, order etc, modify reducer.sh
if [ 1 -eq "$(echo "4.1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4.1" | bc)" ]; then
    hadoop fs -rm -r $proot
    hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -Dmapreduce.task.timeout=1200000 -Dstream.num.map.output.key.fields=4 -Dmapred.text.key.partitioner.options=-k1,1 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options="-k1,2" -Dmapreduce.job.reduces=100 -Dmapred.job.queue.name=default -files $script,$script2,/home/jyj/mylib/genLibs.py,$whitelistfiles1,$whitelistfiles2,reducer.sh -input $inputfile -output $proot/processed -mapper "cat" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer "sh reducer.sh \"$args1\" \"$args2\""
fi

# Copy post-processed result to local
if [ 1 -eq "$(echo "4.2 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4.2" | bc)" ]; then
    hadoop fs -cat $proot/processed/par*  | sort -t $'\t' --key=1,1 --key=4,4rg > $outputname.tmp

# ============================================================ #
# Join aliases, Sync reference tsv domains, and convert to xml #
# ============================================================ #

# qls.ref.tsv is the same as /home/jyj/quicklinks/qlfinal/final.top6.highctrdoms.addmissed.highctr200.loginlocator.dedupjs.has6.aliasadded.DomRemoved.newtitles.oldtitleorder 
    cat $outputname.tmp | python JoinAlias.py $aliasdict | python SyncDomainSet.py qls.ref.tsv  | sort -t$'\t' -k1,1 -k4,4rg > $outputname.tsv
    cat testqls.tsv >> $outputname.tsv
    cut -f1-3 $outputname.tsv | /home/jyj/.localpython/bin/python /home/jyj/mylib/convertLibs.py tsv2xml None,False > $outputname.xml
    cut -f 1,2,4 $outputname.tsv |  python allmetrics.py rbo 5 1 1 0 0 1 1 0 0 BingRbo.YSE006.0.best.onejson 1 0 > $outputname.rbo
    hadoop fs -rm $proot/$outputname.*
    hadoop fs -copyFromLocal $outputname.tmp $outputname.xml $outputname.tsv $proot/.
fi


