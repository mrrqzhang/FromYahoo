SET mapred.map.tasks.speculative.execution true;
SET mapred.reduce.tasks.speculative.execution true;
SET mapred.job.queue.name default;

SET mapred.min.split.size 2147483648; -- 2GB
SET pig.splitCombination true;
SET pig.maxCombinedSplitSize 2147483648; -- 2GB


REGISTER /homes/haocheng/gemini/common/lib/jars/elephant-bird-*.jar;
REGISTER /home/gs/pig/current/lib/json-simple-1.1.jar;
REGISTER /homes/haocheng/gemini/common/lib/jars/insights_piggybank.jar;

%default COW_GRID 'hdfs://phazonred-nn1.red.ygrid.yahoo.com:8020/'
%default COW_DATE 201509110000
%default root 'ss/match/adhoc/cow/data/'

DEFINE JsonLoader com.twitter.elephantbird.pig.load.JsonLoader('-nestedLoad=true -inputFormat org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat');

A1 = LOAD '$COW_GRID/projects/cow_prod/complete_snapshot/$COW_DATE/advertiser' USING JsonLoader AS (json:map[]);
A2 = FOREACH A1 GENERATE json#'domainObject'#'mdmId' AS mdm_id,
                         json#'domainObject'#'id' AS advertiser_id,
                         json#'domainObject'#'sourceID' AS source_id,
                         json#'domainObject'#'mdmCompanyCountryCode' AS mdm_country,
                         json#'domainObject'#'bookingCountry' AS book_country,
                         json#'domainObject'#'billingCountry' AS bill_country,
			 json#'domainObject'#'status' AS status,
                         json#'domainObject'#'currency' AS currency;

A4 = FILTER A2 BY (mdm_country eq 'US') AND (book_country eq 'US') AND (bill_country eq 'US') AND (currency eq 'USD')  AND (status eq 'ON');
A4 = FILTER A4 by (mdm_id != '176650') AND (mdm_id != '22877') AND (mdm_id != '34348') AND (mdm_id != '41987') AND (mdm_id != '4672') AND (mdm_id != '626364')  ;

-- A4 = FILTER A3 BY (adv_id_exist IS NOT NULL) AND (adv_id_exist neq '');
A5 = FOREACH A4 GENERATE advertiser_id;
A6 = DISTINCT A5 PARALLEL 200 ;

A61 = LOAD 'hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/advertiser-blacklist-binlu.txt' using PigStorage('\t','-noschema') as (advertiser_id:chararray) ;


A62 = cogroup A61 by advertiser_id outer, A6 by advertiser_id outer ;

A62 = foreach (filter A62 by IsEmpty(A61)==true) {
	generate flatten(A6) as advertiser_id:chararray ;
}



-- phrase canon.
A1 = LOAD '$COW_GRID/projects/cow_prod/complete_snapshot/$COW_DATE/targetingAttribute' USING JsonLoader AS (json:map[]);
A2 = FILTER A1 BY (json#'domainObject'#'type' eq 'KEYWORD') AND (json#'domainObject'#'parentType' eq 'ADGROUP');
A3 = FOREACH A2 GENERATE json#'domainObject'#'parentId' AS ad_group_id,
                         json#'domainObject'#'matchType' AS match_type,
                         json#'domainObject'#'phraseCanon' AS phrase_canon;
A4 = FILTER A3 BY (phrase_canon IS NOT NULL) AND (phrase_canon neq '') AND (match_type eq 'BROAD') ;
A5 = DISTINCT A4 PARALLEL 1000;
-- bid
B1 = LOAD '$COW_GRID/projects/cow_prod/complete_snapshot/$COW_DATE/adGroup' USING JsonLoader AS (json:map[]);
B2 = FOREACH B1 GENERATE json#'domainObject'#'id' AS ad_group_id,  json#'domainObject'#'advertiserId' AS advertiser_id,
                         json#'domainObject'#'bidSet'#'bids' AS bids:bag{t:Tuple(m:map[])};

B2 = FOREACH B2 {
       S1 = FOREACH bids GENERATE m#'priceType' AS price_type, m#'distributionNetwork' AS network, m#'status' AS status, (double)m#'value' AS value:double;
       S2 = FILTER S1 BY (network eq 'Y_SEARCH') AND (price_type eq 'CPC') AND (status eq 'ON');
       S3 = FOREACH S2 GENERATE (double)value AS bid:double;
       GENERATE ad_group_id, advertiser_id, flatten(S3)  as bid:double ;
     };


B3 = foreach (group B2 by (ad_group_id, advertiser_id)) generate flatten(group) as (ad_group_id, advertiser_id), SUM(B2.bid)/COUNT(B2) as bid:double ;


-- join not blacklist advertiser
D3 = JOIN B3 by advertiser_id, A62 by advertiser_id parallel 2000 ;
D3 = foreach D3 generate B3::advertiser_id as advertiser_id,B3::ad_group_id as ad_group_id, B3::bid as bid ;


C1 = JOIN A5 BY (ad_group_id), D3 BY (ad_group_id) PARALLEL 1000;
C2 = FOREACH C1 GENERATE A5::phrase_canon AS phrase_canon, D3::bid AS bid, D3::advertiser_id as advertiser_id, D3::ad_group_id as ad_group_id ;
C3 = GROUP C2 BY (phrase_canon,advertiser_id) PARALLEL 400;
C4 = foreach C3 {
  -- output bidterm, advertiser, top 3 ad_group
     S1 = foreach C2 generate ad_group_id,bid ;
     S2 = TOP(3,1,S1) ;
     generate flatten(group) as (phrase_canon,advertiser_id), flatten(S2) as (ad_group_id,bid) ;
}



rmf $root/normal-advertiser
STORE C4 INTO '$root/normal-advertiser' USING PigStorage('\t');





-- join blacklist advertiser


D3 = JOIN B3 by advertiser_id, A61 by advertiser_id parallel 2000 ;
D3 = foreach D3 generate B3::ad_group_id as ad_group_id, B3::bid as bid ;


C1 = JOIN A5 BY (ad_group_id), D3 BY (ad_group_id) PARALLEL 1000;
C2 = FOREACH C1 GENERATE A5::phrase_canon AS phrase_canon, D3::bid AS bid, A5::match_type as match_type;
C3 = GROUP C2 BY (phrase_canon,match_type) PARALLEL 400;
C4 = FOREACH C3 {
       S1 = FOREACH C2 GENERATE bid;
       S2 = ORDER S1 BY bid DESC;
       S3 = LIMIT S2 1;
       GENERATE FLATTEN(group) AS (phrase_canon,match_type), FLATTEN(S3) AS (bid);
     };

rmf $root/blacklist-advertiser
STORE C4 INTO '$root/blacklist-advertiser' USING PigStorage('\t');











