%default qbertInput 'hdfs://dilithiumred-nn1.red.ygrid.yahoo.com:8020/tmp/binlu/scoring_travel_rewrite_part2/rewrite.score/' ;
%default kunefeDATE '20150[5]30'
%default out 'evaluation'
%default smallkunefe 'smallkunefe'



qbert = load '$qbertInput' using PigStorage('\t','-noschema') ; 

-- for qbert format: 
qbert = foreach qbert generate $0 , ( $1 ==' '  ? $2 : $1 ), ( $1 ==' '  ? ( $3 is null ? 0 : $3 ) : ( $2 is null ? 0 : $2 ) ) ; 

-- meaningless for number relscore. used for rubert type
qbert = foreach qbert generate (chararray)$0 as query:chararray, (chararray)$1 as rewrite:chararray, ( $2 is null ? (chararray) 0 : (chararray)$2 ) as relscore:chararray ;



kunefe = load '$smallkunefe' using PigStorage('\t','-schema') ;


imp_jqk = cogroup kunefe by (rawQuery,cbBiddedTermText) outer , qbert by (query,rewrite) outer  ;

imp_jqk_smt = filter imp_jqk by IsEmpty(qbert)==false and IsEmpty(kunefe)==false ;

imp_jqk_nonsmt = filter imp_jqk by IsEmpty(qbert)==true and IsEmpty(kunefe)==false ;


imp_jqk_smt = foreach imp_jqk_smt generate flatten(kunefe.(pvid,pos,matchType,adClicks,rev, title, displayUrl)) as (pvid:chararray,pos:chararray,matchType:chararray,adClicks:int,rev:double, title, displayUrl), flatten(group) as (query:chararray, rewrite:chararray) ;

imp_jqk_smt = group imp_jqk_smt by (pvid,pos,matchType,adClicks,rev,title, displayUrl, query, rewrite) parallel 100 ;
imp_jqk_smt = foreach imp_jqk_smt generate flatten(group) as (pvid:chararray,pos:chararray,matchType:chararray,adClicks:int,rev:double,title:chararray, displyUrl:chararray, query:chararray, rewrite:chararray) ;

imp_jqk_smt = order imp_jqk_smt by pvid,query,rewrite ;


store imp_jqk_smt into '$out/smt_rewrite' using PigStorage('\t','-noschema') ;


imp_jqk_nonsmt = foreach imp_jqk_nonsmt generate flatten(kunefe.(pvid,pos,matchType,adClicks,rev,title,displayUrl)) as (pvid:chararray,pos:chararray,matchType:chararray,adClicks:int,rev:double, title:chararray, displayUrl:chararray), flatten(group) as (query:chararray, rewrite:chararray) ;

imp_jqk_nonsmt = group imp_jqk_nonsmt by (pvid,pos,matchType,adClicks,rev,title, displayUrl, query, rewrite) parallel 100 ;
imp_jqk_nonsmt = foreach imp_jqk_nonsmt generate flatten(group) as (pvid:chararray,pos:chararray,matchType:chararray,adClicks:int,rev:double,title:chararray, displayUrl:chararray, query:chararray, rewrite:chararray) ;

imp_jqk_nonsmt = order imp_jqk_nonsmt by pvid,query,rewrite ;


store imp_jqk_nonsmt into '$out/nonsmt_rewrite' using PigStorage('\t','-noschema') ;



