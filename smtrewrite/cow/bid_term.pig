SET mapred.map.tasks.speculative.execution true;
SET mapred.reduce.tasks.speculative.execution true;
--SET mapred.job.queue.name curveball_small;
SET mapred.min.split.size 2147483648; -- 2GB
SET pig.splitCombination true;
SET pig.maxCombinedSplitSize 2147483648; -- 2GB

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

A1 = LOAD '$cowgrid/projects/cow_prod/complete_snapshot/$COW_DATE/targetingAttribute' USING JsonLoader AS (json:map[]);
A2 = FILTER A1 BY (json#'domainObject'#'type' eq 'KEYWORD') AND (json#'domainObject'#'parentType' eq 'ADGROUP');
A3 = FOREACH A2 GENERATE json#'domainObject'#'advertiserId' AS advertiser_id,
                         json#'domainObject'#'id' AS bidded_term_id,
                         json#'domainObject'#'parentId' AS ad_group_id,
                         json#'domainObject'#'sourceID' AS bing_bidded_term_id,
                         json#'domainObject'#'matchType' AS match_type,
                         json#'domainObject'#'value' AS value,
                         json#'domainObject'#'phraseCanon' AS phrase_canon;
A4 = FOREACH A3 GENERATE advertiser_id, bidded_term_id, ad_group_id, bing_bidded_term_id, 
                         match_type, value, phrase_canon,
                         AdvLookup((chararray)advertiser_id) AS advertiser_id_exist;
A5 = FILTER A4 BY (advertiser_id_exist IS NOT NULL) AND (advertiser_id_exist neq '');
A6 = FOREACH A5 GENERATE advertiser_id, ad_group_id, bidded_term_id, bing_bidded_term_id,
                         match_type, value, phrase_canon;

A61 = LOAD '/user/ruiqiang/data/advertiser-blacklist.txt' using PigStorage('','-noschema') as (advertiser_id:chararray, aid:chararray, tmp:chararray) ;

A61 = foreach A61 generate advertiser_id ;

A6 = cogroup A61 by advertiser_id outer, A6 by advertiser_id outer ;

A6 = foreach (filter A6 by IsEmpty(A61)==true) {
        generate flatten(A6) as (advertiser_id, ad_group_id, bidded_term_id, bing_bidded_term_id,match_type, value, phrase_canon) ;
}



--
B1 = LOAD '$root/$VERTICAL/$COW_DATE/fullids' USING PigStorage('\t')
     AS (mdm_id, advertiser_id:chararray, bing_advertiser_id, campaign_id, bing_campaign_id, ad_group_id:chararray, bing_ad_group_id, bid);
-- join.
C1 = JOIN B1 BY (advertiser_id, ad_group_id), A6 BY (advertiser_id, ad_group_id) PARALLEL 500;
C2 = FOREACH C1 GENERATE B1::mdm_id AS mdm_id, B1::advertiser_id AS advertiser_id, B1::bing_advertiser_id AS bing_advertiser_id,
                         B1::campaign_id AS campaign_id, B1::bing_campaign_id AS bing_campaign_id,
                         B1::ad_group_id AS ad_group_id, B1::bing_ad_group_id AS bing_ad_group_id,
                         A6::bidded_term_id AS bidded_term_id, A6::bing_bidded_term_id AS bing_bidded_term_id,
                         A6::match_type AS match_type, A6::phrase_canon AS phrase_canon,
                         B1::bid AS bid;

C2 = foreach C2 generate ad_group_id as ad_group_id, phrase_canon as bidterm ;
C3 = DISTINCT C2 PARALLEL 80;

rmf $root/$VERTICAL/$COW_DATE/bid_term
STORE C3 INTO '$root/$VERTICAL/$COW_DATE/bid_term' USING PigStorage('\t', '-schema');

