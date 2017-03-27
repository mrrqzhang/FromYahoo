sh rbo-train-data-prep.sh
gbdt -train train.cfg
 cat feature-list.new.txt | awk -F "\t" '{if($2~/\$/)print $1"\t1"; else print $1"\t0"}' > gbdtFeatureDict.txt

# for test
nohup sh editorial-train-data-prep.sh

