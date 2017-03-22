%default root clickedcrawledfeats

%default input '$root/clicked-allchildren'
set default_parallel 500;
SET pig.noSplitCombination true;
%default topk 1000
%default rootdictfile 'rootdict.norm.onejson.abf'

%default sortkey 24

define JoinSr `python JoinSr.py $rootdictfile` ship('$rootdictfile','JoinSr.py','/home/jyj/mylib/genLibs.py');

ret = load '$input' using PigStorage('\t') as (domain:chararray, url:chararray, selfclicks:float, totalclicks:float, ourl:chararray,c1:float, c2:float, n1:float,n2:float,l0:float,l1:float,l2:float,la:float,na:float, selfviews:float, totalviews:float, v1:float, v2:float, depth:float, potential:float, selfctr:float, totalctr:float, ctr1:float, ctr2:float);

ret = stream ret through JoinSr as (domain:chararray, url:chararray, selfclicks:float, totalclicks:float, ourl:chararray,c1:float, c2:float, n1:float,n2:float,l0:float,l1:float,l2:float,la:float,na:float,selfviews:float, totalviews:float, v1:float,v2:float,depth:float,potential:float,selfctr:float,totalctr:float,ctr1:float,ctr2:float);

ret = foreach ret generate url,domain,ourl,selfclicks,totalclicks,c1,c2,n1,n2,l0,l1,l2,la,na,selfviews,totalviews,v1,v2,depth,potential,selfctr,totalctr,ctr1,ctr2, selfclicks + c1 as score;

ret = foreach (group ret by domain) {
    -- tmp = TOP($topk,3,ret); 
    tmp = TOP($topk,$sortkey,ret);
    generate flatten(tmp.(url,domain,ourl,score,selfclicks,totalclicks,c1,c2,n1,n2,l0,l1,l2,la,na,selfviews,totalviews,v1,v2,depth,potential,selfctr,totalctr,ctr1,ctr2)) as (url,domain,ourl,score,selfclicks,totalclicks,c1,c2,n1,n2,l0,l1,l2,la,na,selfviews,totalviews,v1,v2,depth,potential,selfctr,totalctr,ctr1,ctr2);
}
--ret = order ret by domain, totalclicks DESC parallel 100;
ret = order ret by domain, score DESC parallel 100;

%default out '$root/clicked-immchildren.sr.top-$topk'
--%default out '$root/clicked-allchildren.sr.top-$topk'

store ret into '$out' using PigStorage('\t','-schema');
