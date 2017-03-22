input=$1

gbdtxml=gbdt_bing.xml.new

wmfeats=selrank,hostrank,inlinkcnt,internalinlinkcnt,linkflux,clicks,views,outlinkcnt,crawled,dup,spam,porn,unique,worthcrawl,dupcode,domaincnt,docclass,crawlertrap,crawl_trust_selection_rank,crawl_trust,aggreginlinkcnt,aggregsyntaxinlinkcnt,anyerror,audio,badbehavior,badext,badscheme,corpwpscore,crawl_trust_cash_ext,document,dynamic,dynscore,editporn,gdcrawlrank,gif,gigadoc,hasafflinks,hasvalidredirtarget,html,http,https,image,interestchina,inlinkcompressratio,internaloutlinkcnt,isrss,jpeg,lfspam,linked_from_sitemap,linked_from_sitemap_only,linkstoporn,linkstospam,linktime_count,linktime_max_day,linktime_mean,linktime_min_day,linktime_recent_inlinks,linktime_stdev,linktime_weighted_recent_inlinks,max_modified_selection_rank,mp3,num_anchortext_lines,parent,pdf,ps,public,qualityscore,rawdomaincnt,rawdomaincntofhost,real,realaudio,redirect,redirinlinkcnt,redirsourcecnt,ruleredirect,ruleredirsourcecnt,s404score,spamscore,srpscore,streaming,tempredirect,uiscnt,video,windows,wireless,worddoc,xhtml,xml

nwmfeats=`echo $wmfeats | tr ',' '\n' | wc -l`

#aggfeats=`hadoop fs -cat $sublinkfiles/.pig_header | cut -d$'\t' -f4- | awk -F '\t' 'BEGIN{OFS=","}{$1=$1;print $0}'`
aggfeats=score,selfclicks,totalclicks,c1,c2,n1,n2,l0,l1,l2,la,na,selfviews,totalviews,v1,v2,depth,potential,selfctr,totalctr,ctr1,ctr2

naggfeats=`echo $aggfeats | tr ',' '\n' | wc -l`




titlefeats=""
if [ "$titlefeats" == '' ] ; then
    ntitlefeats=1
    titlefeats=titlefreq
else
    ntitlefeats=`echo $titlefeats | tr ',' '\n' | wc -l`
    ntitlefeats=$(( ntitlefeats + 1 ))
    titlefeats=$titlefeats",titlefreq"
fi

numfields=`echo domain,ql,title,score,aggjs,domwmjs,qlwmjs,titlejs | tr ',' '\n' | wc -l`
allfeats=$aggfeats+domain_
allfeats=$allfeats`echo $wmfeats | sed 's/,/,domain_/g'`
allfeats=$allfeats+$wmfeats+$titlefeats



ranktopk=100

    
gbdtxmlshort=`echo $gbdtxml | tr ',' '\n' | awk -F '/' '{print $NF}' | tr '\n' ',' | sed 's/,$//'`

cat $input | awk -F "\t" '{print $1"\t"$2"\t"$4"\t"$3"\t"$5"\t"$6"\t"$7}' |  python ApplyRankingModel.py $gbdtxmlshort $allfeats $ranktopk False defaultModel  $naggfeats,$nwmfeats,$nwmfeats,$ntitlefeats |  awk -F "\t" '{printf "%s\t%s\t",$1,$2;if($3==7)print "excellent\t"$4;else if($3==3)print "good\t"$4;else if($3==0.5)print "fair\t"$4; else if($3==0)print "bad\t"$4; else print $3"\t"$4}' > a.result.$gbdtxml

python calcDCG.py a.result.$gbdtxml >& processed.dcg.$gbdtxml
