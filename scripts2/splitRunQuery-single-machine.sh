#!/bin/sh


#irdev17 irdev20 irdev21 irdev28 irdev29 irdev31 irdev32 irdev33 irdev35

homedir=/home/ruiqiang/

rundir=/net/irdev17/export/crawlspace/ruiqiang/recencyv2/USmarket/scrape010809


TN=12 #use only 12x

in=$1



num=`awk 'END{print NR}' $in`


step=$(($num/$TN))





final=$(($TN+1))


for (( i=0 ; $i<$final ; i++ )) ; do
   start=$(($i*$step))
   end=$(( ($i+1)*$step ))
#    echo "$start $end"
   awk -v b=$start -v e=$end '{if(NR>=b&&NR<e) print $0}' $rundir/$in >& $rundir/$in.0$i

   cut -f 1 $rundir/$in.0$i |\
    ~ciyaliao/bin/RunQueries -mode prod -market us -numres 30 -fields title,discovery_time,lastmod,last_crawl_time,dateextract_min,dateextract_max,cat_buzz_level,cat_ctwgt_linkadd_days_since2007,cat_buzz_time_days_since2007 -xorro 0 >& $rundir/$in.0$i.ipdout &

done




