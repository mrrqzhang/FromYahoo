nfs=$1
nm=$2
root=$3
out=$4
for (( i=0 ; i < $nfs ; i++ ))
do
  num=$( printf '%05d' $i )
  startid=$(( $nm*$i ))
  hadoop fs -cat $root/part-$num* | awk -v d=$startid -v nm=$2 '{for(j=0;j<nm;j++) print d+j"\t"$0}' > part-temp.txt
  hadoop fs -copyFromLocal part-temp.txt $out/part-$num
  rm -rf part-temp.txt
done

