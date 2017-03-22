bindir=$PWD/moses
#/homes/ruiqiang/tools/moses-git/mosesdecoder

smtroot=$1
nmodel=$2

nbest=$3
cat > file.txt
head file.txt >&2 
echo "input file word count for this run:" >&2
wc file.txt >&2 

#remove long words query
cut -f2 file.txt | awk '{if(NF<20) print $0}'  > input.txt
echo "after long sentence cut  word count for this run:" >&2
wc input.txt >&2

num2=`cut -f1 file.txt | sort -rg | uniq | head -1`
echo "processing file id: $num2" >&2
num=`echo $(( $num2 % $nmodel )) | awk '{printf "%05d",$0;}'`
echo "Call model id: $num" >&2

rm -f model.txt.gz model.txt simply-1gram.lm kunefe-query.lm
hadoop fs -copyToLocal $smtroot/part-*$num.gz model.txt.gz
gunzip model.txt.gz
hadoop fs -copyToLocal hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:/user/ruiqiang/simply-1gram.lm .
hadoop fs -copyToLocal hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:/user/ruiqiang/data/kunefe-query.lm .
grep "PHRASETABLE" $PWD/model.txt | cut -f2- | gzip > phrase-table.gz
grep "REORDER" $PWD/model.txt | cut -f2- | gzip > reordering-table.wbe-msd-bidirectional-fe.gz

chmod a+x $bindir/* $bindir/*/* $bindir/*/*/* $bindir/*/*/*/*

$bindir/scripts/tokenizer/tokenizer.perl < input.txt > tokenized_input.txt
echo "tokenized result word count for this run:" >&2
wc tokenized_input.txt >&2

rm -rf filtered
$bindir/scripts/training/filter-model-given-input.pl  $PWD/filtered $PWD/moses.ini tokenized_input.txt 1> /dev/null
$bindir/bin/moses  --include-segmentation-in-n-best  -n-best-list output.txt $nbest -f $PWD/filtered/moses.ini < tokenized_input.txt 1> /dev/null


cat output.txt | sed "s/ NULL//g" | \
                 sed "s/\&amp;/\&/g" | \
                 sed "s/\&#124;/\|/g" | \
                 sed "s/\&lt;/\</g" | \
                 sed "s/\&gt;/\>/g" | \
                 sed "s/\&apos;/\'/g" | \
                 sed "s/\&quot;/\"/g" | \
                 sed "s/\&#91;/\[/g" | \
                 sed "s/\&#93;/\]/g" | \
                 awk -F " \\\|\\\|\\\| " 'BEGIN{tmp1="";n=0} \
                                          {if(tmp1!=$1) \
                                               {for(i=0;i<n;i++)print arr[ind[i]];delete arr; arr[$2]=$0;ind[0]=$2;tmp1=$1;n=1} \
                                           else if(!($2 in arr)) {arr[$2]=$0;ind[n]=$2;n++} \
                                          }END{for(i=0;i<n;i++)print arr[ind[i]];delete arr;}' | sort -k1b,1 > output1.txt


#must sort before join
awk '{print NR-1" "$0}' input.txt | sort -k1b,1  > input1.txt
join -1 1 -2 1  input1.txt output1.txt | sed "s/^[0-9]* //g" 

