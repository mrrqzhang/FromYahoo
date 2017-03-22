register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

query = load '$target_vector' as (q:chararray);
query_unit = foreach query generate $0, flatten(myudf.gen_all_units($0));

units = load '$units' as (u:chararray);

A1 = join query_unit by $1, units by $0;
A2 = foreach A1 generate $0, $1;
A3 = group A2 by $0;

query_unitdecomposition_ = foreach A3 generate group, myudf.unit_decompose($1);
query_unitdecomposition = filter query_unitdecomposition_ by $1 is not null;

store query_unitdecomposition into '$output';
