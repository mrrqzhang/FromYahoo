mode=${1:-test} #alternative is train

queue=${4:-default}
topk=${5:-1000} # this is for input file specification
froot=${8:-QuicklinkFeatures}
croot=${9:-clickedcrawledfeats}
troot=${10:-QuicklinkTitles}
wmfile=${11:-wm-2014-12-16-02-44-10}
dryrun=${12:-0}




# ============== #
# Basic Settings #
# ============== #
compress="-Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.BZip2Codec"

mylibloc=/homes/jyj/mylib
if [ ! -e $mylibloc ] ; then
    mylibloc=/home/jyj/mylib
fi

# ================ #
# Sublink Features #
# ================ #
#aggfeats=`hadoop fs -cat $sublinkfiles/.pig_header | cut -d$'\t' -f4- | awk -F '\t' 'BEGIN{OFS=","}{$1=$1;print $0}'`
aggfeats=score,selfclicks,totalclicks,c1,c2,n1,n2,l0,l1,l2,la,na,selfviews,totalviews,v1,v2,depth,potential,selfctr,totalctr,ctr1,ctr2
naggfeats=`echo $aggfeats | tr ',' '\n' | wc -l`
sublinkfiles=$croot/clicked-immchildren.sr.top-$topk

# =============== #
# Webmap Features #
# =============== #
wmfeats=selrank,hostrank,inlinkcnt,internalinlinkcnt,linkflux,clicks,views,outlinkcnt,crawled,dup,spam,porn,unique,worthcrawl,dupcode,domaincnt,docclass,crawlertrap,crawl_trust_selection_rank,crawl_trust,aggreginlinkcnt,aggregsyntaxinlinkcnt,anyerror,audio,badbehavior,badext,badscheme,corpwpscore,crawl_trust_cash_ext,document,dynamic,dynscore,editporn,gdcrawlrank,gif,gigadoc,hasafflinks,hasvalidredirtarget,html,http,https,image,interestchina,inlinkcompressratio,internaloutlinkcnt,isrss,jpeg,lfspam,linked_from_sitemap,linked_from_sitemap_only,linkstoporn,linkstospam,linktime_count,linktime_max_day,linktime_mean,linktime_min_day,linktime_recent_inlinks,linktime_stdev,linktime_weighted_recent_inlinks,max_modified_selection_rank,mp3,num_anchortext_lines,parent,pdf,ps,public,qualityscore,rawdomaincnt,rawdomaincntofhost,real,realaudio,redirect,redirinlinkcnt,redirsourcecnt,ruleredirect,ruleredirsourcecnt,s404score,spamscore,srpscore,streaming,tempredirect,uiscnt,video,windows,wireless,worddoc,xhtml,xml

nwmfeats=`echo $wmfeats | tr ',' '\n' | wc -l`

# ============== #
# Title Features #
# ============== #
titletopk=5000
titlefeats=top"$titletopk"title\$,titlefreq
ntitlefeats=`echo $titlefeats | tr ',' '\n' | wc -l`

# ============ #
# LDA Features #
# ============ #
nldafeats=30
topcat=$(( nldafeats - 1 ))
ldafeats=`seq 0 $topcat | while read line ; do echo lda_$line ; done | tr '\n' ',' | sed 's/,$//g'`,lda_topcat\$
#ldaloc=$froot/out.lda
ldaloc=/user/jyj/QuickLinkGeneration/QuicklinkFeatures/out.lda/  #$froot/out.lda/
ldatopics=$ldaloc/{*}/lda.out.docToTop.txt


# ================ #
# Toolbar Features #
# ================ #
toolbarfeats=tb_rank,tb_clicks,tb_click_ratio,tb_domain_clicks,tb_click_ratio_proper,tb_domain_clicks_proper
ntoolbarfeats=`echo $toolbarfeats | tr ',' '\n' | wc -l`
toolbarf=/user/jyj/ranked.agg.2015

# ============ #
# All Features #
# ============ #
numfields=`echo domain,ql,title,score,aggjs,domwmjs,qlwmjs,titlejs,ldajs,toolbarjs | tr ',' '\n' | wc -l`
allfeats=$aggfeats+domain_
allfeats=$allfeats`echo $wmfeats | sed 's/,/,domain_/g'`
allfeats=$allfeats+$wmfeats+$titlefeats+$ldafeats+$toolbarfeats
echo all features: $allfeats


