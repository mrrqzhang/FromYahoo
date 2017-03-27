#!/bin/sh


USAGE="Usage: `basename $0` -:r:s:e:D:T:h"

root="/user/$USER/GeminiEvaluation"

qbertInput=hdfs://dilithiumred-nn1.red.ygrid.yahoo.com:8020/tmp/binlu/scoring_travel_rewrite_part2/rewrite.score/
bucket=FBCM25
device=mobile
start=1
end=2

kunefeDATE0='2015'
kunefeDATE1='2015'
kunefeDATE2='2015'
kunefeDATE3='2015'

while getopts "r:s:b:d:e:T:D:E:F:G:h" OPT; do
     case "$OPT" in
        r)
          root=$OPTARG
          ;;
        s)
          start=$OPTARG
          ;;
        b)
          bucket=$OPTARG
          ;;
        d)
          device=$OPTARG  
          ;;
        e)
          end=$OPTARG
          ;;
        D)
          kunefeDATE0=$OPTARG
          ;;
	E)
	  kunefeDATE1=$OPTARG
	  ;;
	F)
	  kunefeDATE2=$OPTARG
	  ;;
	G)
	  kunefeDATE3=$OPTARG
	  ;;
        T)
          qbertInput=$OPTARG
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


kroot=$root/smallkunefe
eroot=$root/evaluation
mroot=$root/metrics
c1root=$root/adgroupcoverage1
c2root=$root/adgroupcoverage2

cwd=`pwd`


#### join by query (qbert, kunefe)
if [ 1 -eq "$(echo "1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1" | bc)" ];  then
   hadoop fs -rm -r -skipTrash $kroot
   sh dopig.sh dumpkunefe.pig "-p out=$kroot -p qbertInput=$qbertInput -p kunefeDATE0=$kunefeDATE0 -p kunefeDATE1=$kunefeDATE1 -p kunefeDATE2=$kunefeDATE2 -p kunefeDATE3=$kunefeDATE3  -p device=$device -p bucket=$bucket"
fi

#### join by (query, rewrite) for (qbert, kunefe)
if [ 1 -eq "$(echo "2 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2" | bc)" ];  then
   hadoop fs -rm -r -skipTrash $eroot
   sh dopig.sh evaluate.pig "-p out=$eroot -p qbertInput=$qbertInput -p smallkunefe=$kroot"
fi


#### n1 broad metrics: ctr, revenue
if [ 1 -eq "$(echo "3 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3" | bc)" ];  then
   hadoop fs -cat $eroot/smt_rewrite/part* |gunzip | grep n1 | grep PREFERRED | awk -F "\t" '{if($4==1)print $6"\t"$7}' > metrics.txt
   hadoop fs -cat $eroot/smt_rewrite/part* |gunzip | grep n1 | grep PREFERRED | awk -F "\t" '{v++; c+=$4; m+=$4*$5} END{print "smt rewrite:",c,v,c/v, m, m/c}' >> metrics.txt
   hadoop fs -cat $eroot/nonsmt_rewrite/part* |gunzip | grep n1 | grep PREFERRED | awk -F "\t" '{if($4==1)print $6"\t"$7}' >> metrics.txt
   hadoop fs -cat  $eroot/nonsmt_rewrite/part* |gunzip | grep n1 | grep PREFERRED | awk -F "\t" '{v++; c+=$4; m+=$4*$5} END{print "non smt rewrite:",c,v,c/v, m, m/c}' >> metrics.txt
   hadoop fs -rm $eroot/metrics.txt
   hadoop fs -copyFromLocal  metrics.txt $eroot
   echo "CTR and PPC metrics are saved in grid directory $eroot. columns in turn: pos, match type, view (impression), click, ctr, rev, ppc\n"
fi






