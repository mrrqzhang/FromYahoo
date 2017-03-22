register /homes/ckang/jars/fetl_sequence_projector/lib/jar/BaseFeed.jar;
register /homes/ckang/jars/fetl_sequence_projector/lib/jar/SequenceProjector.jar;
register /homes/ckang/jars/string.jar;
register /homes/ckang/jars/sequence.jar;

A = load '/projects/FETL/HDW/ABF_Daily/$date_range*/*/*/{Valid}/{Search,All}/' USING com.yahoo.ccdi.fetl.sequence.pig.Projector('type,bcookie,timestamp,src_spaceid,spaceid,ydod,browser,pageparams,query_term,srcpvid,clickinfo,viewinfo:bag');

c1_1 = filter A by (type=='c' and NOT (query_term matches ' ') and ydod is null and bcookie is not null and src_spaceid=='2766679' and clickinfo#'pos' is not null and clickinfo#'it'=='6' and clickinfo#'sec'=='sr' and clickinfo#'slk'=='title');
c1_2 = filter A by (type=='c' and NOT (query_term matches ' ') and ydod is null and bcookie is not null and src_spaceid=='2766679' and clickinfo#'pos' is not null and clickinfo#'it' matches '.*sc_bz.*' and clickinfo#'sec' == 'sc' and clickinfo#'sclabel' == 'official');
c1 = union c1_1, c1_2;
c2 = foreach c1 generate
    string.TOLOWERCASE(REPLACE(query_term,'\\+',' ')) as query_term,
    clickinfo#'targurl' as targurl;
c3 = group c2 by ($0,$1);
c4 = foreach c3 generate group.$0, group.$1, COUNT(c2);
c5 = order c4 by $0;

store c5 into 'usmlr/session/click$date_range.gz';

/*
v1 = filter A by (type=='p' and NOT (query_term matches ' ') and ydod is null and bcookie is not null and src_spaceid=='2766679');
v2 = foreach v1 generate
    string.TOLOWERCASE(query_term) as query_term,
    FLATTEN(viewinfo) as myviewinfo;
v3_1 = filter v2 by (myviewinfo#'it'=='6' and myviewinfo#'sec'=='sr' and myviewinfo#'slk'=='title');
v3_2 = filter v2 by (myviewinfo#'it' matches '.*sc_bz.*' and myviewinfo#'sec'=='sc' and myviewinfo#'sclabel' == 'official');
v3 = union v3_1, v3_2;
v4 = foreach v3 generate query_term, myviewinfo#'targurl';
v5 = group v4 by ($0,$1);
v6 = foreach v5 generate group.$0, group.$1, COUNT(v4);
v7 = order v6 by $0;

t1 = foreach v1 generate string.TOLOWERCASE(query_term) as query_term, srcpvid as vid;
t2 = group t1 by $0;
t3 = foreach t2 generate group, COUNT(t1);
store v7 into 'usmlr/session/view$date_range.gz';
store t3 into 'usmlr/session/qfreq$date_range.gz';
*/
