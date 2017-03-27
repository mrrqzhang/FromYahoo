featuredumpinput=$1

#featuredumpinput=one-token-gbdtFDCorrected.txt
#perl ~/scripts/two-common-fields-join.pl one-phrase-token-judged.txt $featuredumpinput  | cut -f 1,2,3,7- | sort | uniq > b.txt

cat $featuredumpinput > b.txt
cat b.txt | python generate-features.py feature-list.map.txt > a.fv
gbdt -test test-tmp.cfg 
cut -f 1,2,181 a.fv | tail -n +2 > b.1
 paste b.1 phrasegbdt.150.score | awk -F "\t" '{if($4>=0.5)print $3}' | sort | uniq -c
