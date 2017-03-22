REGISTER /home/jyj/mylib/hdstreamlib.py USING jython AS pyudf;
REGISTER /home/jyj/mylib/jars/jyjudfs.jar;

%default froot QuicklinkFeatures
%default croot clickedcrawledfeats

%default domqlsf '$froot/domqlwttgt'
%default wmfeatsf '$froot/feats.domqls'

%default topk 1000

%default aggfeatsf '$croot/clicked-immchildren.sr.top-$topk'

%default titlefeatsf '$froot/titlefeats'

%default ldafeatsf '$froot/out.lda/{*}/lda.out.docToTop.txt'

%default nldafeats 30

%default toolbarf '/user/jyj/agg.ranked.2015'

%default out '$froot/traindata'

%default final_parallel 100

set default_parallel 1000;

define JsonizeFeaturesAgg `python JsonizeFeatures.py 0,1,2` ship('../JoinRedir/JsonizeFeatures.py');

define JsonizeFeaturesTB `python JsonizeFeatures.py 0,1,2` ship('../JoinRedir/JsonizeFeatures.py');

/* Training Data Weight and Target */

-- weight here is reused as title during test mode
domqls = load '$domqlsf' using PigStorage('\t') as (domain:chararray, ql:chararray, weight:chararray,target:float);

domqls = foreach domqls generate pyudf.Normalize(domain) as ndom, pyudf.Normalize(ql) as nql, domain, ql, weight, target;


/* Webmap Features */

wmfeats = load '$wmfeatsf' using PigStorage('\t') as (url:chararray, js:chararray);

wmfeats = foreach wmfeats generate pyudf.Normalize(url) as nurl, url, SIZE(js) as jslen, js;

wmfeats = foreach (group wmfeats by nurl) {
    tmp = TOP(1,2,wmfeats);
    generate flatten(tmp.(nurl, url, js) ) as (nurl, url, js);
}


/* Sublink Features */

aggfeats = load '$aggfeatsf' using TextLoader;

aggfeats = stream aggfeats through JsonizeFeaturesAgg as (nurl:chararray, domain:chararray, url:chararray, js:chararray);

aggfeats = foreach aggfeats generate nurl, pyudf.Normalize(domain) as ndom, domain, url, SIZE(js) as jslen, js;

aggfeats = foreach (group aggfeats by (ndom, nurl) ) {
    tmp = TOP(1,4,aggfeats);
    generate flatten(tmp.(nurl, ndom, domain, url, js)) as (nurl, ndom, domain, url, js);
}


/* Title Features */

titlefeats = load '$titlefeatsf' using PigStorage('\t') as (domain:chararray, url:chararray, js:chararray);

titlefeats = foreach titlefeats generate pyudf.Normalize(domain) as ndom, pyudf.Normalize(url) as nurl, domain, url, SIZE(js) as jslen, js;

titlefeats = foreach (group titlefeats by (ndom, nurl) ) {
    tmp = TOP(1,4,titlefeats);
    generate flatten(tmp.(ndom, nurl, domain, url, js) ) as (ndom, nurl, domain, url, js);
}


/* LDA Features */

ldafeats = load '$ldafeatsf' using PigStorage('\t') as (ndom:chararray, empty:chararray, categories:chararray);

-- ldajs contains the 30 category scores, and the top category index
ldafeats = foreach ldafeats generate ndom, pyudf.ldacats2json(categories,$nldafeats) as js;


/* Toolbar Features */

toolbarfeats = load '$toolbarf' using PigStorage('\t') as (ndom:chararray, url:chararray, cnt:int, rk:int, total_cnt:int, total_cnt_proper:int, cnt_ratio:double, cnt_ratio_proper:double);

toolbarfeats = foreach toolbarfeats generate pyudf.Normalize(url) as nurl, ndom, url, cnt, rk, total_cnt, total_cnt_proper, cnt_ratio, cnt_ratio_proper;

toolbarfeats = stream toolbarfeats through JsonizeFeaturesTB as (nurl:chararray, ndom:chararray, url:chararray, js:chararray); 

toolbarfeats = foreach toolbarfeats generate nurl, ndom, url, SIZE(js) as jslen, js;

toolbarfeats = foreach (group toolbarfeats by (ndom, nurl) ) {
    tmp = TOP(1,3, toolbarfeats);
    generate flatten(tmp.(nurl, ndom, url, js) ) as (nurl, ndom, url, js);
}


/* QL only features */
-- pig cannot parse {('[]')} correctly; though see JoinFeatures.pig.b4refactor for inconsistency
ret = foreach ( cogroup domqls by nql inner, wmfeats by nurl ) generate
        flatten( domqls.(ndom, nql, domain, ql, weight, target) ) as (ndom, nql, domain, ql, weight, target), 
        flatten( ( IsEmpty(wmfeats.js) ? TOBAG(TOTUPLE('[]')) : wmfeats.js ) ) as qlwmjs;

/* Domain only Features */

ret2 = foreach ( cogroup ret by ndom inner, wmfeats by nurl, ldafeats by ndom ) generate
        flatten(ret.(ndom, nql, domain, ql, weight, target, qlwmjs)) as (ndom, nql, domain, ql, weight, target, qlwmjs), 
        flatten( ( IsEmpty(wmfeats) ? TOBAG(TOTUPLE('[]')) : wmfeats.js ) ) as domainwmjs,
        flatten( ( IsEmpty(ldafeats) ? TOBAG(TOTUPLE('[]')) : ldafeats.js ) ) as ldajs;


/* Domain Ql Joint Features */
        
ret3 = foreach ( cogroup ret2 by (ndom, nql) inner, aggfeats by (ndom, nurl), titlefeats by (ndom, nurl), toolbarfeats by (ndom, nurl) ) generate
        flatten(ret2.(ndom, nql, domain, ql, weight, target, qlwmjs, domainwmjs, ldajs )) as (ndom, nql, domain, ql, weight, target, qlwmjs, domainwmjs, ldajs),
        flatten( ( IsEmpty(aggfeats) ? TOBAG(TOTUPLE('[]')) : aggfeats.js ) ) as aggjs,
        flatten( ( IsEmpty(titlefeats) ? TOBAG(TOTUPLE('[]')) : titlefeats.js ) ) as titlejs,
        flatten( ( IsEmpty(toolbarfeats) ? TOBAG(TOTUPLE('[]')) : toolbarfeats.js ) ) as toolbarjs;


/* Partition based on domain and reorder features to be consistent with shell input */

ret4 = foreach ( group ret3 by ndom PARTITION by jyjudfs.KeyFieldBasedTextPartitioner parallel $final_parallel ) generate
        flatten ( ret3.(domain, ql, weight, target, aggjs, domainwmjs, qlwmjs, titlejs, ldajs, toolbarjs) ) as 
                        (domain, ql, weight, target, aggjs, domainwmjs, qlwmjs, titlejs, ldajs, toolbarjs);

store ret4 into '$out' using PigStorage('\t','-schema');
