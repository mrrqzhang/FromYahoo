#!/usr/bin/bash

start=${1:-1.1}
end=${2:-1.9}
wmv=${3:-"wm-2014-12-08-02-01-03"}
root=${4:-"clickedcrawledfeats"}
topk=${5:-1000}
clickfilter=${6:-0.001}
viewfilter=${7:-0.001}
qltable=${8:-crawledurl}
table2=${9:-url}
queue=${10:-default} # alternative is webmap; but need to compete against crawler for resource 
#rootdictfile=${10:-"rootdict.norm.onejson.pranav"}
rootdictfile=${11:-"../AbfData/rootdict.norm.onejson.abf"}
# ================= #
# Sublink Algorithm #
# ================= #

# Copy the dictionary of relevant search result url roots to cwd
#cp ../DomainSelection/$rootdictfile .
cp $rootdictfile .
rootdictfile=`echo $rootdictfile | awk -F '/' '{print $NF}'`

# Get all urls from webmap satisfying the click count filter : 30min
if [ 1 -eq "$(echo "1.1 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1.1" | bc)" ]; then 
    if [[ `hadoop fs -ls /webmap/batches/$wmv` == "" ]] ; then
        echo "Webmap version $wmv does not exist any more!" 
        exit 
    fi
    hadoop fs -rm -r $root/WebmapAllUrls-views $root/WebmapAllUrls-views-inlinkcnt
    bash dopig.sh WebmapAllUrls-views.pig $queue 10000 0 0 "-p out=$root/WebmapAllUrls-views -p outlinkcnt=$root/WebmapAllUrls-views-inlinkcnt -p clickfilter=$clickfilter -p viewfilter=$viewfilter -p wmv=$wmv -p table=$qltable -p rootdictfile=$rootdictfile"
fi

# Ruiqiang's immediate children click count aggregation algorithm plus my additional 21 aggregate features generation
# Output columns are url,domain,ourl,score,selfclicks,totalclicks,c1,c2,n1,n2,l0,l1,l2,la,na,selfviews,totalviews,v1,v2,depth,potential,selfctr,totalctr,ctr1,ctr2
# =============
# url = normalized url, ourl = original url, domain = unnormalized domain, selfclicks = click count of url itself
# c1,v1,n1,l1 = sum of immediate children clicks,views,counts,linkflux
# c2,v2,n2,l2 = sum of grandchildren clicks,views,counts,linkflux
# totalclicks,totalviews,na,la = sum of all descendants clicks, views, counts, linkflux
# depth = number of delimiters between domain and url
# potential = maximum of numbers of delimiters between url and all its descendants including self
# selfctr, totalctr, ctr1,ctr2 = ctr of url itself, all descendants including self, all immediate children, all grandchildren
# score = selfclicks + c1
# =============
if [ 1 -eq "$(echo "1.2 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1.2" | bc)" ]; then
   hadoop fs -rm -r $root/clicked-allchildren
   hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -Dstream.num.map.output.key.fields=6 -Dmapred.text.key.partitioner.options=-k2,2 -Dmapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -Dmapreduce.job.reduces=10000 -Dmapred.text.key.comparator.options="-k2,2 -k1,1" -Dmapred.output.compress=true -Dmapred.job.queue.name=$queue -Dmapred.output.compression.codec=org.apache.hadoop.io.compress.BZip2Codec -files mapper-2.py,FindParent-feats.py,/home/jyj/mylib/genLibs.py -input $root/WebmapAllUrls-views/par* -output $root/clicked-allchildren -mapper "python mapper-2.py 0 1" -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner -reducer "python FindParent-feats.py"
fi


# Join with only the search result urls we care: for instance, maps.google.com can be a quicklink for www.google.com, but not images.google.com
# The rule above is not optimal, but without browser data we need a way to restrict the scope

if [ 1 -eq "$(echo "1.3 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1.3" | bc)" ]; then
   hadoop fs -rm -r "$root/clicked-immchildren.sr.top-$topk"
   bash dopig.sh GetTop200.joinSr.pig $queue 10000 0 0 "-p topk=$topk -p rootdictfile=$rootdictfile -p input=$root/clicked-allchildren -p out=$root/clicked-immchildren.sr.top-$topk"
fi

# =============================================== #
# Dedupping by redirtarget, title, dup group, etc #
# =============================================== #

# Extract the urls for domain and ql columns from the sublink algorithm output
if [ 1 -eq "$(echo "1.4 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1.4" | bc)" ]; then
   hadoop fs -rm -r "$root/urls.domql"
   bash dopig.sh GetDomainQlUrls-dup.pig $queue 100 0 0 "-p out=$root/urls.domql -p input=$root/clicked-immchildren.sr.top-$topk"
