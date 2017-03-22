cat  > bidterm
echo "input bidterm word count for this run:" >&2
wc bidterm >&2 
head bidterm >&2


echo "input query file word count for this run:" >&2
wc $PWD/input-query-for-rewrite.txt >&2

python query-bidterm-distance.py $PWD/input-query-for-rewrite.txt bidterm



