register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

query = load '/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz' as (q:chararray);
query_unit = foreach query generate $0, flatten(myudf.gen_all_units($0));

units1 = load '$units1' as (u:chararray);
units2_ = load '$units2' as (u:chararray);
units2 = foreach units2_ generate myudf.add_start_end_tags($0);

units = union units1, units2;

A1 = join query_unit by $1, units by $0;
A2 = foreach A1 generate $0, $1;
A3 = group A2 by $0;

query_unitdecomposition_ = foreach A3 generate group, myudf.unit_decompose($1);
query_unitdecomposition = filter query_unitdecomposition_ by $1 is not null;

store query_unitdecomposition into '$output';
