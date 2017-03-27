#google-have-yahoo-have query
 python ~/scripts/join.py ../buckets/google-phrase-to-editor.txt phrase-score.txt | awk -F "\t" '{if(match($1,$2)!=0)print $0}' |  awk -F "\t" '{if($2==$4)print $0}' | cut -f1 | sort | uniq > a.1
#google-have-yahoo-not query
 perl ~/scripts/diff.pl a.1 ../buckets/google-phrase-to-editor.txt  > a.2
#join google and yahoo
 python ~/scripts/join.py a.2 phrase-score.txt  | cut -f 1,2,4,5 > google-have-yahoo-not.query.txt
 
