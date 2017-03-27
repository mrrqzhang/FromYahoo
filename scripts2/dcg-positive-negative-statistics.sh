#!/bin/sh

org=$1
imp=$2

temp=$$

echo "overall performance"
python /home/zhaohui/tools/signtest/wilcoxon.newversion.py $org $imp

perl ~/scripts/merge-two-files.pl $org $imp >& $temp.1

awk 'BEGIN{FS="\t"}{if($6>$3) printf "%s\t%s\t%s\n",$1,$2,$3}' $temp.1 >& $temp.g.1

awk 'BEGIN{FS="\t"}{if($6>$3) printf "%s\t%s\t%s\n",$4,$5,$6}' $temp.1 >& $temp.g.2

echo
echo
echo "Improved dcg query#:"
wc -l $temp.g.1 | awk '{print $1}'

python /home/zhaohui/tools/signtest/wilcoxon.newversion.py $temp.g.1 $temp.g.2

echo
echo
echo "Equal dcg query #:"
awk 'BEGIN{FS="\t"}{if($6==$3) printf "%s\t%s\t%s\n",$1,$2,$3}' $temp.1 >& $temp.g.1
wc -l  $temp.g.1 | awk '{print $1}'

echo
echo
echo "Worse dcg queries"
awk 'BEGIN{FS="\t"}{if($6<$3) printf "%s\t%s\t%s\n",$1,$2,$3}' $temp.1 >& $temp.g.1

awk 'BEGIN{FS="\t"}{if($6<$3) printf "%s\t%s\t%s\n",$4,$5,$6}' $temp.1 >& $temp.g.2

wc  $temp.g.1 | awk '{print $1}'

python /home/zhaohui/tools/signtest/wilcoxon.newversion.py $temp.g.1 $temp.g.2

rm -f *.1 *.2
