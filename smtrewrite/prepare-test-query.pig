REGISTER smt_udf.py USING jython AS pyudf;

A1 = LOAD '$INPUT' USING PigStorage('\t') AS (query:chararray);
A2 = FILTER A1 BY (query IS NOT NULL) AND (query neq '');
A3 = FOREACH A2 GENERATE FLATTEN(pyudf.replicate_queries($PARTITIONS, query)) AS (partition:int, query:chararray);
A4 = ORDER A3 BY query PARALLEL 1;

rmf $OUTPUT
STORE A4 INTO '$OUTPUT' USING PigStorage('\t', '-noschema');

