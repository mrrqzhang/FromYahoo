
#try superquad bidterm
#sh suite-greedy.sh -s 1 -e 2.4 -r /projects/qrw/ruiqiang/GoogleKeyWord -W '/projects/qrw/ruiqiang/PhraseMatch/BroadBidtermEcpm/' -w 'google-key-words.txt'  -b /projects/qrw/ruiqiang/GoogleKeyWord/clickfeatures -i  'google-key-words.txt'
#sh dopig.sh dumpkunefe.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/nonWLdump -p kunefeDATE=20160[34]* -p device=* -p bucket=*"

#test bidterm selection
sh suite-greedy.sh -s 2.4 -e 2.4 -r /projects/qrw/ruiqiang/GoogleKeyWord -W '/projects/qrw/ruiqiang/Gemini/AllBidTerms/fullbidterms/normal-advertiser' -w 'google-key-words.txt'  -b /projects/qrw/ruiqiang/GoogleKeyWord/clickfeatures -i  'google-key-words.txt'

#sh dopig.sh joinclickfeature2.pig "-p threshold=0.8 -p topn=80 -p input=google-key-words.txt -p clickroot=/projects/qrw/ruiqiang/GoogleKeyWord/clickfeatures -p out=/projects/qrw/ruiqiang/GoogleKeyWord/clickfeaturscore"
#sh suite-greedy.sh -s 1 -e 1 -r /projects/qrw/ruiqiang/GoogleKeyWord -W 'google-key-words.txt' -w 'google-key-words.txt'  -b /projects/qrw/ruiqiang/GoogleKeyWord/clickfeatures -i  'google-key-words.txt'