fi

# Extract language of each candidate link
if [ 1 -eq "$(echo "1.5 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1.5" | bc)" ]; then
    if [[ `hadoop fs -ls /webmap/batches/$wmv` == "" ]] ; then
        echo "Webmap version $wmv does not exist any more!" 
        exit 
    fi
    hadoop fs -rm -r "$root/urls.lang"
    hadoop jar /home/jyj/mylib/jars/webmap-table-format-2.5.0.jar com.yahoo.corp.yst.webmap.input.example.FieldsDump -Dfieldsdump.maps=100 -Dfieldsdump.reduces=2000 -Dmapred.map.tasks=10 -Dmapred.reduce.tasks=2000 -Dfieldsdump.fields=url,language -Dfieldsdump.map=$table2 -Dfieldsdump.atoms=/webmap/batches/$wmv/atoms -Dfieldsdump.mode=iterate -Dfieldsdump.input=$root/urls.domql/par* -Dfieldsdump.output=$root/urls.lang
fi


# Filter out non-English links
if [ 1 -eq "$(echo "1.6 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1.6" | bc)" ]; then
   hadoop fs -rm -r "$root/filtered.lang"
   bash dopig.sh LanguageFilter.pig $queue 100 0 0 "-p out=$root/filtered.lang -p dqsf=$root/clicked-immchildren.sr.top-$topk -p langf=$root/urls.lang"
fi
# Get redirect urls and dup group parent urls, for further deduping 

if [ 1 -eq "$(echo "1.7 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1.7" | bc)" ]; then
    if [[ `hadoop fs -ls /webmap/batches/$wmv` == "" ]] ; then
        echo "Webmap version $wmv does not exist any more!" 
        exit 
    fi
    hadoop fs -rm -r "$root/urls.redt.parenturl"
    hadoop jar /home/jyj/mylib/jars/webmap-table-format-2.5.0.jar com.yahoo.corp.yst.webmap.input.example.FieldsDump -Dfieldsdump.maps=200 -Dfieldsdump.reduces=2000 -Dmapred.map.tasks=200 -Dmapred.reduce.tasks=2000 -Dfieldsdump.fields=url,redirtarget,parenturl -Dfieldsdump.map=$table2 -Dfieldsdump.atoms=/webmap/batches/$wmv/atoms -Dfieldsdump.mode=iterate -Dfieldsdump.input=$root/urls.domql -Dfieldsdump.output=$root/urls.redt.parenturl
fi


rankf=$root/clicked-immchildren.sr.top-$topk
# Normalized url, dup-parent url, and redirect url dedupping
if [ 1 -eq "$(echo "1.8 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1.8" | bc)" ]; then
   hadoop fs -rm -r "$rankf.dedup"
   bash dopig.sh RemoveRedirDup.pig $queue 100 0 0 "-p filterf=$root/filtered.lang -p rankf=$rankf -p out=$rankf.dedup -p redpfile=$root/urls.redt.parenturl"
fi

# check that top10k domains are in the output
if [ 1 -eq "$(echo "1.9 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1.9" | bc)" ]; then
    # True/False denotes whether or not to normalize
    hadoop fs -rm -r "$root/checktop10k"
    hadoop jar /home/jyj/mylib/jars/hadoop-streaming.jar -files /home/jyj/mylib/genLibs.py,../AbfData/seed_urls.top10k,CheckTop10k.py -Dmapreduce.job.reduces=1 -Dmapred.job.queue.name=$queue -input $rankf.dedup -output $root/checktop10k -mapper "python CheckTop10k.py seed_urls.top10k Found True" -reducer "python CheckTop10k.py seed_urls.top10k Missing False"
    echo "number of missing domains from top 10k: "
    hadoop fs -cat $root/checktop10k/par* | wc -l
    hadoop fs -cat $root/checktop10k/par*
fi

# generate single layer domain list: 50min
if [ 1 -eq "$(echo "1.91 >= $start" | bc)" ]  && [ 1 -eq "$(echo "$end >= 1.91" | bc)" ]; then
   hadoop fs -rm -r $root/singlelayer-domainlist
   hadoop fs -rm -r $root/singlelayer-quicklink
   bash dopig.sh find-singlelayer.pig $queue 500 0 0  "-p input=$rankf.dedup/part* -p output=$root/singlelayer-domainlist"
   hadoop fs -cat $root/singlelayer-domainlist/part* | python Root2Sr.py $rootdictfile >& single-layer.dict.largedomain.json
   bash dopig.sh filter-single-layer3.pig $queue 1000 0 0  "-p input=$root/WebmapAllUrls-views-inlinkcnt/part* -p output=$root/singlelayer-quicklink"
fi




