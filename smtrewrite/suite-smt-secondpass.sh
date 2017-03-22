#!/bin/sh

USAGE="Usage: `basename $0` -:r:s:e:D:T:h"



firstpassroot=/projects/qrw/ruiqiang/Gemini/smtrewrite_edu_nobl/
firstpassdecode=decode-edu
#decode-edu/postclickrewrite/thresholdcut/part*
secondpassdecode=decode-edu-secondpass
#secondpassroot=/projects/qrw/ruiqiang/Gemini/smtrewrite_edu_nobl

firstpassqrw=firstpassqrw.txt
firstpassbidterms=firstpassbidterms.txt

start=0
end=0


while getopts "s:e:r:c:d:h" OPT; do
     case "$OPT" in
        s)
          start=$OPTARG
          ;;
        e)
          end=$OPTARG
          ;;
        r)
          firstpassroot=$OPTARG
          ;;
        c)
          firstpassdecode=$OPTARG
          ;;
        d)
          secondpassdecode=$OPTARG
          ;;
        \?)
          echo "$USAGE"
          exit 1
          ;;
     esac
done

if [ 1 -eq "$(echo "1 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 1" | bc)" ]; then
     hadoop fs -rm -r $firstpassbidterms $firstpassqrw
     hadoop fs -cat $firstpassroot/$firstpassdecode/postclickrewrite/thresholdcut/part* | python secondpass-select.py > $firstpassqrw
     cut -f2 $firstpassqrw | sort | uniq > $firstpassbidterms
     hadoop fs -copyFromLocal $firstpassbidterms .
     hadoop fs -copyFromLocal $firstpassqrw .
fi

if [ 1 -eq "$(echo "2 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 2" | bc)" ]; then
    sh suite-smt-rewrite.sh -m onlinetest -q default -s 0 -e 2.2  -g 300 -n 1 -b 5000 -d $secondpassdecode -l 50 -r $firstpassroot -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part*  -i $firstpassbidterms
fi

btfilter2=$firstpassroot/$secondpassdecode/btfilter2
if [ 1 -eq "$(echo "3 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 3" | bc)" ]; then
    sh dopig.sh secondpassjoin.pig "-p second=$firstpassroot/$secondpassdecode/btfilter -p first=$firstpassqrw -p out=$btfilter2"
fi

if [ 1 -eq "$(echo "4 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 4" | bc)" ]; then
    sh suite-smt-rewrite.sh -m onlinetest -q default -t $btfilter2 -s 2.4 -e 2.6 -g 300 -n 1 -b 5000 -d $secondpassdecode -l 50 -r $firstpassroot -w /projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/part*  -i $firstpassbidterms
fi

if [ 1 -eq "$(echo "5 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 5" | bc)" ]; then
   sh dopig.sh secondpassmerge.pig "-Dmapred.output.compress=false -p first=$firstpassroot/$firstpassdecode/postclickrewrite/thresholdcut/part* -p second=$firstpassroot/$secondpassdecode/postclickrewrite/thresholdcut/part* -p out=$firstpassroot/$secondpassdecode/final"
fi

if [ 1 -eq "$(echo "6 >= $start" | bc)" ] && [ 1 -eq "$(echo "$end >= 6" | bc)" ]; then
   sh dopig.sh postprocess.pig "-Dmapred.output.compress=false -p input=$firstpassroot/$secondpassdecode/final -p out=$firstpassroot/$secondpassdecode/postprocess"
fi



