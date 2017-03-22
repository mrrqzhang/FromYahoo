cat  > bidterm
#cut -f2 bidterm | awk '{for(i=1;i<=NF;i++) print $i"\t"$0}' | sort -t $'\t' -k1b,1 | uniq   > wordindexed.bidterm
#cut -f1 $PWD/input-query-for-rewrite.txt | awk '{for(i=1;i<=NF;i++) print $i"\t"$0}' | sort  -t $'\t' -k1b,1 | uniq  > wordindexed.query
echo "input bidterm word count for this run:" >&2
wc bidterm >&2 
head bidterm >&2

cut -f 2- bidterm > bidterm.noid
#python query-bidterm-distance.py $PWD/input-query-for-rewrite.txt bidterm.noid >&2
chmod a+x $PWD/query-bidterm-distance
$PWD/query-bidterm-distance $PWD/input-query-for-rewrite.txt bidterm.noid 


