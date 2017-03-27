#!/bin/sh


#irdev17 irdev20 irdev21 irdev28 irdev29 irdev31 irdev32 irdev33 irdev35

homedir=/home/ruiqiang/

rundir=/net/irdev17/export/crawlspace/ruiqiang/recencyv2/USmarket/scrape010809


machine[0]=irdev17
machine[1]=irdev19
machine[2]=irdev20
machine[3]=irdev21
machine[4]=irdev22
machine[5]=irdev23
machine[6]=irdev24
machine[7]=irdev25
machine[8]=irdev18
machine[9]=irdev27
machine[10]=irdev28
machine[11]=irdev29
machine[12]=irdev31
machine[13]=irdev32
machine[14]=irdev33



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

   ssh ${machine[$i]} -l ruiqiang  cut -f 1 $rundir/$in.0$i |\
    ~ciyaliao/bin/RunQueries -mode prod -market us -numres 30 -fields title,discovery_time,lastmod,last_crawl_time,dateextract_min,dateextract_max,cat_buzz_level,cat_ctwgt_linkadd_days_since2007,cat_buzz_time_days_since2007 -xorro 0 >& $rundir/$in.0$i.ipdout &

done




