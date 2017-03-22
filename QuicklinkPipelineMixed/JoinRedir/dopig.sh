queue=${2:-default}
numred=${3:-100}
local=${4:-0}
bigfile=${5:-0}
flags=${6:-""}
bigparam=
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

cmd="pig $localflag -f $1 -Dfs.permissions.umask-mode=022 -Dmapred.job.queue.name=$queue -Dmapreduce.reduce.speculative=true -Dmapreduce.map.speculative=true -Dmapreduce.map.memory.mb=6072 -Dmapreduce.fileoutputcommitter.marksuccessfuljobs=true -Dmapreduce.reduce.failures.maxpercent=10 -Dmapreduce.job.reduces=$numred -Dpig.additional.jars=/home/jyj/mylib/jars/jyson-1.0.2.jar $flags $bigparam"
echo $cmd
eval $cmd
