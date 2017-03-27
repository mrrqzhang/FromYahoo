#!/bin/sh

in=$1

file=burstScore_$in.txt

data=http://hs12.search.bbt.yahoo.co.jp/yst/recency/$file.gz

wget $data


gunzip -f $file.gz



python /home/ruiqiang/scripts/convertlinebyline.py $file

rm -f $file