if [ $mode == 'train' ] ; then
    # these two are for targetf 
    start=${2:-3.1}
    end=${3:-3.4}
    wtindex=${6:-"4"}
    tgtindex=${7:-"9"}
    train_input=${13:-"AbfData/ctr-by-domviews"}
    gbdtcfg=${14:-"train-bing.cfg"}
    logweight=${15:-"True"}
    gbdtxmltype=${16:-"gbdt_edit.xml,rbo"}
    froot=$froot/`basename $train_input`

    

    if [ 1 -eq "$(echo "3.1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.1" | bc)" ]; then 
        hadoop fs -rm -r $froot/domqlwttgt $froot/urls
        bash dopig.sh JoinWtTgt.pig $queue 1000 0 0 "-p logweight=$logweight -p out=$froot/domqlwttgt -p out2=$froot/urls -p targetf=$train_input -p input=$sublinkfiles.dedup -p wtindex=$wtindex -p tgtindex=$tgtindex"
        # output = domain, ql, weight, target
    fi
    if [ 1 -eq "$(echo "3.2 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.2" | bc)" ]; then 
        cd ../JoinRedir
        bash JoinRedir.sh $froot/urls $froot/feats.domqls $wmfeats url $wmfile $queue 1 4
        cd ../Ranking
    fi
    if [ 1 -eq "$(echo "3.25 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.25" | bc)" ]; then 
        # title frequency feature
        if [ -e toptitles.tsv ] ; then 
            echo toptitles.tsv exists!
        else
            echo toptitles.tsv does not exists!
        fi
        hadoop fs -rm -r $froot/titlefeats
        cmd="hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -Dmapreduce.job.reduces=0 -Dmapred.job.queue.name=$queue -files toptitles.tsv,TopTitleFeats.py -input $troot/scoretitle -output $froot/titlefeats -mapper \"python TopTitleFeats.py toptitles.tsv $titletopk\" -reducer NONE"
        echo $cmd
        
        eval $cmd

    fi


    if [ 1 -eq "$(echo "3.3 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.3" | bc)" ]; then 
        hadoop fs -rm -r $froot/traindata 
        # domqlwttgt can be externally provided

        bash dopig.sh JoinFeatures.pig $queue 1000 0 0 "-p domqlsf=$froot/domqlwttgt -p wmfeatsf=$froot/feats.domqls -p aggfeatsf=$sublinkfiles -p titlefeatsf=$froot/titlefeats -p ldafeatsf=$ldatopics -p nldafeats=$nldafeats -p toolbarf=$toolbarf -p out=$froot/traindata"
    fi

    if [ 1 -eq "$(echo "3.4 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.4" | bc)" ]; then 
        hadoop fs -rm -r  $froot/traindata.tsv
        nldafeats_plus_one=$(( nldafeats + 1 ))
        bash dopig.sh JsonFeats2Tsv.pig $queue 1000 0 0 "-p in=$froot/traindata -p out=$froot/traindata.tsv -p nwmfeats=$nwmfeats -p naggfeats=$naggfeats -p ntitlefeats=$ntitlefeats -p nldafeats_plus_one=$nldafeats_plus_one -p ntoolbarfeats=$ntoolbarfeats"
    fi

    if [ 1 -eq "$(echo "3.5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.5" | bc)" ]; then
        hadoop fs -cat $froot/traindata.tsv/part-r-* > tmp.fv
        echo "creating train-header file"
        echo "domainurl,qlurl,weight,label,"$allfeats | tr '+,' '\t' | tee train-header
        cat train-header tmp.fv > feature-train.fv
        gbdt -train $gbdtcfg
    fi

    if [ 1 -eq "$(echo "3.6 == $start" | bc)" ]  && [ 1 -eq "$(echo "$end == 3.6" | bc)" ]; then
	hadoop fs -rm -r $froot/ranked
	gbdtxml=`echo $gbdtxmltype | awk -F ',' '{print $1}'`
        type=`echo $gbdtxmltype | awk -F ',' '{print $2}'`
        echo $gbdtxml $type
        cmd="hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -Dstream.num.map.output.key.fields=2 -Dmapred.text.key.partitioner.options=-k1,1 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options=\"-k1,2\" -Dmapreduce.job.reduces=100 -Dmapred.job.queue.name=$queue -files $gbdtxml,exchange.awk,ApplyRankingModel.py,/home/jyj/mylib/genLibs.py -cacheArchive /user/jyj/distcachesrc/localpython3.tar.gz#local-py -input $froot/traindata -output $froot/ranked -mapper \"exchange.awk\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"./local-py/bin/python ApplyRankingModel.py $gbdtxml $allfeats 10000 False defaultModel $naggfeats,$nwmfeats,$nwmfeats,$ntitlefeats,$nldafeats\""
        echo $cmd
	eval $cmd
        hadoop fs -cat $froot/ranked/part-* > evaluated.tsv
        if [ $type == "rbo" ] ; then
             cat evaluated.tsv | sort -t $'\t' --key=1,1 --key=4,4rg --key=2,2 | awk -F "\t" '{if(q!=$1){tmp=0;print $1"\t"$2"\t"$4"\t"tmp; tmp++;q=$1} else {print $1"\t"$2"\t"$4"\t"tmp; tmp++;q=$1}}' > frommodel.txt
             cat train-data-bing.tsv | sort -t $'\t' --key=1,1 --key=4,4rg --key=2,2 | awk -F "\t" '{if(q!=$1){tmp=0;print $1"\t"$2"\t"$4"\t"tmp; tmp++;q=$1} else {print $1"\t"$2"\t"$4"\t"tmp; tmp++;q=$1}}' | awk -F "\t" '{if($3!=0)print $0}'  > set.bing.target
             python RBO.py frommodel.txt set.bing.target > trained.$gbdtxml.rbo 
        fi
        if [ $type == "dcg" ] ; then
             cat evaluated.tsv | awk -F "\t" '{printf "%s\t%s\t",$1,$2;if($3==7)print "excellent\t"$4;else if($3==3)print "good\t"$4;else if($3==0.5)print "fair\t"$4; else if($3==0)print "bad\t"$4; else print $3"\t"$4}' > a.result.$gbdtxml
             python calcDCG.py a.result.$gbdtxml >& processed.dcg.$gbdtxml 
        fi
    fi
