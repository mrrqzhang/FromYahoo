#cp feature-train.fv.fullset feature-train.fv
head -1 feature-train.fv > head.txt
tail -n +2 feature-train.fv > a.feature
for num in  50000 60000 80000 100000 120000 ; do 
   echo "training data size:", $num	
   perl ~/scripts/random-sample.pl a.feature $num > a.2
   cat head.txt a.2 > feature-train.fv # use header_rel.txt for rel feature
   gbdt -train train.cfg
   gbdt -test test.cfg

#   cut -f 1,2 feature-test.fv | tail -n +2 > b.1
#   paste b.1 phrasegbdt.150.score | sort -t $'\t' --key=1,1 --key=3,3rg > a.3
#   python RBO.py a.3 test-best-rbo.txt  
   cut -f 216 feature-test.fv | tail -n +2 > a.3  #use 181/186 if no/yes rel feature; 201 for qlas feature, 216 if included lm
#      echo "AUC:"
      #   paste phrasegbdt.150.score a.3 | awk -F "\t" '{if($2>0.5) print $1"\t1"; else print $1"\t0"}' |  /usr/bin/python  ~/scripts/calc-auc.py
   cut -f 1,2 feature-test.fv | tail -n +2 > a.1
   paste a.1  a.3 phrasegbdt.300.score | awk -F "\t" '{printf "%s\t%s\t",$1,$2;if($3==1)print "excellent\t"$4;else if($3==0.8)print "good\t"$4;else if($3==0.5)print "fair\t"$4; else if($3==0)print "bad\t"$4}' | sort -t $'\t' --key=1,1  --key=4,4rg > a.result
   /usr/bin/python calcDCG.py a.result > dcg.out.$num

done

