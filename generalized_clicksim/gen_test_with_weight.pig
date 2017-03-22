register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

unit_weight = load '$unit_weight' as (u:chararray,w:chararray);

A1 = load '$queries_decomposed' as (q:chararray,decomposed:chararray);
A2 = foreach A1 generate q, FLATTEN(TOKENIZE(decomposed,'|'));
A3 = join A2 by $1, unit_weight by $0;
q_unit_weight = foreach A3 generate $0, $1, $3;
q_bag_unit_weight = group q_unit_weight by $0;

test_data = load '$test' as (q:chararray,qv:chararray,u:{(q:chararray,unit:chararray,uv:chararray)});

A4 = join test_data by $0, q_bag_unit_weight by $0;
A5 = foreach A4 generate $0, $1, $2, $4;

store A5 into '$output';