fi

if [ $mode == 'test' ] ; then
    start=${2:-3.1}
    end=${3:-3.4}
    ranktopk=${6:-30}

    gbdtxml=${7:-gbdt_bing.xml,gbdt_edit.xml}
   
    #gbdtxml=${7:-gbdt_bing.xml}

    # convert z/a/b,c/d to b,d
    gbdtxmlshort=`echo $gbdtxml | tr ',' '\n' | awk -F '/' '{print $NF}' | tr '\n' ',' | sed 's/,$//'`


    if [ 1 -eq "$(echo "3.1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.1" | bc)" ]; then 
        hadoop fs -rm -r $froot/urls.test
        pig CutUrls.py $troot/scoretitle $froot/urls.test 0,1 False
    fi
    if [ 1 -eq "$(echo "3.2 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.2" | bc)" ]; then 
        cd ../JoinRedir
        bash JoinRedir.sh $froot/urls.test $froot/feats.test.domqls $wmfeats url $wmfile $queue 1 4
        cd ../Ranking
    fi

    if [ 1 -eq "$(echo "3.25 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.25" | bc)" ]; then 
        # title frequency feature
        hastitlefeats=`hadoop fs -ls | grep $froot/titlefeats`
        if [[ "$hastitlefeats" == "" ]] ; then
            echo creating $froot/titlefeats during test phase!
            if [ -e toptitles.tsv ] ; then 
                echo toptitles.tsv exists!
            else
                echo toptitles.tsv does not exists!
            fi
	    hadoop fs -rm -r $froot/titlefeats
            cmd="hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -Dmapreduce.job.reduces=0 -Dmapred.job.queue.name=$queue -files toptitles.tsv,TopTitleFeats.py -input $troot/scoretitle -output $froot/titlefeats -mapper \"python TopTitleFeats.py toptitles.tsv $titletopk\" -reducer NONE"
            echo $cmd
            
            eval $cmd
        fi
    fi

    if [ 1 -eq "$(echo "3.3 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.3" | bc)" ]; then 
        hadoop fs -rm -r $froot/testdata
        bash dopig.sh JoinFeatures.pig $queue 1000 0 0 "-p domqlsf=$troot/scoretitle -p wmfeatsf=$froot/feats.test.domqls -p aggfeatsf=$sublinkfiles -p titlefeatsf=$froot/titlefeats -p ldafeatsf=$ldatopics -p nldafeats=$nldafeats -p toolbarf=$toolbarf -p out=$froot/testdata"
    fi

    # we don't generate tsv features for test data
    if [ 1 -eq "$(echo "3.4 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.4" | bc)" ]; then 
        cmd="hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -Dstream.num.map.output.key.fields=2 -Dmapred.text.key.partitioner.options=-k1,1 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options=\"-k1,2\" -Dmapreduce.job.reduces=1000 -Dmapred.job.queue.name=$queue -files $gbdtxml,ApplyRankingModel.py,/home/jyj/mylib/genLibs.py -cacheArchive /user/jyj/distcachesrc/localpython3.tar.gz#local-py -input $froot/testdata -output $froot/ranked -mapper \"cat\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"./local-py/bin/python ApplyRankingModel.py $gbdtxmlshort $allfeats $ranktopk False combinedCtrEditGbdtModel $naggfeats,$nwmfeats,$nwmfeats,$ntitlefeats,$nldafeats\""

        # ====================================================================================================== #
        # Below is to be used after combined GBDT is replaced by a single GBDT model, including toolbar features #
        # ====================================================================================================== #
        ## cmd="hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -Dstream.num.map.output.key.fields=2 -Dmapred.text.key.partitioner.options=-k1,1 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options=\"-k1,2\" -Dmapreduce.job.reduces=1000 -Dmapred.job.queue.name=$queue -files $gbdtxml,ApplyRankingModel.py,/home/jyj/mylib/genLibs.py -cacheArchive /user/jyj/distcachesrc/localpython3.tar.gz#local-py -input $froot/testdata -output $froot/ranked -mapper \"cat\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"./local-py/bin/python ApplyRankingModel.py $gbdtxmlshort $allfeats $ranktopk False defaultModel $naggfeats,$nwmfeats,$nwmfeats,$ntitlefeats,$nldafeats,$ntoolbarfeats\""
        echo $cmd
        if [[ $dryrun == '0' ]] ;then

            hadoop fs -rm -r $froot/ranked
            
            eval $cmd 
        fi
    fi 
    if [ 1 -eq "$(echo "3.5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.5" | bc)" ]; then
       #diversity
       #-D mapred.text.key.comparator.options=-k1,4nr
       hadoop fs -rm -r $froot/diversification
       cmd="hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar  -Dmapred.text.key.partitioner.options=-k1,1 -D mapred.text.key.comparator.options=\"-k1,1 -k4,4nr\" -D stream.num.map.output.key.fields=4 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator   -Dmapreduce.job.reduces=1000 -Dmapred.job.queue.name=$queue -files qlcmmr.py,myfunc.py -cacheArchive /user/jyj/distcachesrc/localpython3.tar.gz#local-py -input $froot/ranked -output $froot/diversification -mapper \"cat\" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer \"./local-py/bin/python qlcmmr.py\""
       echo $cmd
       eval $cmd
    fi
