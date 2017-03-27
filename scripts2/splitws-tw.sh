#!/bin/sh


#irdev17 irdev20 irdev21 irdev28 irdev29 irdev31 irdev32 irdev33 irdev35

homedir=/home/ruiqiang/
#rundir=/net/irdev17/export/crawlspace/ruiqiang/recencyv2/JPmarket/scrape021008/

machine[0]=irdev17
machine[1]=irdev19
machine[2]=irdev20
machine[3]=irdev21
machine[4]=irdev22
machine[5]=irdev23
machine[6]=irdev24
machine[7]=irdev25
machine[8]=irdev26
machine[9]=irdev27
machine[10]=irdev28
machine[11]=irdev29
machine[12]=irdev31
machine[13]=irdev32
machine[14]=irdev33



TN=13

in=$1

num=`awk 'END{print NR}' $in`


step=$(($num/$TN))





final=$(($TN+1))


for (( i=0 ; $i<$final ; i++ )) ; do
   start=$(($i*$step))
   end=$(( ($i+1)*$step ))
#    echo "$start $end"
   awk -v b=$start -v e=$end '{if(NR>=b&&NR<e) print $0}' $in >& $in.0$i

   awk '{for(i=1;i<NF;i++)printf "%s xaybz ",$i; printf "%s\n",$NF}' $in.0$i |\
   perl ~/scripts/echoYquery -i - -m tw |\
   cut -f 3 |\
   awk 'BEGIN{FS=" xaybz "}{ for(i=1;i<NF;i++) printf "%s ",$i; printf "\t"; for(i=1;i<NF;i++) {gsub(" *","",$i); printf "%s ", $i;} printf "\t";   printf "%s\t\n",$NF}' |\
   awk 'BEGIN{FS="\t"}{printf "%s\t%s\t%d\n",$2,$1,$3}' >& $in.0$i.seg &


done


###cat $rundir/$in*seg | sort | awk 'BEGIN{FS="\t"}{if(NR==1){first=$1; num=$2; } else{if(first==$1) num+=$2; else {print first"\t"num; first=$1;num=$2}}}END {print first"\t"num}' >& output.seg



