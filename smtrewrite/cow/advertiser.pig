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
DEFINE AdvLookup com.yahoo.insights.grid.tuple.LookupString('$root/advertiser_sales/$VERTICAL_VERSION/$VERTICAL.csv', ',', '0', '0');

A1 = LOAD '$cowgrid/projects/cow_prod/complete_snapshot/$COW_DATE/advertiser' USING JsonLoader AS (json:map[]);
A2 = FOREACH A1 GENERATE json#'domainObject'#'mdmId' AS mdm_id,
                         json#'domainObject'#'id' AS advertiser_id,
                         json#'domainObject'#'sourceID' AS source_id,
                         json#'domainObject'#'mdmCompanyCountryCode' AS mdm_country,
                         json#'domainObject'#'bookingCountry' AS book_country,
                         json#'domainObject'#'billingCountry' AS bill_country,
                         json#'domainObject'#'currency' AS currency;
A3 = FOREACH A2 GENERATE advertiser_id, mdm_id, source_id,
                         mdm_country, book_country, bill_country, currency,
                         AdvLookup((chararray)mdm_id) AS mdm_id_exist;
A4 = FILTER A3 BY (mdm_id_exist IS NOT NULL) AND (mdm_id_exist neq '') AND
                  (mdm_country eq 'US') AND (book_country eq 'US') AND (bill_country eq 'US');
-- A4 = FILTER A3 BY (adv_id_exist IS NOT NULL) AND (adv_id_exist neq '');
A5 = FOREACH A4 GENERATE mdm_id, advertiser_id, source_id,
                         mdm_country, book_country, bill_country, currency;
A6 = DISTINCT A5 PARALLEL 1;

A61 = LOAD 'hdfs://jetblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/advertiser-blacklist-binlu.txt' ; 


A61 = foreach A61 generate (chararray)$0 as advertiser_id:chararray ;

A6 = cogroup A61 by advertiser_id outer, A6 by advertiser_id outer ;

A6 = foreach (filter A6 by IsEmpty(A61)==true) {
        generate flatten(A6) as (mdm_id, advertiser_id, source_id,mdm_country, book_country, bill_country, currency) ;
}

rmf $root/$VERTICAL/$COW_DATE/advertiser/
STORE A6 INTO '$root/$VERTICAL/$COW_DATE/advertiser' USING PigStorage('\t','-schema');

