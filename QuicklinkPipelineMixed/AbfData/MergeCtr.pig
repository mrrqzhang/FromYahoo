REGISTER /homes/jyj/Projects/quicklinks/jyson-1.0.2.jar;
REGISTER /homes/jyj/mylib/hdstreamlib.py USING jython AS pyudf;
REGISTER /homes/xingyi/fetl_sequence_projector/lib/jar/BaseFeed.jar;
REGISTER /homes/xingyi/fetl_sequence_projector/lib/jar/SequenceProjector.jar;
REGISTER /homes/jyj/Projects/quicklinks/jyjudfs.jar;

%default epsilon 0.000000001
%default root AllBuckets
%default filenametrunk ctr-by-domclicks
%default defbucid 'all'
%default daterange ''
%default bucdates '*'
-- %default bucdates 'YSE00456-100[0-9]'    -- example
%default in '$root/$filenametrunk-$bucdates'
%default out1 '$root/merged-ctr-by-domviews-$defbucid-$daterange'
%default out2 '$root/merged-ctr-by-domclicks-$defbucid-$daterange'

-- grid 
SET default_parallel 100;
%default final_parallel 100
/* */

/* -- local 
SET default_parallel 1;
%default final_parallel 1
*/

ret = load '$in' using PigStorage('\t') as (parent_url:chararray, url:chararray, ql_txt:chararray, bucid:chararray, nviews:int, nviews_cond:int, nclicks:int, nviews_dom:int, nclicks_dom:int, ctr:float, ctr_cond:float) ;

/* -- option 1: aggregate by parent_url, url, ql_txt
ret2 = foreach (group ret by (parent_url, url, ql_txt) ) {
    tmp = TOP(1,0,ret);
    generate    flatten(group) as (parent_url, url, ql_txt), 
                flatten(tmp.bucid) as bucid, 
                SUM(ret.nviews) as nviews, 
                SUM(ret.nviews_cond) as nviews_cond, 
                SUM(ret.nclicks) as nclicks,
                SUM(ret.nviews_dom) as nviews_dom,
                SUM(ret.nclicks_dom) as nclicks_dom;
}
*/

-- option 2: aggregate by parent_url, url, then pick the best ql_txt
ret2 = foreach (group ret by (parent_url, url) ) {
    tmp = TOP(1,9,ret); -- top ctr
    generate    flatten(group) as (parent_url, url), 
                flatten(tmp.(ql_txt,bucid)) as (ql_txt,bucid), 
                SUM(ret.nviews) as nviews, 
                SUM(ret.nviews_cond) as nviews_cond, 
                SUM(ret.nclicks) as nclicks,
                SUM(ret.nviews_dom) as nviews_dom,
                SUM(ret.nclicks_dom) as nclicks_dom;
}
/* */

ret3 = foreach ret2 generate *, (float) nclicks / ( (float ) nviews + $epsilon ) as ctr, (float) nclicks_dom / ( (float) nviews_dom + $epsilon) as ctr_cond;

ret4 = order ret3 by nviews_dom DESC, parent_url, ctr DESC, url parallel $final_parallel;

store ret4 into '$out1' using PigStorage('\t','-schema');


ret5 = order ret3 by nclicks_dom DESC, parent_url, ctr DESC, url parallel $final_parallel;

store ret5 into '$out2' using PigStorage('\t','-schema');

