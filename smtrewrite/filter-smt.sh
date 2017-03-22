bindir=.
#/homes/ruiqiang/tools/moses-git/mosesdecoder

smtroot=$1

input=$2

mosesini=$3

rm -f model.txt.gz model.txt
hadoop fs -copyToLocal $smtroot/part*.gz model.txt.gz
gunzip model.txt.gz
grep "PHRASETABLE" $PWD/model.txt | cut -f2- | gzip > phrase-table.gz
grep "REORDER" $PWD/model.txt | cut -f2- | gzip > reordering-table.wbe-msd-bidirectional-fe.gz

$bindir/scripts/tokenizer/tokenizer.perl < $input > tokenized_input.txt
rm -rf filtered
$bindir/scripts/training/filter-model-given-input.pl  $PWD/filtered $mosesini tokenized_input.txt 1> /dev/null


