
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
   cat header_file a.tmp >& feature-test.fv
   perl ~/scripts/diff.pl test.qry temp.fv  >& a.tmp
   cat header_file a.tmp >& feature-train.fv
   gbdt -train gbdt.cfg
   gbdt -test gbdt-test.cfg

   awk 'BEGIN {print "score"} {print $0}' gbdt_gs.400.score >& score.with.head
   paste  feature-test.fv score.with.head | awk -F "\t" '{print $5"\t"$42}' | sed "s/skip/v/g"| sed "s/click/c/g"  >& gs.score.$i    
   python ~/GrandSlam/calc-roc.py gs.score.$i
   gbdt -test gbdt-product.cfg
   awk 'BEGIN {print "score"} {print $0}' gbdt_dwell3.400.score >& score.with.head
   paste  feature-test.fv score.with.head | awk -F "\t" '{print $5"\t"$42}' | sed "s/skip/v/g"| sed "s/click/c/g"  >& gs.score.product.$i
   python ~/GrandSlam/calc-roc.py gs.score.product.$i
done

   
