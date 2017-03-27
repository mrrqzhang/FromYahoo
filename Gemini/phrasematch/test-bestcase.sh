cat a.result | sed "s/excellent/hexcellent/g" | sort -t $'\t' --key=1,1 --key=3,3r | sed "s/hexcellent/excellent/g" | awk -F "\t" '{print $1"\t"$2"\t"$3"\t"1000000-NR}' > a.bestcase
 /usr/bin/python calcDCG.py a.bestcase > dcg.out.bestcase

 cat a.result | sed "s/excellent/hexcellent/g" | sort -t $'\t' --key=1,1 --key=3,3 | sed "s/hexcellent/excellent/g" | awk -F "\t" '{print $1"\t"$2"\t"$3"\t"1000000-NR}' > a.worstcase
  /usr/bin/python calcDCG.py a.worstcase > dcg.out.worstcase
