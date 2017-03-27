export PYTHONPATH=/homes/ruiqiang/tools/scipy:/homes/ruiqiang/tools/sklearn:/homes/ruiqiang/tools/cython:/homes/ruiqiang/tools/nose-1.0.0:/homes/ruiqiang/tools/nose:/homes/ruiqiang/tools/numpy-1.11.0rc1:/homes/ruiqiang/tools/numpy-1.11.0rc1/lib64/python2.6/site-packages:/homes/ruiqiang/tools/scipy/scipy-0.16.0-py2.6-linux-x86_64.egg/

cp feature-train-full.fv feature-train.fv
head -1 feature-train-full.fv > head.txt

tail -n +2 feature-train.fv > a.feature
for num in  10000 20000 30000 40000 50000 60000  ; do 
   echo "training data size:", $num	
   perl ~/scripts/random-sample.pl a.feature $num > a.2
   cat head.txt a.2 > feature-train.fv # use header_rel.txt for rel feature
   gbdt -train train.cfg
   gbdt -test test.cfg
   cut -f 216 feature-test.fv | tail -n +2 > a.3  #use 181/186 if no/yes rel feature; 201 for qlas feature, 216 if included lm
   echo "AUC:"
#   paste phrasegbdt.150.score a.3 | awk -F "\t" '{if($2>0.5) print $1"\t1"; else print $1"\t0"}' |  /usr/bin/python  ~/scripts/calc-auc.py
   cut -f 1,2 feature-test.fv | tail -n +2 > a.1
   paste a.1  a.3 phrasegbdt.300.score | awk -F "\t" '{printf "%s\t%s\t",$1,$2;if($3==1)print "excellent\t"$4;else if($3==0.8)print "good\t"$4;else if($3==0.5)print "fair\t"$4; else if($3==0)print "bad\t"$4}' | sort -t $'\t' --key=1,1  --key=4,4rg > a.result
   /usr/bin/python calcDCG.py a.result > dcg.out.$num
done

