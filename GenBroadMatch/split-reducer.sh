numSplit=$1
#awk  -F '\\t' -v seg=$numSplit -v random=$RANDOM '{print (NR+random)%seg\"\\t\"\$0}'
awk  -F '\t' -v seg=$numSplit -v random=$RANDOM '{print (NR+random)%seg"\t"$0}'
