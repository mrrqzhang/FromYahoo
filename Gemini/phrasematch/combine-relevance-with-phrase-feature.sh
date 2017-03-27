perl ~/scripts/two-common-fields-join.pl  relevance-features-data.txt one-token-phrase-feature-train-data.txt | cut -f 1,2,3,7- | awk -F "\t" '{print $1"\t"$2"\t"$3" "$4}' > a.1
perl ~/scripts/two-common-fields-join.pl all-judged.result.txt a.1 | cut -f 1,2,3,6- >  a.2
cat a.2 | python generate-features-relevance.py feature-list.map.txt  > feature-full-rel.txt
head -1 feature-full-rel.txt > header_rel.txt
perl ~/scripts/two-common-fields-included.pl phrase-test-data.txt feature-full-rel.txt > a.3
cat header_rel.txt a.3 > feature-test.fv
perl ~/scripts/two-common-fields-diff.pl phrase-test-data.txt feature-full-rel.txt > feature-train.fv

