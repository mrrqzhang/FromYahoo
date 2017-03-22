# Essentially a grid version of AddHighCtr.py, plus alias joining, domain syncing, and tsv2xml conversion
# replace PostProcess.sh with this one in jyj's PostProcess folder

root=/user/$USER/QuickLinkGeneration.abf
troot=$root/QuicklinkTitles
froot=$root/QuicklinkFeatures
start=${1:-4.1}
end=${2:-4.5}

proot=${3:-"$root/QlPostProcess"}
#inputfile=${4:-"$troot/scoretitle"}  # this can be replaced by a ranked version
inputfile=${4:-"$froot/ranked"}
outputname=${5:-"processed"}
#aliasdict=${6:-"../DomainSelection/alias.dict.onejson.pranav"}
aliasdict=${6:-"../AbfData/aliasdict.onejson.abf"}
aliasdictshort=`echo $aliasdict | awk -F ',' '{for (i=1;i<=NF;i++){print $i}}' | awk -F '/' '{print $NF}' | tr '\n' ',' | sed 's/,$//g'`
dryrun=${7:-0}
queue=${8:-default}
#domlistfile=${9:-domains.0.1.100.1000}
#domlistfile=${9:-domains.0.1.250.10000}
#domlistfile=${9:-domains.0.04.80.100000}
#domlistfile=${9:-domains.0.03.150.1b}
#domlistfile=${9:-domains.0.03.300.0.06.whtlst}
#domlistfile=${9:-domains.0.02.1000.0.09.whtlst}    # best before no filter
#domlistfile=${9:-domains.allbutlowctr.txt}   #low ctr domain removal
#domlistfile=${9:-domains.fullbut2.txt}
domlistfile=${9:-""}

nvcut=${10:-"0"}
reftsv=${11:-""}
mylibloc=/homes/jyj/mylib
if [ ! -e $mylibloc ] ; then
    mylibloc=/home/jyj/mylib
fi
echo proot = $proot
echo inputfile = $inputfile
echo outputname = $outputname
echo aliasdict = $aliasdict


# ================ #
# Python arguments #
# ================ #

titlebankfile=../Editorial/qltitle_edit.onejson
titlebankshort=`echo $titlebankfile | awk -F ',' '{for (i=1;i<=NF;i++){print $i}}' | awk -F '/' '{print $NF}' | tr '\n' ',' | sed 's/,$//g'`


# high ctr or editorial override files have ndom, ql, title, score
# below file comes from cat append-editor-to-top.minus600.tsv override.600.tsv.3 | sort -k1,1 -k2,2 > editorial.8k.tsv
#whitelistfiles1="/home/jyj/quicklinks/QuicklinkPipeline/misc/1215/editorial.8k.tsv"

whitelistfiles1="editorial.8k.tsv"
wlfshort1=`echo $whitelistfiles1 | awk -F ',' '{for (i=1;i<=NF;i++){print $i}}' | awk -F '/' '{print $NF}' | tr '\n' ',' | sed 's/,$//g'`
UseEditorTitle=True
pad1=100 # padding for editorial results
pad2=10 # padding for RankByScore
RankByCTR=False
RankByScore=True # order editorial results by sublink ranking when matched
topk=100

args1="$titlebankshort $wlfshort1 $UseEditorTitle $pad1 $pad2 $RankByCTR $RankByScore $topk" 

cp ../outlinktitles/highctr.0.1.100.200.sanity.match .
whitelistfiles2="highctr.0.1.100.200.sanity.match,dqts.agree.cup.edit"
wlfshort2=`echo $whitelistfiles2 |  awk -F ',' '{for (i=1;i<=NF;i++){print $i}}' | awk -F '/' '{print $NF}' | tr '\n' ',' | sed 's/,$//g'`
UseEditorTitle=True
pad1=10000
pad2=1000   # useless because RankByScore is False
RankByCTR=True
RankByScore=False   # this is False to make sure we don't use ctr, not ranking score, for whitelist qls
topk=10
args2="$titlebankshort $wlfshort2 $UseEditorTitle $pad1 $pad2 $RankByCTR $RankByScore $topk"

if [ 1 == 0 ] ; then 
    #whitelistfiles3="/home/jyj/quicklinks/QuicklinkPipeline/misc/1215/dqts.agree.cup.edit"

    whitelistfiles3="dqts.agree.cup.edit"
    wlfshort3=`echo $whitelistfiles3 |  awk -F ',' '{for (i=1;i<=NF;i++){print $i}}' | awk -F '/' '{print $NF}' | tr '\n' ',' | sed 's/,$//g'`
    UseEditorTitle=True
    pad1=1000000
    pad2=100000
    RankByCTR=True
    RankByScore=True
    topk=10

    args3="$titlebankshort $wlfshort3 $UseEditorTitle $pad1 $pad2 $RankByCTR $RankByScore $topk"

fi

