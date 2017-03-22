# sample flags: "-p DATE=20150518 -p out=ruiqiang_gemini/travel2 -p querylist=ruiqiang_gemini/ybn_travel_queries.txt"

flags=${2:-""}
bigparam=
bigfile=0
queue=${3:-"default"}
#queue=curveball_small
numred=${4:-"100"}

allviews=" -Dmapreduce.cluster.acls.enabled=false \
           -Dmapreduce.job.acl-view-job=* \
           -Dmapreduce.job.acl-modify-job=* "

if [[ $local == 1 ]] ;  then
    localflag="-x local -Doutput.compression.codec=org.apache.hadoop.io.compress.GzipCodec"
else
    localflag=""
fi

if [[ $bigfile == 1 ]] ; then
    #bigparam="-Dmapred.min.split.size=5073741824 -Dpig.maxCombinedSplitSize=5073741824 -Dmapreduce.jobtracker.split.metainfo.maxsize=-1 -Dmapred.child.java.opts=-Xmx2048m"
    #bigparam="-Dmapred.min.split.size=273741824 -Dpig.maxCombinedSplitSize=273741824 -Dmapreduce.jobtracker.split.metainfo.maxsize=-1"
    bigparam="-Dmapred.min.split.size=1073741824 -Dpig.maxCombinedSplitSize=1073741824 -Dmapreduce.jobtracker.split.metainfo.maxsize=-1"
fi

cmd="pig -f $1 $allviews -Dmapred.output.compress=true -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec -Dfs.permissions.umask-mode=022 -Dmapred.job.queue.name=$queue -Dmapreduce.reduce.speculative=true -Dmapreduce.map.speculative=true -Dmapreduce.map.memory.mb=6072 -Dmapreduce.fileoutputcommitter.marksuccessfuljobs=true -Dmapreduce.reduce.failures.maxpercent=10 -Dmapreduce.job.reduces=$numred $flags $bigparam"
echo $cmd
eval $cmd
