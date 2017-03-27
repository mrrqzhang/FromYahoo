hadoop fs -cat /projects/qrw/ruiqiang/GeminiBuckets/FBCM83/part* | gunzip | awk -F "\t" '{if($5==1)sum+=$10} END{print sum}'
hadoop fs -cat /projects/qrw/ruiqiang/GeminiBuckets/FBCM55/part* | gunzip | awk -F "\t" '{if($5==1)sum+=$10} END{print sum}'

hadoop fs -cat /projects/qrw/ruiqiang/GeminiBuckets/FBCM83/part* | gunzip | awk -F "\t" '{if($5==1)print $2}' | sort | uniq -c > FBCM83.qry.count.txt
hadoop fs -cat /projects/qrw/ruiqiang/GeminiBuckets/FBCM55/part* | gunzip | awk -F "\t" '{if($5==1)print $2}' | sort | uniq -c > FBCM55.qry.count.txt

cat FBCM55.qry.count.txt | awk '{if($0!~/\%/){for(i=2;i<NF;i++)printf $i" ";print $NF}}' > FBCM55.qry.txt
cat FBCM83.qry.count.txt | awk '{if($0!~/\%/){for(i=2;i<NF;i++)printf $i" ";print $NF}}' > FBCM83.qry.txt

cat FBCM55.qry.txt FBCM83.qry.txt | sort | uniq  > to-qlas.txt

nohup sh run-qlas.sh >& log.2
hcat temp/qlasoutput/part* | gunzip |awk '{if($0~/place_name/)print $0}' | cut -f1 > to-dump.txt

cat to-dump.txt | sed "s/  / /g" | sed "s/  / /g" | awk '{print tolower($0)}' > to-dump-norm.txt 

hadoop fs -cat /projects/qrw/ruiqiang/GeminiBuckets/FBCM83/part* | gunzip | awk -F "\t" '{if($5==1)print $2"\t"$10}' > a.2
perl ~/scripts/included.pl to-dump.txt FBCM83.qry.txt > a.1


hcat temp/qlasoutputfull/part* | gunzip | awk -F "\t" '{if($0~/place_name/)print $0}' | cut -f1 > all-geo.qry.txt


hcat temp/qlasoutput/part* | gunzip | grep "place_name" | python rewrite-qlas-output.py | awk -F "\t" '{if($2!~/ /)print $0}' > qlas-one-token.txt

