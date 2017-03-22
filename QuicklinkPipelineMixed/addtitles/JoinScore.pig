%default root QuicklinkTitles
%default titlef '$root/decided'
%default scoref 'clickedcrawledfeats/clicked-immchildren.sr.top-100.dedup/par*'
%default out '$root/scoretitle'
%default final_parallel 100;
set default_parallel 100;
%default topk 100


titledata = load '$titlef' using PigStorage('\t') as (domain:chararray, url:chararray, finaltitle:chararray);

scoredata = load '$scoref' using PigStorage('\t') as (domain:chararray, url:chararray, score:float); -- first four columns are url,domain,ourl,score
   
ret = foreach (cogroup titledata by (domain, url), scoredata by (domain, url) inner) generate flatten(group) as (domain, ql), flatten(titledata.finaltitle) as title, flatten(TOP(1,2,scoredata).score) as score;

ret = foreach (group ret by domain) {
    tmp = TOP($topk, 3, ret);
    generate flatten(tmp.(domain,ql,title,score)) as (domain, ql, title, score);
}


ret = order ret by domain, score DESC parallel $final_parallel;

store ret into '$out' using PigStorage('\t','-schema');

