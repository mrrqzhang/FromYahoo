queue=${2:-search_mlr}
numred=${3:-100}
bigfile=${4:-0}
spec=${5:-"true"}
flags=${6:-""}
bigparam=
if [[ $bigfile == 1 ]] ; then
    #bigparam="-Dmapred.min.split.size=5073741824 -Dpig.maxCombinedSplitSize=5073741824 -Dmapreduce.jobtracker.split.metainfo.maxsize=-1 -Dmapred.child.java.opts=-Xmx2048m"
    #bigparam="-Dmapred.min.split.size=273741824 -Dpig.maxCombinedSplitSize=273741824 -Dmapreduce.jobtracker.split.metainfo.maxsize=-1"
    bigparam="-Dmapred.min.split.size=3073741824 -Dpig.maxCombinedSplitSize=3073741824 -Dmapreduce.jobtracker.split.metainfo.maxsize=-1"
    #bigparam="-Dmapred.min.split.size=1073741824 -Dpig.maxCombinedSplitSize=1073741824 -Dmapreduce.jobtracker.split.metainfo.maxsize=-1"
elif [[ $bigfile == 2 ]] ; then
    bigparam="-Dmapred.min.split.size=1073741824 -Dpig.maxCombinedSplitSize=1073741824 -Dmapreduce.jobtracker.split.metainfo.maxsize=-1"
fi
#cmd="pig -f $1 -Dfs.permissions.umask-mode=022 -Dmapred.job.queue.name=$queue -Dmapreduce.reduce.speculative=true -Dmapreduce.map.speculative=true -Dmapreduce.map.memory.mb=4072 -Dmapreduce.fileoutputcommitter.marksuccessfuljobs=true -Dmapred.compress.map.output=true -Doutput.compression.enabled=true -Doutput.compression.codec=org.apache.hadoop.io.compress.GzipCodec -Dmapreduce.reduce.failures.maxpercent=10 -Dmapreduce.job.reduces=$numred -Dpig.maxCombinedSplitSize=1280000000"
cmd="pig -f $1 -Dfs.permissions.umask-mode=022 -Dmapred.job.queue.name=$queue -Dmapreduce.reduce.speculative=$spec -Dmapreduce.map.speculative=$spec -Dmapreduce.map.memory.mb=6072 -Dmapreduce.fileoutputcommitter.marksuccessfuljobs=true -Dmapred.compress.map.output=true -Doutput.compression.enabled=true -Doutput.compression.codec=org.apache.hadoop.io.compress.GzipCodec -Dmapreduce.reduce.failures.maxpercent=10 -Dmapreduce.job.reduces=$numred -Dpig.additional.jars=/homes/jyj/Projects/quicklinks/jyson-1.0.2.jar $flags $bigparam"
echo $cmd
eval $cmd
