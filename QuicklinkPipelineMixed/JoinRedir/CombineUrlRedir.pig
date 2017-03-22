%default in1 'QuicklinkFeatures/urls' 
%default in2 'QuicklinkFeatures/urls.redir.0'
%default out 'QuicklinkFeatures/urls.combined'
%default out2 'QuicklinkFeatures/urls.redir'

%default final_parallel 100
set default_parallel 100 ;
ret1 = load '$in1' using PigStorage('\t') as (url:chararray);
ret2 = load '$in2' using PigStorage('\t') as (url:chararray, redir:chararray);


ret0 = foreach ret2 generate redir as url;

ret = UNION ret1, ret0;

ret = DISTINCT ret;

ret = ORDER ret by url parallel $final_parallel;

store ret into '$out' using PigStorage('\t','-schema');

ret3 = foreach (cogroup ret1 by url inner, ret2 by url) {
    tmp2 = TOP(1,0,ret2);
    tmp1 = TOP(1,0,ret1);
    generate group as url, flatten( ( IsEmpty(tmp2.redir) ? tmp1.url : tmp2.redir ) ) as redir;
}
ret3 = foreach ret3 generate url, ( redir is null ? url : redir ) as redir;

ret3 = order ret3 by url parallel $final_parallel;

store ret3 into '$out2' using PigStorage('\t','-schema');

