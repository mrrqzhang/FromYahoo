#awk -F "\t" '{if($2~/ / && $1!=$2)print $0}' phrase_feature_log_testCorrected.txt > product.res
cat phrase_feature_log_testCorrected.txt > product.res
cat product.res | python generate-features.py feature-list.map.txt > a.fv 
gbdt -test test-tmp.cfg
echo "product recall"
echo "total:"
wc product.res
echo "product great than 0.59"
awk -F "\t" '{if($3>=0.59)print $0}' product.res | wc
echo "gbdt total"
wc phrasegbdt.150.score
echo "gbdt score>=0.12"
awk -F "\t" '{if($1>=0.12)print $0}' phrasegbdt.150.score | wc
