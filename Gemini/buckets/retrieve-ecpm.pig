REGISTER smt_udf.py USING jython AS pyudf;

%default qbertInput 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/smt-rewrite-for-bucket' ;
%default kunefeDATE '20150808'
%default out '/projects/qrw/ruiqiang/Gemini/bucketFBCM25'
%default bucket 'CBT08'
%default device 'mobile'
%default kunefedr 'hdfs://phazonred-nn1.red.ygrid.yahoo.com:8020/projects/cb_nctr/clkb/nctr_data/unified_feed/' 




kunefe = load '$kunefedr//$kunefeDATE/$device/*.gz' using PigStorage('\t','-schema') ;

kunefe = filter kunefe by pyudf.matchTypeConvert(matchType) matches '.*QBERT.*' ;

kunefe = foreach kunefe generate cbBiddedTermText as bidterm:chararray ,  (float)clkb*(float)bid*1000 as ecpm:float ; 

kunefe = foreach (group kunefe by bidterm) generate flatten(group) as  bidterm:chararray, SUM(kunefe.ecpm)/COUNT(kunefe) as ecpm:float, COUNT(kunefe) as btcnt:long ;


rmf $out
store kunefe into '$out' using PigStorage('\t','-schema') ;

