register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

unit_vector = load '$output_hdfs_dir/unit_vector_truncated.gz' as (u:chararray,v:chararray);

A1 = load '$output_hdfs_dir/test.gz' as (q:chararray);
A2 = foreach A1 generate q, FLATTEN(TOKENIZE(q,' '));
A3 = join A2 by $1, unit_vector by $0;
q_unit_vector = foreach A3 generate $0, $1, $3;

q_vector = load '/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz' as (q:chararray,v:chararray);

B1 = group q_unit_vector by $0;
B2 = join B1 by $0, q_vector by $0;

q_qv_set_of_unit_vectors = foreach B2 generate $0, $3, $1;

store q_qv_set_of_unit_vectors into '$output';
