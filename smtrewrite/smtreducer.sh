cat >> $PWD/bi-data.txt

GizeMaxPhraseLen=6

head $PWD/bi-data.txt >&2
cut -f2 $PWD/bi-data.txt > $PWD/bi-data.txt.jp
cut -f3 $PWD/bi-data.txt > $PWD/bi-data.txt.en 
$PWD/moses/scripts/tokenizer/tokenizer.perl < $PWD/bi-data.txt.jp > $PWD/bi-data.txt.tok.jp
$PWD/moses/scripts/tokenizer/tokenizer.perl < $PWD/bi-data.txt.en > $PWD/bi-data.txt.tok.en
$PWD/moses/scripts/training/clean-corpus-n.perl $PWD/bi-data.txt.tok jp en clean 1 50 1> /dev/null

perl $PWD/moses/scripts/training/train-model.perl -max-phrase-length=$GizeMaxPhraseLen -insert-null -first-step=1 -last-step=8 -external-bin-dir $PWD/mgiza/ -mgiza -root-dir $PWD -corpus $PWD/clean -f jp -e en -alignment grow-diag-final -reordering msd-bidirectional-fe 1> /dev/null

gunzip -c $PWD/model/phrase-table.gz |  awk '{print "PHRASETABLE\t"$0}'
gunzip -c $PWD/model/reordering-table.wbe-msd-bidirectional-fe.gz | awk '{print "REORDER\t"$0}'

