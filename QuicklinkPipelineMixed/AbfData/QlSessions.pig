-- 猪脚本
-- removed pageparam mtestid and qry_grp filtering and segmenting from venus_domainql_noptitle.pig
REGISTER /homes/jyj/mylib/hdstreamlib.py USING jython AS pyudf;

REGISTER /homes/xingyi/fetl_sequence_projector/lib/jar/BaseFeed.jar;
REGISTER /homes/xingyi/fetl_sequence_projector/lib/jar/SequenceProjector.jar;
REGISTER /homes/jyj/Projects/quicklinks/jyjudfs.jar;

%DEFAULT DATETIME '20141{0{2,3}*,10[1-9]}'

%default root AllBuckets

%default date '1020-1109'

--grid
SET default_parallel 1000;
%default final_parallel 100;
%DEFAULT SPACEID '954006385'

%DECLARE input_abf  'hdfs://nitroblue-nn1.blue.ygrid.yahoo.com:8020/data/FETL/ABF/{$DATETIME}{*}/{*}/PAGE/Valid/part-r-*' 
%DEFAULT OUT '$root/YSE00456-$date'

/* */

/* --local 
SET default_parallel 1;
%default final_parallel 1;
%DECLARE input_abf  '../../part-r-00018'
%DEFAULT OUT '$root/YSE00456'
*/


result = LOAD '$input_abf' USING com.yahoo.ccdi.fetl.sequence.pig.Projector('srcpvid:chararray,event_type:chararray,device_info,clickinfo,viewinfo,src_spaceid:chararray,search_term:chararray,query_term:chararray,pageparams,timestamp:long,ydod:chararray');

--grid
result = FILTER result BY pageparams#'mtestid' matches '.*YST01_M.*YSE00(4|5|6).*';
/* */


result = FILTER result BY ydod is null and ( srcpvid is not null and timestamp is not null );

allclicks = FILTER result BY event_type =='click' AND clickinfo#'sec' == 'sr' AND clickinfo#'targurl' is not null;


allclicks = FOREACH allclicks GENERATE src_spaceid, clickinfo#'targurl' AS url, clickinfo#'dpos' AS dpos, clickinfo#'pos' AS pos, clickinfo#'slk' as slk, clickinfo#'ql_txt' AS ql_txt, srcpvid, pageparams#'mtestid' as mtestid,  (search_term is null ? ( query_term is null ? '' : query_term) : search_term ) as term, timestamp, 'unknown' as parent_url;


-- same timestamp for all click events in the same srcpvid

allclicks = foreach (group allclicks by srcpvid) generate flatten(allclicks.(src_spaceid, url, slk, dpos, pos, ql_txt, srcpvid, mtestid, term, parent_url)) as (src_spaceid, url, slk, dpos, pos, ql_txt, srcpvid, mtestid, term, parent_url), (long) ( SUM(allclicks.timestamp) / COUNT(allclicks.srcpvid) ) as timestamp;



srclicks = FILTER allclicks BY slk == 'title' AND pos is not null;

clicks = FILTER allclicks BY slk == 'aa_link' AND dpos is not null;


views = FILTER result BY event_type == 'page' AND viewinfo is not null; -- AND (search_term is not null OR query_term is not null);

views = FOREACH views generate flatten(pyudf.viewinfo2srqls( com.yahoo.ccdi.fetl.sequence.pig.Tuple2Bag(viewinfo)) ) as (parent_url, url, dpos, ql_txt), ( search_term is null ? ( query_term is null ? '' : query_term) : search_term ) as term, srcpvid, pageparams#'mtestid' as mtestid, timestamp, src_spaceid;


views = FILTER views BY parent_url is not null AND srcpvid is not null; 

ret = foreach (cogroup views by (src_spaceid,srcpvid,mtestid,url,dpos, ql_txt), clicks by (src_spaceid, srcpvid, mtestid, url, dpos, ql_txt)) generate '1' as pos, flatten(group) as (src_spaceid, srcpvid, mtestid, url, dpos, ql_txt), flatten( ( IsEmpty(views.srcpvid) ? clicks.(parent_url,term,timestamp) : views.(parent_url,term,timestamp)) ) as (parent_url,term,timestamp), COUNT(clicks.srcpvid) as clickcnt, 'aa_link' as slk;

views2 = foreach (group views by (src_spaceid, srcpvid,parent_url, term, timestamp) )  generate flatten( group )  as (src_spaceid, srcpvid, parent_url, term, timestamp);


srclicks = foreach ( group srclicks by (pos, src_spaceid, srcpvid, mtestid, url, dpos, ql_txt, parent_url, term, timestamp) ) generate flatten(group) as (pos,src_spaceid, srcpvid, mtestid, url, dpos, ql_txt, parent_url, term, timestamp), COUNT(srclicks) as clickcnt;

srclicks = foreach (cogroup views2 by srcpvid, srclicks by srcpvid) generate flatten(srclicks.(pos, src_spaceid, srcpvid, mtestid, url, dpos, ql_txt)) as (pos, src_spaceid, srcpvid, mtestid, url, dpos, ql_txt), flatten(views2.(parent_url, term, timestamp) ) as (parent_url, term, timestamp );

ret2 = foreach ( group srclicks by (pos, src_spaceid, srcpvid, mtestid, url, dpos, ql_txt, parent_url, term, timestamp) ) generate flatten(group) as (pos, src_spaceid, srcpvid, mtestid, url, dpos, ql_txt, parent_url, term, timestamp), COUNT(srclicks) as clickcnt, 'title' as slk;


ret3 = union ret, ret2;

ret3 = order ret3 by timestamp, src_spaceid, srcpvid, parent_url, term, pos, dpos, slk, mtestid parallel $final_parallel;

STORE ret3 INTO '$OUT' USING PigStorage('\t','-schema');

