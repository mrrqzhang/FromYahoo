cat $1 | cut -f 2,3,5,7 | sed "s/ql:VL/excellent/g" | sed "s/ql:L/good/g" | sed "s/ql:PNL/fair/g" | sed "s/ql:DNL/bad/g" | sed "s/ql:NJ/bad/g" | awk -F "\t" '{print $1"\t"$2"\t"$3"\t"100-$4}'> a.result
python calcDCG.py a.result > $1.dcg
