SET mapred.map.tasks.speculative.execution true;
SET mapred.reduce.tasks.speculative.execution true;
--SET mapred.job.queue.name curveball_small;

REGISTER /homes/haocheng/gemini/common/lib/jars/elephant-bird-*.jar;
REGISTER /home/gs/pig/current/lib/json-simple-1.1.jar;
REGISTER /homes/haocheng/gemini/common/lib/jars/insights_piggybank.jar;
%default cowgrid hdfs://PhazonBlue-nn1.blue.ygrid.yahoo.com:8020

%default VERTICAL rtl
%default VERTICAL_VERSION 20150818
%default COW_DATE 201509110000
%default root 'ss/match/adhoc/cow/data/'

DEFINE JsonLoader com.twitter.elephantbird.pig.load.JsonLoader('-nestedLoad=true -inputFormat org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat');
DEFINE AdvLookup com.yahoo.insights.grid.tuple.LookupString('$root/advertiser_sales/$VERTICAL_VERSION/$VERTICAL.csv', ',', '1', '1');

A1 = LOAD '$cowgrid/projects/cow_prod/complete_snapshot/$COW_DATE/campaign' USING JsonLoader AS (json:map[]);
A2 = FOREACH A1 GENERATE json#'domainObject'#'advertiserId' AS advertiser_id,
                         json#'domainObject'#'id' AS campaign_id,
                         json#'domainObject'#'sourceID' AS source_id;
A3 = FOREACH A2 GENERATE advertiser_id, campaign_id, source_id, 
                         AdvLookup((chararray)advertiser_id) AS advertiser_id_exist;
A4 = FILTER A3 BY (advertiser_id_exist IS NOT NULL) AND (advertiser_id_exist neq '');
--                  (is_search IS NOT NULL) AND (is_search eq 'true') AND
--                  (language eq 'en');
A5 = FOREACH A4 GENERATE advertiser_id, campaign_id, source_id;
A6 = DISTINCT A5 PARALLEL 1;

rmf $root/$VERTICAL/$COW_DATE/campaign
STORE A6 INTO '$root/$VERTICAL/$COW_DATE/campaign' USING PigStorage('\t','-schema');

