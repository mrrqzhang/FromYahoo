REGISTER /home/jyj/mylib/hdstreamlib.py USING jython AS pyudf;


%default root 'clickedcrawledfeats'
%default redpfile '$root/urls.redt.parenturl'
%default topk 1000

%default rankf '$root/clicked-immchildren.sr.top-$topk'
%default filterf '$root/filtered.lang'
%default out '$rankf.dedup'


set default_parallel 500;
%default final_parallel 100

redp = load '$redpfile' using PigStorage('\t') as (url:chararray, redt:chararray, parenturl:chararray);

--url,domain,ourl,score,selfclicks,totalclicks,c1,c2,n1,n2,l0,l1,l2,la,na,selfviews,totalviews,v1,v2,depth,potential,selfctr,totalctr,ctr1,ctr2
ret = load '$rankf' using PigStorage('\t');

filtered = load '$filterf' using PigStorage('\t') as (domain, ql, score:float);
ret = foreach (cogroup filtered by (domain, ql, score) inner, ret by ($1, $2, $3)) generate flatten(ret);

ret = foreach ret generate $1 as domain, $2 as ql, ( (float) $3 ) as score;
ret = foreach (cogroup ret by ql inner, redp by url ) {
    generate flatten(ret.(domain,ql,score)) as (domain, ql, score), 
            flatten( ( IsEmpty(redp.url) ? TOBAG(TOTUPLE( group, group )) : redp.(redt, parenturl) ) ) as (redt, parenturl);
}

ret2 = foreach (group ret by (domain, ql)) generate flatten( pyudf.PostSelectionRedirDedup(ret.(domain, ql, score, redt, parenturl ) ) ) as (domain, ql, score);

ret2 = order ret2 by domain, score DESC parallel $final_parallel;

store ret2 into '$out' using PigStorage('\t','-schema');