echo "args1 = " $args1
echo "args2 = " $args2
#echo "args3 = " $args3

# ============================================= #
# Editorial/High CTR override + Post Processing #
# ============================================= #

#script=/home/jyj/quicklinks/QuicklinkPipeline/LocalJobs/AddHighCtr.py
script=AddHighCtr.py
script2="../AbfData/AbfDedup.py"
script3=JoinAliasParallel.py
script4="../addtitles/DecideTitle.py"
worseqls="16200.goodfields.tsv"

# To change editorial file, order etc, modify reducer.sh
if [ 1 -eq "$(echo "4.1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4.1" | bc)" ]; then
    hadoop fs -rm -r $proot/processed
    cmd="hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -Dmapreduce.task.timeout=1200000 -Dstream.num.map.output.key.fields=4 -Dmapred.text.key.partitioner.options=-k1,1 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options=\"-k1,2\" -Dmapreduce.job.reduces=1000 -Dmapred.job.queue.name=$queue -files $script,$script2,/home/jyj/mylib/genLibs.py,$whitelistfiles1,$whitelistfiles2,$titlebankfile,$aliasdict,$script3,$script4,$worseqls,remove-bad-ql.py,reducer.sh -input $inputfile -output $proot/processed -mapper \"cat\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"sh reducer.sh \\\"$args1\\\" \\\"$args2\\\" $aliasdictshort $worseqls\""
    # to test locally, use the following
    # proot=/user/jyj/QuickLinkGeneration.abf/QlPostProcess
    # hadoop fs -cat /user/jyj/QuickLinkGeneration.abf/QuicklinkFeatures/ranked/par* | sh reducer.sh "qltitle_edit.onejson editorial.8k.tsv True 100 10 False True 100" "qltitle_edit.onejson highctr.0.1.100.200.match,dqts.agree.cup.edit True 10000 1000 True True 10" aliasdict.onejson.abf
    echo $cmd
    if [ $dryrun == 0 ] ; then
        eval $cmd
    fi
fi


if [ 1 -eq "$(echo "4.12 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4.12" | bc)" ]; then
    # True/False denotes whether or not to normalize
    hadoop fs -rm -r $proot/checktop10k
    hadoop jar $mylibloc/jars/hadoop-streaming.jar -files $mylibloc/genLibs.py,../AbfData/seed_urls.top10k,../clickonly-wmfeats/CheckTop10k.py -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $proot/processed -output $proot/checktop10k -mapper "python CheckTop10k.py seed_urls.top10k Found True" -reducer "python CheckTop10k.py seed_urls.top10k Missing False"
    echo "number of missing domains from top 10k after postprocess: "
    hadoop fs -cat $proot/checktop10k/par* | wc -l
    hadoop fs -cat $proot/checktop10k/par* | tee missing.domains
    python $mylibloc/genLibs.py setOp missing.domains,domains.0.03.150.1b,intersection  > missing.cap.1b.domains
    python $mylibloc/genLibs.py JoinFiles missing.cap.1b.domains,../AbfData/highctr.0.0000001.1.100,0,0 | sort -k1,1 | awk -F '\t' 'BEGIN{d="None"}{if (d!= $1) {s = 0;d=$1;delete arr;}; s=s+1; arr[s]=$0; if (s>=6){for (i=1;i<=s;i++) {print arr[i]}}}' | sort -t$'\t' -k1,1 -k5,5rg  | cut -f1-3,5 > qls.missingdoms.all
    python $mylibloc/genLibs.py JoinDict qls.missingdoms.all,../AbfData/aliasdict.verb.onejson.abf,0 | sort -t$'\t' -k1,1 -k4,4rg | python $mylibloc/genLibs.py ApplyFuncToCol AppendHttp,1 > qls.additional.all
    cat qls.additional.all | python CleanTitle.py > qls.additional.all.titlecleaned
fi

# remove low performing domains
if [ 1 -eq "$(echo "4.15 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4.15" | bc)" ]; then
    if [ $dryrun == 0 ] ; then
        hadoop fs -rm -r $proot/domfiltered
    fi
    if [[ $domlistfile != "" ]] ; then 

        cmd="hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -files FilterByDomain.py,$domlistfile,$mylibloc/genLibs.py -Dstream.num.map.output.key.fields=1 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $proot/processed -output $proot/domfiltered -mapper \"python FilterByDomain.py $domlistfile $nvcut\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"cat\""
        echo $cmd
        if [ $dryrun == 0 ] ; then
            eval $cmd
        fi
    else
        cmd="hadoop fs -cp $proot/processed $proot/domfiltered"
        echo $cmd
        if [ $dryrun == 0 ] ; then
            eval $cmd
        fi
    fi
fi

# Copy post-processed result to local
if [ 1 -eq "$(echo "4.2 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4.2" | bc)" ]; then
    

# ============================================================ #
# Join aliases, Sync reference tsv domains, and convert to xml #
# ============================================================ #

