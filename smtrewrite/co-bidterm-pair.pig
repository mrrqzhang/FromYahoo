REGISTER smt_udf.py USING jython AS pyudf;

%default input 'hdfs://dilithiumred-nn1.red.ygrid.yahoo.com:8020/tmp/bidTermsNew/'
%default out '/tmp/cb_nctr/ruiqiang/smtrewrite/train/bidterms'

rmf $out

A1 = LOAD '$input' USING PigStorage('\t', '-noschema') ;
A2 = FOREACH A1 GENERATE (chararray)$0 as group_id:chararray, (chararray)$1 as query:chararray; 
-- A2 = FOREACH A1 GENERATE (chararray)$5 as group_id:chararray, (chararray)$10 as query:chararray;

A3 = FILTER A2 BY (group_id IS NOT NULL) AND (group_id neq '') AND
                  (query IS NOT NULL) AND (query neq '');

A3 = DISTINCT A3 PARALLEL 100 ;

-- Skip if within the same group, there are too many rewrites.
B1 = GROUP A3 BY (group_id) PARALLEL 100;
-- For the scrape qbert end point, at most, it returns 50 top rewrites per query.
B2 = FILTER B1 BY COUNT(A3) <= 50;
B3 = FOREACH B2 GENERATE FLATTEN(A3) AS (group_id:chararray, query:chararray);
--
C1 = FOREACH B3 GENERATE (chararray)group_id AS group_id:chararray, (chararray)query AS query:chararray;

-- join.
D1 = JOIN B3 BY (group_id), C1 BY (group_id) PARALLEL 1000;
D2 = FOREACH D1 GENERATE B3::group_id AS group_id,
                         B3::query AS lhs_query,
                         C1::query AS rhs_query;
D3 = FOREACH D2 GENERATE group_id, lhs_query, rhs_query, pyudf.cosine(lhs_query, rhs_query) AS score:float;

D4 = GROUP D3 BY (group_id) PARALLEL 1000;
D5 = FOREACH D4 {
       S1 = FOREACH D3 GENERATE lhs_query, rhs_query;
       GENERATE FLATTEN(group) AS (group_id), S1, SUM(D3.score)/COUNT(D3) AS mean_score:double;
     };


D6 = FILTER D5 BY (mean_score > 0.3);
D7 = FOREACH D6 GENERATE group_id, FLATTEN(S1) AS (lhs_query:chararray, rhs_query:chararray);
D8 = ORDER D7 BY group_id, lhs_query PARALLEL 15;

-- dump the mean_score for adhoc check.
--E1 = FOREACH D5 GENERATE group_id, mean_score;
--E2 = ORDER E1 BY group_id PARALLEL 1;


STORE D8 INTO '$out' USING PigStorage('\t', '-noschema');
--rmf ss/match/smt/smtrewrite/trv/tmp
--STORE E2 INTO 'ss/match/smt/smtrewrite/trv/tmp' USING PigStorage('\u0001');

