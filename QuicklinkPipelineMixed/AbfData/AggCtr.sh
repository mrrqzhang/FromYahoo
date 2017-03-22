local=${1:-0}
traffic='AllBuckets/alltraffic' # 5000 parts, split from alltraffic-$dates
root='AllBuckets'
python ChangeParams.py AggCtr.pig "-p input=$traffic -p root=$root"
if [[ $local == 0 ]] ; then
bash dopig.sh AggCtr.pig search_mlr 5000 0 true
else
bash dopig.sh AggCtr.pig search_mlr 5000 0 true "-x local"
fi
