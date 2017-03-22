REGISTER smt_udf.py USING jython AS pyudf;

%default MaxBidterm 10000000
%default kunefeDATE '20150808'
%default out '/projects/qrw/ruiqiang/Gemini/bucketFBCM25'
%default bucket 'CBT08'
%default device 'mobile'
-- check https://docs.google.com/document/d/1s_evoCTulZU3WEhmBfhf86NRXcXNUuSKV09EJ3-BbJI/edit to find new kunefedr
-- %default kunefedr 'hdfs://dilithiumred-nn1.red.ygrid.yahoo.com:8020'
%default kunefedr 'hdfs://phazonblue-nn1.blue.ygrid.yahoo.com:8020/'

kunefe = load '$kunefedr/projects/cb_nctr/clkb/nctr_data/unified_feed/$kunefeDATE/$device/*.gz' using PigStorage('\t','-schema') ;

kunefe = filter kunefe by bucket matches '.*$bucket.*' ;

kunefe = foreach kunefe generate
                        pyudf.matchTypeConvert(matchType) as matchType:chararray,
                        adClicks as adClicks:int,
                        cbBiddedTermText as cbBiddedTermText:chararray ,
                        apBiddedTermText as apBiddedTermText:chararray ,
                        (cpcMl is null ? 0 : cpcMl) as rev:double;
bidterm = filter kunefe by LOWER(matchType) matches '.*broad.*' or LOWER(matchType) matches '.*qbert.*' ;
cb_bidterm = foreach bidterm generate cbBiddedTermText ;
bing_bidterm = foreach bidterm generate apBiddedTermText ;

combined = union cb_bidterm, bing_bidterm  ;

combined = foreach (group combined by $0)  generate group as bt:chararray, COUNT(combined) as count:long ;


combined = foreach (group combined ALL ) {
	   tmp = TOP($MaxBidterm,1,combined) ;
	   generate flatten(tmp) as (bt:chararray, count:long) ;
}

combined = order combined by count DESC ; 

rmf $out ;

store combined into '$out' using PigStorage('\t','-schema') ;

