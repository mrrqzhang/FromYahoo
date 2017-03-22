SET mapred.map.tasks.speculative.execution true;
SET mapred.reduce.tasks.speculative.execution true;
SET mapred.job.queue.name default;

SET mapred.min.split.size 2147483648; -- 2GB
SET pig.splitCombination true;
SET pig.maxCombinedSplitSize 2147483648; -- 2GB


REGISTER /homes/haocheng/gemini/common/lib/jars/elephant-bird-*.jar;
REGISTER /home/gs/pig/current/lib/json-simple-1.1.jar;
REGISTER /homes/haocheng/gemini/common/lib/jars/insights_piggybank.jar;


%default COW_DATE 201509220000
%default root 'ss/match/adhoc/cow/data/'

DEFINE JsonLoader com.twitter.elephantbird.pig.load.JsonLoader('-nestedLoad=true -inputFormat org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat');

A1 = LOAD 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/projects/cow_prod/complete_snapshot/$COW_DATE/advertiser' USING JsonLoader AS (json:map[]);
A2 = FOREACH A1 GENERATE json#'domainObject'#'mdmId' AS mdm_id,
                         json#'domainObject'#'id' AS advertiser_id,
                         json#'domainObject'#'sourceID' AS source_id,
                         json#'domainObject'#'mdmCompanyCountryCode' AS mdm_country,
                         json#'domainObject'#'bookingCountry' AS book_country,
                         json#'domainObject'#'billingCountry' AS bill_country,
                         json#'domainObject'#'currency' AS currency;
A4 = FILTER A2 BY (mdm_country eq 'US') AND (book_country eq 'US') AND (bill_country eq 'US') AND (currency eq 'USD');
-- A4 = FILTER A3 BY (adv_id_exist IS NOT NULL) AND (adv_id_exist neq '');
-- advertiser for US market
A5 = FOREACH A4 GENERATE advertiser_id;
A6 = DISTINCT A5 PARALLEL 200 ;


-- phrase canon.
A1 = LOAD 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/projects/cow_prod/complete_snapshot/$COW_DATE/targetingAttribute' USING JsonLoader AS (json:map[]);
A2 = FILTER A1 BY (json#'domainObject'#'type' eq 'KEYWORD') AND (json#'domainObject'#'parentType' eq 'ADGROUP');
A3 = FOREACH A2 GENERATE json#'domainObject'#'parentId' AS ad_group_id,
                         json#'domainObject'#'phraseCanon' AS phrase_canon;
A4 = FILTER A3 BY (phrase_canon IS NOT NULL) AND (phrase_canon neq '');
A5 = DISTINCT A4 PARALLEL 1000;


-- bid
B1 = LOAD 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/projects/cow_prod/complete_snapshot/$COW_DATE/adGroup' USING JsonLoader AS (json:map[]);
B2 = FOREACH B1 GENERATE json#'domainObject'#'id' AS ad_group_id,  json#'domainObject'#'advertiserId' AS advertiser_id ;

-- join. ad group id for US market
B23 = JOIN B2 by advertiser_id, A6 by advertiser_id parallel 2000 ;
B3 = foreach B23 generate B2::ad_group_id as ad_group_id  ;
B3 =  DISTINCT B3 PARALLEL 1000;

C1 = JOIN A5 BY (ad_group_id), B3 BY (ad_group_id) PARALLEL 1000;
C2 = FOREACH C1 GENERATE A5::ad_group_id AS ad_group_id, A5::phrase_canon AS phrase_canon;

rmf $root/$COW_DATE
STORE C2 INTO '$root/$COW_DATE' USING PigStorage('\t');

