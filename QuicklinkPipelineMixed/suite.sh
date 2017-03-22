#!/bin/sh


USAGE="Usage: `basename $0` -:r:W:s:e:f:T:m:l:c:M:t:h"

#wmv=wm-2014-12-30-18-04-49
#wmv=wm-2015-01-16-23-19-41
#wmv=wm-2015-02-10-21-07-25
wmv=wm-2015-03-17-01-25-00
#wm-2015-02-27-21-13-37
root="/user/$USER/QuickLinkGeneration.abf"
fstTitle=False

trainInput=/user/jyj/AbfData/ctr-by-domviews
#trainInput=/user/ruiqiang/data/train-data-edit.tsv
traincfg=train-edit.cfg
start=1.1
end=4.2
wtindex=4
tgtindex=9
logweight=False
mode=test
rootdict=
titleInput=
viewthreshold=0
clickthreshold=0

while getopts "r:W:s:e:f:T:m:l:c:M:t:g:D:h" OPT; do
     case "$OPT" in
        r)
          root=$OPTARG/QuickLinkGeneration
          ;;
        W)
          wmv=$OPTARG
          ;;
        s)
          start=$OPTARG
          ;;
        e)
          end=$OPTARG
          ;;
        f)
          fstTitle=$OPTARG
          ;;
        T)
          trainInput=$OPTARG
          ;;
        t)
          titleInput=$OPTARG
          ;;
        M)
          mode=$OPTARG
          ;;
        m)
          wtindex=$OPTARG
          ;;
        l)
          tgtindex=$OPTARG
          ;;
        c)
          traincfg=$OPTARG
          ;;
        g) 
          logweight=$OPTARG    # log weight in training
          ;;
        D)
          rootdict=$OPTARG
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



croot=$root/clickedcrawledfeats
troot=$root/QuicklinkTitles
proot=$root/QlPostProcess
froot=$root/QuicklinkFeatures
topk=1000

cwd=`pwd`

# ====================================== #
# Candidate selection + sublink features : 90min # 
# ====================================== #

cd clickonly-wmfeats

candidatetable=crawledurl
featuretable=url

#start=1.1 end=1.8  about 90min
bash Webmap2Candidates.sh $start $end $wmv $croot $topk $clickthreshold $viewthreshold $candidatetable $featuretable default $rootdict 

# ================ #
# Title generation: 150 min #
# ================ #

cd ../addtitles
#start=2.1 end=2.8  # about 150 min
bash GetTitleAnchors-en.sh $start $end $wmv $troot $croot $topk url gbdt.xml 1 default  $titleInput



# =============== #
# FST title: 20 min #
# =============== #

if [ $fstTitle == "True" ] && [ 1 -eq "$(echo "2.9 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2.9" | bc)" ];  then 
    cd ../fstTitle
    hadoop fs -rm -r $root/fstTitles
    pig -f fst-combined.pig  -p input=$root/QuicklinkTitles -p output=$root/fstTitles
fi


# =============== #
# Ranking: about 40 min         #
# =============== #

#start=3.1 end=3.4  
cd ../Ranking

if [ $fstTitle == "True" ]; then
   troot=$root/fstTitles
fi

if [ $mode == "test" ]; then
    bash JoinFeatures.sh test $start $end default 1000 30 gbdt_bing.xml,gbdt_edit.xml $froot $croot $troot $wmv
fi

if [ $mode == "train" ]; then
    bash JoinFeatures.sh train $start $end default 1000 $wtindex $tgtindex  $froot $croot $troot $wmv 0 $trainInput $traincfg $logweight gbdt_edit.xml,rbo
fi

if [ $mode == "lda" ]; then
    bash JoinFeatures.sh lda $start $end default 1000 $wtindex $tgtindex  $froot $croot $troot $wmv 0 $trainInput $traincfg
fi

# =============== #
# Post Processing #
# =============== #

#start=4.1 end=4.5 about 10 min
if [ $mode == "test" ]; then
   cd ../PostProcess

   inputfiles=$froot/diversification   #$froot/ranked
   outputname=processed
   bash PostProcess.sh $start $end $proot $inputfiles $outputname  
fi




# ======================================================================== #
# Pick up your free copy of output xml at $cwd/PostProcess/$outputname.xml #
# ======================================================================== #
