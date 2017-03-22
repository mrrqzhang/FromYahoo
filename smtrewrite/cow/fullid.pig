SET mapred.map.tasks.speculative.execution true;
SET mapred.reduce.tasks.speculative.execution true;
--SET mapred.job.queue.name curveball_small;

%default root 'ss/match/adhoc/cow/data/'
%default VERTICAL rtl
%default VERTICAL_VERSION 20150818
%default COW_DATE 201509110000

A1 = LOAD '$root/$VERTICAL/$COW_DATE/advertiser' USING PigStorage('\t')
     AS (mdm_id, advertiser_id, source_id, mdm_country, book_country, bill_country, currency);
A2 = FOREACH A1 GENERATE mdm_id, advertiser_id, source_id AS bing_advertiser_id;
--
B1 = LOAD '$root/$VERTICAL/$COW_DATE/campaign' USING PigStorage('\t')
     AS (advertiser_id, campaign_id, source_id);
B2 = FOREACH B1 GENERATE advertiser_id, campaign_id, source_id AS bing_campaign_id;
--
C1 = LOAD '$root/$VERTICAL/$COW_DATE/ad_group' USING PigStorage('\t')
     AS (advertiser_id, campaign_id, ad_group_id, source_id, bid);
C2 = FOREACH C1 GENERATE advertiser_id, campaign_id, ad_group_id, source_id AS bing_ad_group_id, bid;
-- 
D1 = JOIN A2 BY advertiser_id, C2 BY advertiser_id PARALLEL 4;
D2 = FOREACH D1 GENERATE A2::mdm_id AS mdm_id,
                         A2::advertiser_id AS advertiser_id,
                         A2::bing_advertiser_id AS bing_advertiser_id,
                         C2::campaign_id AS campaign_id,
                         C2::ad_group_id AS ad_group_id,
                         C2::bing_ad_group_id AS bing_ad_group_id,
                         C2::bid AS bid;
D3 = JOIN B2 BY campaign_id, D2 BY campaign_id PARALLEL 4;
D4 = FOREACH D3 GENERATE D2::mdm_id AS mdm_id, D2::advertiser_id AS advertiser_id, D2::bing_advertiser_id AS bing_advertiser_id,
                         B2::campaign_id AS campaign_id, B2::bing_campaign_id AS bing_campaign_id,
                         D2::ad_group_id AS ad_group_id, D2::bing_ad_group_id AS bing_ad_group_id,
                         D2::bid AS bid;
D5 = DISTINCT D4 PARALLEL 4;

rmf $root/$VERTICAL/$COW_DATE/fullids
STORE D5 INTO '$root/$VERTICAL/$COW_DATE/fullids' USING PigStorage('\t','-schema');