# qls.ref.tsv is the same as /home/jyj/quicklinks/qlfinal/final.top6.highctrdoms.addmissed.highctr200.loginlocator.dedupjs.has6.aliasadded.DomRemoved.newtitles.oldtitleorder 
    #cat $outputname.tmp | python JoinAlias.py $aliasdict | python SyncDomainSet.py qls.ref.tsv  | sort -t$'\t' -k1,1 -k4,4rg > $outputname.tsv

    if [[ $reftsv != "" ]] ; then
        hadoop fs -cat $proot/processed/par*  | sort -t $'\t' --key=1,1 --key=4,4rg > $outputname.tmp
        cat $outputname.tmp | python SyncDomainSet.py qls.ref.tsv  | sort -t$'\t' -k1,1 -k4,4rg > $outputname.tsv
    else
        rm $outputname.tmp
        hadoop fs -cat $proot/domfiltered/par* | sort -t $'\t' --key=1,1 --key=4,4rg > $outputname.tsv
    fi

fi

addmissing=1
# this step must be run together with 4.2 to ensure no double counting
if [ 1 -eq "$(echo "4.3 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4.3" | bc)" ]; then
    if [[ $addmissing == "1" ]] ; then
        cmd="cat qls.additional.all.titlecleaned >> $outputname.tsv"
        echo $cmd
        eval $cmd
    fi
fi

if [ 1 -eq "$(echo "4.35 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4.35" | bc)" ]; then
    # examine quicklinks for some popular domains
    echo "sanity check for popular domains:"
    echo yahoo, google, twitter, walmart, facebook, ebay, target, youtube, wellsfargo, gmail, uhd, stanford
    grep '^http://www.yahoo.com/	\|^https://www.google.com/	\|^https://www.twitter.com/	\|^http://www.walmart.com/	\|^http://www.facebook.com/	\|^http://www.ebay.com/	\|^https://www.target.com/	\|^http://www.youtube.com/	\|^https://www.wellsfargo.com/	\|^https://www.gmail.com/	\|^http://www.uhd.edu/	\|^http://www.stanford.edu/	' $outputname.tsv

fi

if [ 1 -eq "$(echo "4.4 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4.4" | bc)" ]; then
    echo normalizing titles ..
    cut -f3 $outputname.tsv | sort | uniq -c | sort -t$'\t' -k1,1nr | python NormalizeTitle.py prepare ntitles.onejson

    mv $outputname.tsv $outputname.roughtitle.tsv
    echo apply normalized titles ..
    cat $outputname.roughtitle.tsv | python NormalizeTitle.py apply ntitles.onejson | python remove-duplicate-ql.py  > $outputname.tsv
    echo converting to xml format ..
    cut -f1-3 $outputname.tsv | /home/jyj/.localpython/bin/python /home/jyj/mylib/convertLibs.py tsv2xml None,False > $outputname.xml
    hadoop fs -rm $proot/$outputname.*
    hadoop fs -copyFromLocal $outputname.xml $outputname.tsv $outputname.roughtitle.tsv $proot/.
    echo step 4.4 done ..
fi
if [ 1 -eq "$(echo "4.5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4.5" | bc)" ]; then

    rm -f  $outputname.rbo
    touch $outputname.rbo
    echo start computing rbo ..
    echo "normal rbo" >> $outputname.rbo
    cut -f 1,2,4 $outputname.tsv |  python allmetrics.py rbo 6 0 1 0 0 1 0 0 1  BingRbo.YSE006.0.best.onejson 1 0 >> $outputname.rbo
    echo "best rbo (top 6)" >> $outputname.rbo
    cut -f 1,2,4 $outputname.tsv |  python allmetrics.py rbo 6 0 1 0 1 1 0 0 1  BingRbo.YSE006.0.best.onejson 1 0 >> $outputname.rbo
    echo "best rbo (top 6) of all golden set sessions" >> $outputname.rbo
    cut -f 1,2,4 $outputname.tsv |  python allmetrics.py rbo 6 0 1 0 1 1 1 0 1  BingRbo.YSE006.0.best.onejson 1 0 >> $outputname.rbo
    echo "best rbo (top 6) of all golden sessions with largest QL numbers" >> $outputname.rbo
    cut -f 1,2,4 $outputname.tsv |  python allmetrics.py rbo 6 0 1 1 1 1 1 0 1  BingRbo.YSE006.0.best.onejson 1 0 >> $outputname.rbo
    echo "best rbo (top 30) of all options" >> $outputname.rbo
    hadoop fs -cat $inputfile/part* | cut -f 1,2,4 | python allmetrics.py rbo 6 0 1 1 1 1 1 0 1  BingRbo.YSE006.0.best.onejson 1 0 >> $outputname.rbo
    cat $outputname.rbo
    hadoop fs -rm $proot/$outputname.*
    hadoop fs -copyFromLocal $outputname.xml $outputname.tsv $outputname.rbo $proot/.
fi
