#featurefile=gbdtFeatureDump-qlaslm-editorial.txt
#featurefile=gbdtFeatureDump-for-qlas.txt
featurefile=gbdtFeatureDump9-editorial.txt

sed "s/^feature: //g" $featurefile > a.feature 

cat all-judged.result2.txt | awk -F "\t" '{if($3~/Excellent/ || $3~/Good/ || $3~/Fair/ || $3~/Bad/)print $0}' > a.judged
#awk -F "\t" '{if($3~/Excellent/)print $1"\t"$2"\t1.0"; if($3~/Good/)print $1"\t"$2"\t0.8"; if($3~/Fair/)print $1"\t"$2"\t0.5";  if($3~/Bad/)print $1"\t"$2"\t0"}' > a.judged 

perl ~/scripts/two-common-fields-join.pl a.judged  a.feature | cut -f 1,2,3,7- > full-data-feature.txt
cat full-data-feature.txt | python generate-features.py feature-list.new.txt >  feature-train-full.fv

#choose query for test
#cut -f1 a.judged | sort | uniq > a.full-query
#perl  ~/scripts/random-sample.pl a.full-query 500 > a.query-for-test

head -1 feature-train-full.fv > header.txt
perl ~/scripts/diff.pl a.query-for-test feature-train-full.fv > feature-train.fv
perl ~/scripts/included.pl a.query-for-test feature-train-full.fv | sort | uniq > a.fv
cat header.txt a.fv > feature-test.fv

perl ~/scripts/included.pl a.query-for-test a.judged | sort -t $'\t' --key=1,1 --key=3,3rg | uniq > test-best.txt

