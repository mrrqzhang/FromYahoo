
#input feature-full.fv

TN=5

tail -n +2 feature-full.fv | cut -f 1 | sort | uniq >& full-index.qry

num=`awk 'END{print NR}' full-index.qry`


test_size=$(($num/$TN))

final=$(($TN+1))


head -1 feature-full.fv >& header_file

tail -n +2 feature-full.fv >& temp.fv

for (( i=0 ; $i<$final ; i++ )) ; do
   	perl ~/scripts/random-sample.pl full-index.qry $test_size >& test.qry
   	perl ~/scripts/included.pl test.qry temp.fv  >& a.tmp
#   	cat header_file a.tmp >& feature-test.fv
   	perl ~/scripts/diff.pl test.qry temp.fv  >& a.tmp
   	cat header_file a.tmp >& feature-train.fv
   	gbdt -train train.cfg
   	gbdt -test test.cfg

      	cut -f 263 feature-test.fv | tail -n +2 > a.3  #263 for full, use 181/186 if no/yes rel feature; 201 for qlas feature, 216 if included 
      	cut -f 1,2 feature-test.fv | tail -n +2 > a.1
      	paste a.1  a.3 phrasegbdt.300.score | awk -F "\t" '{printf "%s\t%s\t",$1,$2;if($3==1)print "excellent\t"$4;else if($3==0.8)print "good\t"$4;else if($3==0.5)print "fair\t"$4; else if($3==0)print "bad\t"$4}' | sort -t $'\t' --key=1,1  --key=4,4rg > a.result
      	/usr/bin/python calcDCG.py a.result > dcg.out.$i

        gbdt -train train-exclude.cfg
	gbdt -test test.cfg
	cut -f 263 feature-test.fv | tail -n +2 > a.3 
	cut -f 1,2 feature-test.fv | tail -n +2 > a.1
	paste a.1  a.3 phrasegbdt.300.score | awk -F "\t" '{printf "%s\t%s\t",$1,$2;if($3==1)print "excellent\t"$4;else if($3==0.8)print "good\t"$4;else if($3==0.5)print "fair\t"$4; else if($3==0)print "bad\t"$4}' | sort -t $'\t' --key=1,1  --key=4,4rg > a.result
	/usr/bin/python calcDCG.py a.result > dcg.out.$i.noqlas




done

   
