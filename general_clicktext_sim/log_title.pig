register /homes/ckang/jars/fetl_sequence_projector/lib/jar/BaseFeed.jar;
register /homes/ckang/jars/fetl_sequence_projector/lib/jar/SequenceProjector.jar;
register /homes/ckang/jars/string.jar;
register /homes/ckang/jars/sequence.jar;

A = load '/projects/FETL/HDW/ABF_Daily/$date_range*/*/*/{Valid}/{Search,All}/' USING com.yahoo.ccdi.fetl.sequence.pig.Projector('type,bcookie,timestamp,src_spaceid,spaceid,ydod,browser,pageparams,query_term,srcpvid,clickinfo,viewinfo:bag');
Q = load 'usmlr/session/qry_set' USING PigStorage('\t');

c1 = filter A by (type=='c' and NOT (query_term matches ' ') and ydod is null and bcookie is not null and src_spaceid=='2766679' and clickinfo#'pos' is not null and clickinfo#'it'=='6' and clickinfo#'sec'=='sr' and clickinfo#'slk'=='title');
c2 = foreach c1 generate
    string.TOLOWERCASE(query_term) as query_term,
    clickinfo#'targurl' as targurl,
    clickinfo#'title' as title;
c3 = join c2 by $0, Q by $0;
c4 = foreach c3 generate $1,$2;
c5 = distinct c4;
store c5 into 'usmlr/session/url_title$date_range.gz';
