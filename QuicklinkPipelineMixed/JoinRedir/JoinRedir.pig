%default in1 QuicklinkFeatures/test.feats.combined
%default in2 QuicklinkFeatures/urls.redir
%default out QuicklinkFeatures/test.feats
%default final_parallel 100
set default_parallel 100

ret1 = load '$in1' using PigStorage('\t');

/* can introduce null into js */
define JsonizeFeatures `python JsonizeFeatures.py 0` ship('JsonizeFeatures.py');

ret1 = stream ret1 through JsonizeFeatures as (url:chararray, js:chararray);

ret2 = load '$in2' using PigStorage('\t') as (url:chararray, redir:chararray);

ret2 = foreach ret2 generate url, (redir is null ? url : redir) as redir;

ret = foreach (cogroup ret2 by redir inner, ret1 by url) {
    tmp1 = TOP(1,0,ret1);
    -- null cannot be replaced by {(null)} due to type mismatch!
    generate flatten(ret2.url) as url, group as redir, flatten( ( IsEmpty(tmp1.js) ? null : tmp1.js ) ) as redirjs;
}

ret = foreach (cogroup ret by url inner, ret1 by url) {
    tmp1 = TOP(1,0,ret1);
    generate flatten(ret.(url,redir, redirjs)) as (url,redir,redirjs), flatten ( ( IsEmpty(tmp1.js) ? {('[]')} : tmp1.js )) as urljs;
}
/* this can still have nulls in js! */
ret = foreach ret generate url, ( redirjs is null ? urljs : redirjs ) as js;

ret = order ret by url parallel $final_parallel;

store ret into '$out' using PigStorage('\t','-schema');
