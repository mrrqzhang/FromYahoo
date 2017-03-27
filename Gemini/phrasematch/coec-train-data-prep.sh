
featurefile=gbdtFeatureDump8-qlas-newrbo-coec.txt

rbosource=query-phrase.rbo

coecsource=source-coec.txt

trainsample=50000

#featurefile=gbdtFeatureDump-merged.txt
#rbosource=train-rbo-merged.txt

cat $rbosource | tail -n +2 | head -n -1 > a.1
cat a.1 | awk -F "\t" '{if($3==0)print $0}' > a.score=0
perl  ~/scripts/random-sample.pl a.score=0 $trainsample > b.score=0
cat a.1 | awk -F "\t" '{if($3==1 && $1==$2)print $0}' > a.score=1
perl  ~/scripts/random-sample.pl a.score=1 3000 > b.score=1
cat a.1 | awk -F "\t" '{if($3!=0 && !($3==1 && $1==$2))print $0}' > b.2
cat b.2 b.score=0 b.score=1 > full-rbo-data.txt


sed "s/^feature: //g" $featurefile > a.feature
cat a.feature | cut -f 4- | awk '{for(i=1;i<=NF;i++)print $i}' | awk -F ":" '{print toupper($1)}' | sort | uniq > all-feature.txt

perl ~/scripts/diff.pl non-category-feature.txt all-feature.txt | awk -F "\t" '{printf $1"\t"$1"$\n"}' > a.1
cat a.1 non-category-feature.txt > feature-list.new.txt

perl ~/scripts/two-common-fields-join.pl full-rbo-data.txt a.feature | cut -f 1,2,3,7- > full-rbo-data-feature.txt
cat full-rbo-data-feature.txt | python generate-features-rbo.py feature-list.new.txt >  feature-train-rbo.fv

#choose query for test

#cut -f1 full-rbo-data.txt | sort | uniq > a.full-query
#perl  ~/scripts/random-sample.pl a.full-query 30000 > a.query-for-test

head -1 feature-train-rbo.fv > header-rbo.txt
perl ~/scripts/diff.pl a.query-for-test feature-train-rbo.fv > feature-train.fv
perl ~/scripts/included.pl a.query-for-test feature-train-rbo.fv | sort | uniq > a.fv
cat header-rbo.txt a.fv > feature-test.fv

perl ~/scripts/included.pl a.query-for-test full-rbo-data.txt | sort -t $'\t' --key=1,1 --key=3,3rg | uniq > test-best-rbo.txt

