%default root 'clickedcrawledfeats'
%default langf '$root/urls.lang'
%default topk 1000
%default dqsf '$root/clicked-immchildren.sr.top-$topk/par*'
%default out '$root/filtered.lang'
%default final_parallel 100
set default_parallel 100;
SET pig.noSplitCombination true;

lang = load '$langf' using PigStorage('\t') as (url:chararray, language:chararray);

--url,domain,ourl,score,selfclicks,totalclicks,c1,c2,n1,n2,l0,l1,l2,la,na,selfviews,totalviews,v1,v2,depth,potential,selfctr,totalctr,ctr1,ctr2

dqs = load '$dqsf' using PigStorage('\t'); 
ret = foreach (cogroup dqs by $1 inner, lang by url) generate group as domain, 
                    flatten(dqs.($2,$3)) as (ql, score), 
                    flatten( ( IsEmpty(lang.language) ? TOBAG(TOTUPLE('unknown')) : lang.language ) ) as dom_lang;

ret = foreach (cogroup ret by ql inner, lang by url) generate flatten(ret.(domain, ql, score, dom_lang)) as 
                                                                            (domain, ql, score, dom_lang),
                            flatten( ( IsEmpty(lang.language) ? TOBAG(TOTUPLE('unknown')) : lang.language ) ) as ql_lang;

ret = filter ret by ( dom_lang == ql_lang OR LOWER(ql_lang) == 'unknown' OR LOWER(ql_lang) == 'english' OR ql_lang == '' ) ;

ret = foreach ret generate domain, ql, score;

ret = order ret by domain, score DESC parallel $final_parallel;
store ret into '$out' using PigStorage('\t','-schema');

