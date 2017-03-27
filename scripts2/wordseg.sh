#!/bin/sh

in=$1

awk 'BEGIN{FS="\t"}{print $1, $2}' $in | perl ~/scripts/echoYquery -i - -m jp | awk 'BEGIN{FS="\t"}{print $3}' | awk '{for(i=1;i<NF-1;i++) printf "%s ", $i; print $(NF-1)"\t"$NF}' 
