perl ~/scripts/two-common-fields-join.pl full-smt-score.txt <(sed "s/+//g" google-broad-click-impression.txt) > b.1
cat b.1 | cut -f 3,6,7 | awk -F "\t" '{printf "%s\t%s\t%s\n", substr($1,0,3),$2,$3}' | sort -g | ~//tools/Python-3.4.4/bin/python3 ctr.py
