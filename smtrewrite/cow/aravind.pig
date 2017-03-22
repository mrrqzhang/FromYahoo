SET mapred.map.tasks.speculative.execution true;
SET mapred.reduce.tasks.speculative.execution true;
SET mapred.job.queue.name default;

SET mapred.min.split.size 2147483648; -- 2GB
SET pig.splitCombination true;
SET pig.maxCombinedSplitSize 2147483648; -- 2GB


REGISTER /homes/haocheng/gemini/common/lib/jars/elephant-bird-*.jar;
REGISTER /home/gs/pig/current/lib/json-simple-1.1.jar;
REGISTER /homes/haocheng/gemini/common/lib/jars/insights_piggybank.jar;


%default COW_DATE 201509110000
%default root 'ss/match/adhoc/cow/data/'

DEFINE JsonLoader com.twitter.elephantbird.pig.load.JsonLoader('-nestedLoad=true -inputFormat org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat');

A1 = LOAD 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/projects/cow_prod/complete_snapshot/$COW_DATE/advertiser' USING JsonLoader AS (json:map[]);
A2 = FOREACH A1 GENERATE json#'domainObject'#'mdmId' AS mdm_id,
                         json#'domainObject'#'id' AS advertiser_id,
                         json#'domainObject'#'sourceID' AS source_id,
                         json#'domainObject'#'mdmCompanyCountryCode' AS mdm_country,
                         json#'domainObject'#'bookingCountry' AS book_country,
                         json#'domainObject'#'billingCountry' AS bill_country,
			 json#'domainObject'#'status' AS status,
                         json#'domainObject'#'currency' AS currency;

A4 = FILTER A2 BY (mdm_country eq 'US') AND (book_country eq 'US') AND (bill_country eq 'US') AND (currency eq 'USD')  AND (status eq 'ON');

-- A4 = FILTER A3 BY (adv_id_exist IS NOT NULL) AND (adv_id_exist neq '');
A5 = FOREACH A4 GENERATE advertiser_id;
A6 = DISTINCT A5 PARALLEL 200 ;




-- phrase canon.
A1 = LOAD 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/projects/cow_prod/complete_snapshot/$COW_DATE/targetingAttribute' USING JsonLoader AS (json:map[]);
A2 = FILTER A1 BY (json#'domainObject'#'type' eq 'KEYWORD') AND (json#'domainObject'#'parentType' eq 'ADGROUP');
A3 = FOREACH A2 GENERATE json#'domainObject'#'parentId' AS ad_group_id,
                         json#'domainObject'#'matchType' AS match_type,
                         json#'domainObject'#'phraseCanon' AS phrase_canon;
A4 = FILTER A3 BY (phrase_canon IS NOT NULL) AND (phrase_canon neq '') AND (match_type eq 'BROAD') ;
A5 = DISTINCT A4 PARALLEL 1000;
-- bid
B1 = LOAD 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/projects/cow_prod/complete_snapshot/$COW_DATE/adGroup' USING JsonLoader AS (json:map[]);
B2 = FOREACH B1 GENERATE json#'domainObject'#'id' AS ad_group_id,  json#'domainObject'#'advertiserId' AS advertiser_id,
                         json#'domainObject'#'bidSet'#'bids' AS bids:bag{t:Tuple(m:map[])};
B3 = FOREACH B2 {
       S1 = FOREACH bids GENERATE m#'priceType' AS price_type, m#'distributionNetwork' AS network, m#'status' AS status, m#'value' AS value;
       S2 = FILTER S1 BY (network eq 'Y_SEARCH') AND (price_type eq 'CPC') AND (status eq 'ON');
       S3 = FOREACH S2 GENERATE value AS bid;
       S4 = ORDER S3 BY bid DESC;
       S5 = LIMIT S4 1;
       GENERATE ad_group_id, advertiser_id, FLATTEN(S5) AS (bid);
     };


-- join not blacklist advertiser
D3 = JOIN B3 by advertiser_id, A6 by advertiser_id parallel 2000 ;
D3 = foreach D3 generate B3::ad_group_id as ad_group_id, B3::bid as bid, B3::advertiser_id as advertiser_id ;


C1 = JOIN A5 BY (ad_group_id), D3 BY (ad_group_id) PARALLEL 1000;
C2 = FOREACH C1 GENERATE A5::phrase_canon AS phrase_canon, D3::bid AS bid, A5::match_type as match_type, D3::advertiser_id as advertiser_id;

rmf $root/normal-advertiser
STORE C2 INTO '$root/normal-advertiser' USING PigStorage('\t');