fi
if [ $mode == 'lda' ] ; then
    start=${2:-3.1}
    end=${3:-3.3}
    if [ 1 -eq "$(echo "3.1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.1" | bc)" ]; then
        hadoop fs -rm -r $froot/domaintokens
        hadoop jar ~/mylib/jars/hadoop-streaming.jar -Dstream.num.map.output.key.fields=7 -Dmapred.text.key.partitioner.options=-k1,1 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options="-k1,2" -Dmapreduce.job.reduces=3000 -Dmapred.job.queue.name=$queue $compress -files DomainTokens.py,../addtitles/GenTrainToken.py,$mylibloc/genLibs.py -cacheArchive distcachesrc/localpython3.tar.gz#local-py -input $troot/combined.redir.title.wmdata -output $froot/domaintokens -mapper "cat" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer "./local-py/bin/python DomainTokens.py domain 3"
    fi
    if [ 1 -eq "$(echo "3.2 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.2" | bc)" ]; then
        hadoop fs -rm -r $froot/domaintokens.lda
        hadoop jar ~/mylib/jars/hadoop-streaming.jar -Dstream.num.map.output.key.fields=1 -Dmapreduce.job.reduces=100 -Dmapred.job.queue.name=$queue $compress -files Json2LDA.py,$mylibloc/genLibs.py -cacheArchive distcachesrc/localpython3.tar.gz#local-py -input $froot/domaintokens -output $froot/domaintokens.lda -mapper "./local-py/bin/python Json2LDA.py" -reducer cat
    fi
ncats=nldafeats
aggby=rawcount
    if [ 1 -eq "$(echo "3.3 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.3" | bc)" ]; then 
        hadoop fs -rm -r -skipTrash $ldaloc
        /home/jyj/yinst_root/bin/runLDA.sh train $queue $froot/domaintokens.lda $ldaloc 3072 $ncats 1000 /home/jyj/yinst_root/
    fi

    if [ 1 -eq "$(echo "3.4 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.4" | bc)" ]; then
        # experiment with edu sites
        hadoop fs -rm -r -skipTrash $froot/toptitlesbycats.$ncats.$aggby
        python CategoryDomainTitles.pig.py mode=master ldadata=$ldatopics titledata=$troot/scoretitle output=$froot/toptitlesbycats.$ncats.$aggby dryrun=False 
    fi

    if [ 1 -eq "$(echo "3.8 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3.8" | bc)" ]; then 
        # this generates lda data for ql clustering, which is not that useful
        hadoop fs -rm -r $froot/qltokens
        hadoop jar ~/mylib/jars/hadoop-streaming.jar -Dmapreduce.task.timeout=12000000 -Dstream.num.map.output.key.fields=7 -Dmapred.text.key.partitioner.options=-k1,1 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapred.text.key.comparator.options="-k1,2" -Dmapreduce.job.reduces=3000 -Dmapred.job.queue.name=$queue $compress -files DomainTokens.py,QlTokens.py,../addtitles/GenTrainToken.py,$mylibloc/genLibs.py -cacheArchive distcachesrc/localpython3.tar.gz#local-py -input $troot/combined.redir.title.wmdata/par* -output $froot/qltokens -mapper "cat" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer "./local-py/bin/python QlTokens.py"
    fi
fi


