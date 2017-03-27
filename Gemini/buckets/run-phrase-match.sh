sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/FBCM83-0109 -p kunefeDATE=2017010[56789] -p device=mobile -p bucket=FBCM83"
#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/FBCM99 -p kunefeDATE=2017010[56789] -p device=mobile -p bucket=FBCM99"
#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/FBCM55 -p kunefeDATE=2017010[56789] -p device=mobile -p bucket=FBCM55"

#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/B3078-3 -p kunefeDATE=2016120[1234] -p device=desktop -p bucket=B3078"
#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/B2600-3 -p kunefeDATE=2016120[1234] -p device=desktop -p bucket=B2600"

#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/B2846-2 -p kunefeDATE=2016111[012345] -p device=desktop -p bucket=B2846"
#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/B2846 -p kunefeDATE=2016112[3456789] -p device=desktop -p bucket=B2846"
#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/B3078-2 -p kunefeDATE=2016111[012345] -p device=desktop -p bucket=B3078"
#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/B2600-2 -p kunefeDATE=2016111[012345] -p device=desktop -p bucket=B2600"

#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/FBCM53 -p kunefeDATE=2016081[01234] -p device=mobile -p bucket=FBCM53"

#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/B2401 -p kunefeDATE=2016081[01] -p device=desktop -p bucket=B2401"
#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/B2600 -p kunefeDATE=2016081[01] -p device=desktop -p bucket=B2600"
#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/B2206 -p kunefeDATE=2016081[01] -p device=desktop -p bucket=B2206"

#hcat /projects/qrw/ruiqiang/GeminiBuckets/desktop/part* | gunzip | grep n1 | grep PREFERRED | awk -F "\t" '{print $13"\t"$8"\t"$5}' | python ctr.py >& a.1
# cat a.1 | awk -F "\t" '{if($5<0.04 && $4>=25 && $2!=" ") print $0}' | cut -f 1,2 > qbert-blacklist.txt

#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/desktop_blacklist -p kunefeDATE=2016072[234] -p device=desktop -p bucket=B2401"

#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/alldesktop -p kunefeDATE=2016071[4567] -p device=desktop -p bucket=*"
#sh dopig.sh dump-match-type.pig "-p out=/projects/qrw/ruiqiang/GeminiBuckets/desktop -p kunefeDATE=2016071[4567] -p device=desktop -p bucket=B2401" 




#hadoop fs -cat /projects/qrw/ruiqiang/GeminiBuckets/B3078-2/part* | gunzip | grep n1 | grep QBERT |  awk '{if($0~/About.com/ || $0~/Ask.com/ || $0~/When.com/ || $0~/wow.com/)n+=1} END{print n,NR,n/NR}'








