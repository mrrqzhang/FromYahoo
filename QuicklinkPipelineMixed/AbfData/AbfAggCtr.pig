-- removed pageparam mtestid and qry_grp filtering and segmenting from venus_domainql_noptitle.pig
REGISTER /homes/jyj/Projects/quicklinks/jyson-1.0.2.jar;
REGISTER /homes/jyj/mylib/hdstreamlib.py USING jython AS pyudf;
REGISTER /homes/xingyi/fetl_sequence_projector/lib/jar/BaseFeed.jar;
REGISTER /homes/xingyi/fetl_sequence_projector/lib/jar/SequenceProjector.jar;
REGISTER /homes/jyj/Projects/quicklinks/jyjudfs.jar;


%default epsilon 0.000000001
%default root AllBuckets
%DEFAULT DATETIME '20141{0{2,3}*,10[1-9]}'
%default daterange '1020-1109'
%default defbucid 'all'
%default defmtestid '.*'
-- %default defmtestid '.*YST01_M.*YSE00(4|5|6).*'

--grid
SET default_parallel 1000;
%default final_parallel 100
-- %DEFAULT SPACEID '954006385'
%DECLARE input_abf  'hdfs://nitroblue-nn1.blue.ygrid.yahoo.com:8020/data/FETL/ABF/{$DATETIME}{*}/{*}/PAGE/Valid/part-r-*' 
/* */



/* --local 
SET default_parallel 1;
%default final_parallel 1;
%DECLARE input_abf  'abfdata.localtest'
*/

%DEFAULT out '$root/sessions-$defbucid-$daterange'
%DEFAULT out1 '$root/ctr-by-domviews-$defbucid-$daterange'
%DEFAULT out2 '$root/ctr-by-domclicks-$defbucid-$daterange'


result = LOAD '$input_abf' USING com.yahoo.ccdi.fetl.sequence.pig.Projector('srcpvid:chararray,event_type:chararray,device_info,clickinfo,viewinfo,src_spaceid:chararray,search_term:chararray,query_term:chararray,pageparams,timestamp:long,ydod:chararray');

--grid
result = FILTER result BY pageparams#'mtestid' matches '$defmtestid';
/* */


result = FILTER result BY ydod is null and ( srcpvid is not null and timestamp is not null );

allclicks = FILTER result BY event_type =='click' AND clickinfo#'sec' == 'sr' AND clickinfo#'targurl' is not null;


allclicks = FOREACH allclicks GENERATE src_spaceid, clickinfo#'targurl' AS url, clickinfo#'dpos' AS dpos, clickinfo#'pos' AS pos, clickinfo#'slk' as slk, clickinfo#'ql_txt' AS ql_txt, srcpvid, pageparams#'mtestid' as mtestid,  (search_term is null ? ( query_term is null ? '' : query_term) : search_term ) as term, 'unknown' as parent_url, timestamp;


/* -- same timestamp for all click events in the same srcpvid; 
-- clipped to save time; use QlSesssions.pig if you want all the session events
allclicks = foreach (group allclicks by srcpvid) generate flatten(allclicks.(src_spaceid, url, slk, dpos, pos, ql_txt, srcpvid, mtestid, term, parent_url)) as (src_spaceid, url, slk, dpos, pos, ql_txt, srcpvid, mtestid, term, parent_url), (long) ( SUM(allclicks.timestamp) / COUNT(allclicks.srcpvid) ) as timestamp;
*/


srclicks = FILTER allclicks BY slk == 'title' AND pos is not null;

clicks = FILTER allclicks BY slk == 'aa_link' AND dpos is not null;










views = FILTER result BY event_type == 'page' AND viewinfo is not null; -- AND (search_term is not null OR query_term is not null);

views = FOREACH views generate flatten(pyudf.viewinfo2srqls( com.yahoo.ccdi.fetl.sequence.pig.Tuple2Bag(viewinfo)) ) as (parent_url, url, dpos, ql_txt), ( search_term is null ? ( query_term is null ? '' : query_term) : search_term ) as term, srcpvid, pageparams#'mtestid' as mtestid, timestamp, src_spaceid;


views = FILTER views BY parent_url is not null AND srcpvid is not null; 

