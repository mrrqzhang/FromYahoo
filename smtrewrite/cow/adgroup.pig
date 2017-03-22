SET mapred.map.tasks.speculative.execution true;
SET mapred.reduce.tasks.speculative.execution true;
--SET mapred.job.queue.name curveball_small;
SET mapred.min.split.size 1073741824; -- 1GB
SET pig.splitCombination true;
SET pig.maxCombinedSplitSize 1073741824;

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

A1 = LOAD '$cowgrid/projects/cow_prod/complete_snapshot/$COW_DATE/adGroup' USING JsonLoader AS (json:map[]);
A2 = FOREACH A1 GENERATE json#'domainObject'#'advertiserId' AS advertiser_id,
                         json#'domainObject'#'campaignId' AS campaign_id,
                         json#'domainObject'#'id' AS ad_group_id,
                         json#'domainObject'#'sourceID' AS source_id,
                         json#'domainObject'#'bidSet'#'bids' AS bids:bag{t:Tuple(m:map[])};
A3 = FOREACH A2 GENERATE advertiser_id, campaign_id, ad_group_id, source_id,
                         AdvLookup((chararray)advertiser_id) AS adv_id_exist,
                         bids;
A4 = FILTER A3 BY (adv_id_exist IS NOT NULL) AND (adv_id_exist neq '');
A5 = FOREACH A4 {
       B1 = FOREACH bids GENERATE m#'priceType' AS price_type, m#'distributionNetwork' AS network, m#'status' AS status, m#'value' AS value;
       B2 = FILTER B1 BY (network eq 'Y_SEARCH') AND (price_type eq 'CPC') AND (status eq 'ON');
       B3 = FOREACH B2 GENERATE value AS bid;
       B4 = ORDER B3 BY bid DESC;
       B5 = LIMIT B4 1;
       GENERATE advertiser_id, campaign_id, ad_group_id, source_id, FLATTEN(B5) AS (bid);
     };
A6 = FOREACH A5 GENERATE advertiser_id, campaign_id, ad_group_id, source_id, bid;
A7 = DISTINCT A6 PARALLEL 1;

rmf $root/$VERTICAL/$COW_DATE/ad_group
STORE A7 INTO '$root/$VERTICAL/$COW_DATE/ad_group' USING PigStorage('\t');

