
hadoop fs -cat /projects/qrw/ruiqiang/querysample/part-v004-o000-r-00000.gz | gunzip > file.txt
perl ~/scripts2/binsample.pl file.txt 20 6000 > a.1

hadoop fs -cat /projects/qrw/ruiqiang/querysample/part-v004-o000-r-00001.gz | gunzip > file.txt
perl ~/scripts2/binsample.pl file.txt 20 5000 > a.2


hadoop fs -cat /projects/qrw/ruiqiang/querysample/part-v004-o000-r-00002.gz | gunzip > file.txt
perl ~/scripts2/binsample.pl file.txt 20 4000 > a.3

hadoop fs -cat /projects/qrw/ruiqiang/querysample/part-v004-o000-r-00003.gz | gunzip > file.txt
perl ~/scripts2/binsample.pl file.txt 20 3000 > a.4


hadoop fs -cat /projects/qrw/ruiqiang/querysample/part-v004-o000-r-00004.gz | gunzip > file.txt
perl ~/scripts2/binsample.pl file.txt 20 2000 > a.5
