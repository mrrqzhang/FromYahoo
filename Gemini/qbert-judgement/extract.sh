cat 16915.tsv | awk -F "\t" '{print $12"\t"$14"\t"$8}' | tail -n +2 > sum.txt
cat 15938.tsv | awk -F "\t" '{print $12"\t"$13"\t"$8}' | tail -n +2 >> sum.txt
cat 17134.tsv | awk -F "\t" '{print $11"\t"$13"\t"$8}' | tail -n +2  >> sum.txt
cat 17240.tsv | awk -F "\t" '{print $11"\t"$13"\t"$8}' | tail -n +2  >> sum.txt
cat 17455.tsv | awk -F "\t" '{print $11"\t"$13"\t"$8}' | tail -n +2  >> sum.txt
cat 17746.tsv | awk -F "\t" '{print $11"\t"$13"\t"$8}' | tail -n +2  >> sum.txt
cat 17786.tsv | awk -F "\t" '{print $11"\t"$13"\t"$8}' | tail -n +2  >> sum.txt


