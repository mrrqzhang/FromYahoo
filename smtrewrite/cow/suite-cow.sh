#!/bin/sh


USAGE="Usage: `basename $0` -:r:s:e:D:T:h"



root="/user/$USER"

start=1
end=1

VERTICAL=rtl
COW_DATE=201508200000
VERTICAL_VERSION=20150818
advertiserlist=edu.csv

while getopts "r:s:c:e:v:w:a:h" OPT; do
     case "$OPT" in
        r)
          root=$OPTARG
          ;;
        s)
          start=$OPTARG
          ;;
        c)
          COW_DATE=$OPTARG
          ;;
        e)
          end=$OPTARG
          ;;
        a)
          advertiserlist=$OPTARG
          ;;
        v)
          VERTICAL=$OPTARG
          ;;
        w)
          VERTICAL_VERSION=$OPTARG
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



cwd=`pwd`

hadoop fs -rm -r $root/advertiser_sales/$VERTICAL_VERSION
hadoop fs -mkdir -p $root/advertiser_sales/$VERTICAL_VERSION
hadoop fs -copyFromLocal $advertiserlist $root/advertiser_sales/$VERTICAL_VERSION/.


if [ 1 -eq "$(echo "1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1" | bc)" ];  then
   nohup sh dopig.sh advertiser.pig "-p VERTICAL=$VERTICAL -p COW_DATE=$COW_DATE -p VERTICAL_VERSION=$VERTICAL_VERSION -p root=$root"
fi

hadoop fs -rm $root/advertiser_sales/$VERTICAL_VERSION/$VERTICAL.csv
hadoop fs -cat $root/$VERTICAL/$COW_DATE/advertiser/part* | gunzip | awk -F "\t" '{for(i=1;i<=NF;i++)printf "%s,",$i; printf "\n"; }' > $VERTICAL.csv
hadoop fs -copyFromLocal $VERTICAL.csv $root/advertiser_sales/$VERTICAL_VERSION/.


if [ 1 -eq "$(echo "2 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 2" | bc)" ];  then
   sh dopig.sh campaign.pig "-p VERTICAL=$VERTICAL -p COW_DATE=$COW_DATE -p VERTICAL_VERSION=$VERTICAL_VERSION -p root=$root"
fi


if [ 1 -eq "$(echo "3 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 3" | bc)" ];  then
   sh dopig.sh adgroup.pig "-p VERTICAL=$VERTICAL -p COW_DATE=$COW_DATE -p VERTICAL_VERSION=$VERTICAL_VERSION -p root=$root"
fi

if [ 1 -eq "$(echo "4 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 4" | bc)" ];  then
   sh dopig.sh fullid.pig  "-p VERTICAL=$VERTICAL -p COW_DATE=$COW_DATE -p VERTICAL_VERSION=$VERTICAL_VERSION -p root=$root"
fi


if [ 1 -eq "$(echo "5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 5" | bc)" ];  then
   sh dopig.sh bid_term.pig  "-p VERTICAL=$VERTICAL -p COW_DATE=$COW_DATE -p VERTICAL_VERSION=$VERTICAL_VERSION -p root=$root"
fi





