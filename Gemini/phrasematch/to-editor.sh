
 awk -F "\t" '{if($2~/phrase/)print $1"\t"$3}' Nextag.tsv | tail -n +2 > a.1
perl ~/scripts/random-sample.pl a.1 2500 | awk -F "\t" '{if($2!~/-/)print $0}' > google-phrase-to-editor.txt
