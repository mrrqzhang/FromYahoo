REGISTER smt_udf.py USING jython AS pyudf;

%default qbertInput 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/smt-rewrite-for-bucket' ;
%default kunefeDATE0 '2015'
%default kunefeDATE1 '2015'
%default kunefeDATE2 '2015'
%default kunefeDATE3 '2015'
%default out '/projects/qrw/ruiqiang/Gemini/bucketFBCM25'
%default bucket 'CBT08'
%default device 'mobile'
-- check https://docs.google.com/document/d/1s_evoCTulZU3WEhmBfhf86NRXcXNUuSKV09EJ3-BbJI/edit to find new kunefedr
-- %default kunefedr 'hdfs://dilithiumred-nn1.red.ygrid.yahoo.com:8020'
%default kunefedr 'hdfs://phazonred-nn1.red.ygrid.yahoo.com:8020/projects/cb_nctr/clkb/nctr_data/unified_feed/'

qbert = load '$qbertInput' using PigStorage('\t','-noschema') ; 
qbert = foreach qbert generate (chararray)$0 as query:chararray, (chararray)$1 as rewrite:chararray ;



kunefe0 = load '$kunefedr/$kunefeDATE0/$device/*.gz' using PigStorage('\t','-schema') ;
kunefe1 = load '$kunefedr/$kunefeDATE1/$device/*.gz' using PigStorage('\t','-schema') ;
kunefe2 = load '$kunefedr/$kunefeDATE2/$device/*.gz' using PigStorage('\t','-schema') ;
kunefe3 = load '$kunefedr/$kunefeDATE3/$device/*.gz' using PigStorage('\t','-schema') ;

kunefe = union kunefe0,kunefe1,kunefe2,kunefe3 ;

kunefe = filter kunefe by bucket matches '.*$bucket.*' ;

kunefe = foreach kunefe generate
                        pvid as pvid:chararray,
                        rawQuery as rawQuery:chararray,
                        pagePos as pos:chararray,
--                        adSource as adSource:chararray,
                        pyudf.matchTypeConvert(matchType) as matchType:chararray,
                        adClicks as adClicks:int,
                        cbBiddedTermText as cbBiddedTermText:chararray ,
                        apBiddedTermText as apBiddedTermText:chararray ,
                        (cpcMl is null ? 0 : cpcMl) as rev:double,
			(bid is null ? 0 : bid) as bid:double,
                        title as title:chararray ,
                        displayUrl as displayUrl:chararray ;

imp_jqk = cogroup qbert by (query) INNER, kunefe by (rawQuery) INNER ;
imp_jqk = foreach imp_jqk generate flatten(kunefe) ;

imp_jqk = order imp_jqk by pvid, rawQuery, pos parallel 200 ;
rmf $out
store imp_jqk into '$out' using PigStorage('\t','-schema') ;