ret = foreach (cogroup views by (src_spaceid,srcpvid,mtestid,url,dpos, ql_txt), clicks by (src_spaceid, srcpvid, mtestid, url, dpos, ql_txt)) generate '1' as pos, flatten(group) as (src_spaceid, srcpvid, mtestid, url, dpos, ql_txt), flatten( ( IsEmpty(views.srcpvid) ? clicks.(parent_url,term,timestamp) : views.(parent_url,term,timestamp)) ) as (parent_url,term,timestamp), COUNT(clicks.srcpvid) as clickcnt, 'aa_link' as slk;




views2 = foreach (group views by (src_spaceid, srcpvid,parent_url, term, timestamp) )  generate flatten( group )  as (src_spaceid, srcpvid, parent_url, term, timestamp);

srclicks = foreach ( group srclicks by (pos, src_spaceid, srcpvid, mtestid, url, dpos, ql_txt, parent_url, term, timestamp) ) generate flatten(group) as (pos,src_spaceid, srcpvid, mtestid, url, dpos, ql_txt, parent_url, term, timestamp), COUNT(srclicks) as clickcnt;

srclicks = foreach (cogroup views2 by srcpvid, srclicks by srcpvid) generate flatten(srclicks.(pos, src_spaceid, srcpvid, mtestid, url, dpos, ql_txt)) as (pos, src_spaceid, srcpvid, mtestid, url, dpos, ql_txt), flatten(views2.(parent_url, term, timestamp) ) as (parent_url, term, timestamp );


ret2 = foreach ( group srclicks by (pos, src_spaceid, srcpvid, mtestid, url, dpos, ql_txt, parent_url, term, timestamp) ) generate flatten(group) as (pos, src_spaceid, srcpvid, mtestid, url, dpos, ql_txt, parent_url, term, timestamp), COUNT(srclicks.url) as clickcnt, 'title' as slk;

ret3 = union ret, ret2;


/* -- use QlSesssions.pig if you want all the session events
ret3 = order ret3 by timestamp, src_spaceid, srcpvid, parent_url, term, pos, dpos, slk, mtestid parallel $final_parallel;
STORE ret3 INTO '$out' USING PigStorage('\t','-schema');
*/


 


res = foreach ret3 generate srcpvid, '$defbucid' as bucid, url, ql_txt, parent_url, term, clickcnt, slk;

res2 = filter res by pyudf.IsSublink2(url, parent_url, slk);

res2 = foreach (group res2 by srcpvid ) generate group as srcpvid, (SUM(res2.clickcnt) > 0 ? 1 : 0 ) as condition, flatten(res2.(url, ql_txt, parent_url, clickcnt, slk, bucid)) as (url, ql_txt, parent_url, clickcnt, slk, bucid);

res3 = filter res2 by slk == 'aa_link';


res3 = foreach (group res3 by (parent_url, url,ql_txt, bucid)) generate flatten(group) as (parent_url, url,ql_txt, bucid), COUNT(res3) as nviews, SUM(res3.clickcnt) as nclicks, SUM(res3.condition) as nviews_cond;


-- different ql_txt for the same url gets recorded individually
res3 = foreach (group res3 by (parent_url, bucid) ) generate flatten(group) as (parent_url, bucid), SUM(res3.nviews) as nviews_dom, SUM(res3.nclicks) as nclicks_dom, flatten(res3.(url, ql_txt, nviews, nclicks, nviews_cond)) as (url, ql_txt, nviews, nclicks, nviews_cond);

res4 = foreach res3 generate parent_url, url, ql_txt, bucid, nviews, nviews_cond, nclicks, nviews_dom, nclicks_dom,
            (float) nclicks / ( (float) nviews + $epsilon ) as ctr, (float) nclicks / ( (float) nviews_cond + $epsilon ) as ctr_cond;


/*
res4 = order res4 by nviews_dom DESC, parent_url, ctr DESC, url parallel $final_parallel; 

store res4 into '$out1' using PigStorage('\t','-schema');
*/

res5 = order res4 by nclicks_dom DESC, parent_url, ctr DESC, url parallel $final_parallel;

store res5 into '$out2' using PigStorage('\t','-schema');


