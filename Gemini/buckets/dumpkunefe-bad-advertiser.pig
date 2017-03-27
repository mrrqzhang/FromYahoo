REGISTER smt_udf.py USING jython AS pyudf;

%default qbertInput 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/smt-rewrite-for-bucket' ;
%default out '/projects/qrw/ruiqiang/bad-advertiser-selected'
%default bucket '*' --'FBCM14'
%default device 'mobile'
%default kunefedr 'hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020'





kunefe = load '$kunefedr/projects/cb_nctr/dev/nctr_data/unified_feed/2015101[789]/mobile/*.gz' using PigStorage('\t','-schema') ;


kunefe = foreach kunefe generate
                        pvid as pvid:chararray,
                        rawQuery as rawQuery:chararray,
                        pagePos as pos:chararray,
--                        adSource as adSource:chararray,
                        pyudf.matchTypeConvert(matchType) as matchType:chararray,
                        adClicks as adClicks:int,
                        cbBiddedTermText as cbBiddedTermText:chararray ,
                        apBiddedTermText as apBiddedTermText:chararray ,
                        (cpcMl is null ? 0 : cpcMl) as ppc:double ,
                        title as title:chararray ,
                        displayUrl as displayUrl:chararray,
			REGEX_EXTRACT(title, '.*-%20(.*com)',1)  as badadver:chararray ;
 ;

A = load 'selected-advertisers.txt' using PigStorage('\t','-noschema') as adv:chararray ;

kunefe = cogroup kunefe by badadver INNER, A by adv INNER parallel 200 ;

kunefe = foreach kunefe generate flatten(kunefe) ;

kunefe = foreach kunefe generate badadver as adver:chararray, rawQuery as rawQuery:chararray,  
			cbBiddedTermText as cbBiddedTermText:chararray, adClicks as adClicks:int, ppc as ppc:double, adClicks*ppc as rev:double ;

kunefe = group kunefe by (adver, rawQuery,  cbBiddedTermText) ;

kunefe = foreach kunefe generate flatten(group) as (adver:chararray,rawQuery:chararray,cbBiddedTermText:chararray), 
                                 MAX(kunefe.ppc) as ppc, SUM(kunefe.adClicks) as clicks, SUM(kunefe.rev) as rev ;

kunefe = filter kunefe by clicks != 0 and rev!=0 ;

kunefe = order kunefe by adver, rev DESC, rawQuery,cbBiddedTermText ;

rmf $out
store kunefe into '$out' using PigStorage('\t','-schema') ;

