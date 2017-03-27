#03/07/2016

cut -f1 to-editors-5K.txt.old to-editors-6K.txt | uniq > a.1
perl ~/scripts/diff.pl a.1 ../phrasematch/phrase-score.txt | cut -f1 | uniq > a.2
perl ~/scripts/random-sample.pl a.2 2000 > a.3
perl ~/scripts/included.pl a.3 ../phrasematch/phrase-score.txt | awk '{if($0!~/template by/)print $0}' > to-editors-round10.txt



if false ; then
cut -f1 to-editors-5K.txt.old | uniq > a.1
perl ~/scripts/diff.pl a.1 ../phrasematch/phrase-score.txt | cut -f1 | uniq > a.2
perl ~/scripts/random-sample.pl a.2 2000 > a.3
perl ~/scripts/included.pl a.3 ../phrasematch/phrase-score.txt | awk '{if($0!~/template by/)print $0}' > to-editors-6K.txt

#bucket freq ranked queies
tail -n +9000 phrasematch-to-editor.txt > a.1
#matched with phrase-score 
perl ~/scripts/included.pl ../phrasematch/phrase-score.txt a.1 | cut -f1  | uniq > a.3
#unmatched phrase-score queries
perl ~/scripts/diff.pl a.3 ../phrasematch/phrase-score.txt | cut -f1 | uniq > a.4
#sample 900 from unmatched
perl ~/scripts/random-sample.pl a.4 900 > a.5
#total samples
cat a.3 a.5 > a.6
perl ~/scripts/included.pl a.6 ../phrasematch/phrase-score.txt > to-editors-5K.txt
fi

