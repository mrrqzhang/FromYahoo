register /homes/ckang/jars/fetl_sequence_projector/lib/jar/BaseFeed.jar;
register /homes/ckang/jars/fetl_sequence_projector/lib/jar/SequenceProjector.jar;
register /homes/ckang/jars/string.jar;
register /homes/ckang/jars/sequence.jar;

A = load '/projects/FETL/HDW/ABF_Daily/$date_range*/*/*/{Valid}/{Search,All}/' USING com.yahoo.ccdi.fetl.sequence.pig.Projector('type,bcookie,timestamp,src_spaceid,spaceid,ydod,browser,pageparams,query_term,srcpvid,clickinfo,viewinfo:bag');
Q = load 'usmlr/session/qry_set' USING PigStorage('\t');

c1 = filter A by (type=='c' and NOT (query_term matches ' ') and ydod is null and bcookie is not null and src_spaceid=='2766679' and clickinfo#'pos' is not null and ((clickinfo#'it'=='6' and clickinfo#'sec'=='sr' and clickinfo#'slk'=='title') or (clickinfo#'it' matches '.*sc_bz.*' and clickinfo#'sec' == 'sc' and clickinfo#'t5' == 'title') or (clickinfo#'it' matches 'prod_swow*' and clickinfo#'sec' == 'sc' and clickinfo#'t4' == 'prodLst') or (clickinfo#'it' matches 'news_*' and clickinfo#'sec' == 'sc' and clickinfo#'t4' == 'newsLnk')));
c2 = foreach c1 generate
    string.TOLOWERCASE(query_term) as query_term,
    (clickinfo#'targurl' matches 'geo.yahoo.com/t*' ? CONCAT(clickinfo#'targurl',clickinfo#'gid') : clickinfo#'targurl') as targurl;
c3 = group c2 by ($0,$1);
c4 = foreach c3 generate group.$0, group.$1, COUNT(c2);
c5 = join c4 by $0, Q by $0;
c6 = foreach c5 generate $0, $1, $2;
c7 = order c6 by $0;

/*
v1 = filter A by (type=='p' and NOT (query_term matches ' ') and ydod is null and bcookie is not null and src_spaceid=='2766679');
v2 = foreach v1 generate
    string.TOLOWERCASE(query_term) as query_term,
    FLATTEN(viewinfo) as myviewinfo;
v3 = filter v2 by ((myviewinfo#'it'=='6' and myviewinfo#'sec'=='sr' and myviewinfo#'slk'=='title') or (myviewinfo#'it' matches '.*sc_bz.*' and myviewinfo#'sec'=='sc' and myviewinfo#'t5' == 'title') or (myviewinfo#'it' matches 'prod_swow*' and myviewinfo#'sec'=='sc' and myviewinfo#'t4' == 'prodLst') or (myviewinfo#'it' matches 'news_*' and myviewinfo#'sec'=='sc' and myviewinfo#'t4' == 'newsLnk'));
v4 = foreach v3 generate query_term, myviewinfo#'targurl';
v5 = group v4 by ($0,$1);
v6 = foreach v5 generate group.$0, group.$1, COUNT(v4);
v7 = join v6 by $0, Q by $0;
v8 = foreach v7 generate $0, $1, $2;
v9 = order v8 by $0;

t1 = foreach v1 generate string.TOLOWERCASE(query_term) as query_term, srcpvid as vid;
t2 = join t1 by $0, Q by $0;
t3 = foreach t2 generate $0, $1;
t4 = group t3 by $0;
t5 = foreach t4 generate group, COUNT(t3);
*/

store c7 into 'usmlr/session/click$date_range.gz';
/*
store v9 into 'usmlr/session/view$date_range.gz';
store t5 into 'usmlr/session/qfreq$date_range.gz';
*/
