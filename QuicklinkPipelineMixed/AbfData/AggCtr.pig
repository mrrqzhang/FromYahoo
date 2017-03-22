REGISTER /homes/jyj/mylib/hdstreamlib.py USING jython AS pyudf;
SET pig.noSplitCombination true;
--grid
set default_parallel 5000;
%default final_parallel 100
/* */

/* --local
%default input 'AllBuckets/alltraffic'
set default_parallel 1;
%default final_parallel 1
*/

-- uni buckets
%default root 'UniBuckets'
%default input '$root/alltraffic'
%default defbucid 'YSE00(4|5|6)'
%default defmtestid '.*YST01_M.*YSE00(4|5|6).*'
/* */


/* -- all buckets
%default input 'AllBuckets/alltraffic'
%default root 'AllBuckets'
%default defbucid 'all'
%default defmtestid '.*'
*/

%default daterange ''
%default out1 '$root/ctr-by-domviews-$daterange'
%default out2 '$root/ctr-by-domclicks-$daterange'



%default epsilon 0.000000001


ret = load '$input' using PigStorage('\t') as (pos, src_spaceid, srcpvid, mtestid, url:chararray, dpos, ql_txt, parent_url:chararray, term, timestamp:long, clickcnt:float, slk);

ret = filter ret by mtestid MATCHES '$defmtestid';
/* 
ret = foreach ret generate srcpvid, REGEX_EXTRACT('(YSE00(4|5|6))',mtestid, 1) as bucid, url, ql_txt, parent_url, term, clickcnt, slk;
*/

ret = foreach ret generate srcpvid, '$defbucid' as bucid, url, ql_txt, parent_url, term, clickcnt, slk;

ret2 = filter ret by pyudf.IsSublink2(url, parent_url);

ret2 = foreach (group ret2 by srcpvid ) generate group as srcpvid, (SUM(ret2.clickcnt) > 0 ? 1 : 0 ) as condition, flatten(ret2.(url, ql_txt, parent_url, clickcnt, slk, bucid)) as (url, ql_txt, parent_url, clickcnt, slk, bucid);

ret3 = filter ret2 by slk == 'aa_link';


ret3 = foreach (group ret3 by (parent_url, url,ql_txt, bucid)) generate flatten(group) as (parent_url, url,ql_txt, bucid), COUNT(ret3) as nviews, SUM(ret3.clickcnt) as nclicks, SUM(ret3.condition) as nviews_cond;

ret3 = foreach (group ret3 by (parent_url, bucid) ) generate flatten(group) as (parent_url, bucid), SUM(ret3.nviews) as nviews_dom, SUM(ret3.nclicks) as nclicks_dom, flatten(ret3.(url, ql_txt, nviews, nclicks, nviews_cond)) as (url, ql_txt, nviews, nclicks, nviews_cond);

ret4 = foreach ret3 generate parent_url, url, ql_txt, bucid, nviews, nviews_cond, nclicks, nviews_dom, nclicks_dom,
            (float) nclicks / ( (float) nviews + $epsilon ) as ctr, (float) nclicks / ( (float) nviews_cond + $epsilon ) as ctr_cond;



ret4 = order ret4 by nviews_dom DESC, parent_url parallel $final_parallel; 

store ret4 into '$out1' using PigStorage('\t','-schema');
 

ret5 = order ret4 by nclicks_dom DESC, parent_url parallel $final_parallel;

store ret5 into '$out2' using PigStorage('\t','-schema');

