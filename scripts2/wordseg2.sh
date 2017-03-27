#!/bin/sh

in=$1

awk '{for(i=1;i<NF;i++)printf "%s xaybz ",$i; printf "%s\n",$NF}' $in |\
perl ~/scripts/echoYquery -i - -m jp |\
cut -f 3 |\
awk 'BEGIN{FS=" xaybz "}{ for(i=1;i<NF;i++) printf "%s ",$i; printf "\t"; for(i=1;i<NF;i++) {gsub(" *","",$i); printf "%s ", $i;} printf "\t";   printf "%s\t\n",$NF}' |\
awk 'BEGIN{FS="\t"}{printf "%s\t%s\t%d\n",$2,$1,$3}' 

