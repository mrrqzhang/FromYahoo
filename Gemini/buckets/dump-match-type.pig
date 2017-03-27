REGISTER smt_udf.py USING jython AS pyudf;

%default kunefeDATE '20150808'
%default out '/projects/qrw/ruiqiang/Gemini/bucketFBCM25'
%default bucket 'CBT08'
%default device 'mobile'
%default kunefedr 'hdfs://phazonred-nn1.red.ygrid.yahoo.com:8020/projects/cb_nctr/clkb/nctr_data/unified_feed/' 





kunefe = load '$kunefedr//$kunefeDATE/$device/*.gz' using PigStorage('\t','-schema') ;

kunefe = filter kunefe by bucket matches '.*$bucket.*' ;

kunefe = foreach kunefe generate
                        pvid as pvid:chararray,
                        rawQuery as rawQuery:chararray,
                        pagePos as pos:chararray,
--                        adSource as adSource:chararray,
                        pyudf.matchTypeConvert(matchType) as matchType:chararray,
                        adClicks as adClicks:int,
			cbAdvertiserId as  cbAdvertiserId:chararray,
			cbAdgroupId as cbAdgroupId:chararray ,
                        cbBiddedTermText as cbBiddedTermText:chararray ,
                        apBiddedTermText as apBiddedTermText:chararray ,
                        (cpcMl is null ? 0 : cpcMl) as rev:double,
                        title as title:chararray ,
                        displayUrl as displayUrl:chararray,
			phraseCanonQuery as phraseCanonQuery:chararray ;

rmf $out ;
store kunefe into '$out' using PigStorage('\t','-schema') ;

