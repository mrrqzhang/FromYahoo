#to compare old golden set and new goldenset
perl ~/scripts/random-sample.pl <(hadoop fs -cat /projects/qrw/ruiqiang/PhraseGenGoldenSet2/OnlyNewPhrases/filter2from1/part* | gunzip) 2000 > old-phrases-samples.txt 
perl ~/scripts/random-sample.pl <(hadoop fs -cat /projects/qrw/ruiqiang/PhraseGenGoldenSet2/OnlyNewPhrases/filter1from2/part* | gunzip) 2000 > new-phrases-samples.txt


#sh suite-phrase-bidterm.sh -s 10 -e 10 -r /projects/qrw/ruiqiang/PhraseGenGoldenSet2 -w  /projects/qrw/ruiqiang/DirForPhraseGolden/*.txt

#sh suite-phrase-bidterm.sh -s 1 -e 9 -r /projects/qrw/ruiqiang/PhraseGenGoldenSet2 -w  /projects/qrw/ruiqiang/DirForPhraseGolden/*.txt

#sh suite-phrase-bidterm.sh -s 9 -e 9 -r /projects/qrw/ruiqiang/PhraseGenGoldenSet -w  /projects/qrw/ruiqiang/DirForPhraseGolden/*.txt 

#sh suite-phrase.sh -s 1 -e 1 -r /projects/qrw/ruiqiang/PhraseGen  
 
