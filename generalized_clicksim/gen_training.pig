register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

unit_vector = load '$input_unit_vector' as (u:chararray,v:chararray);

A1 = load '$queries_decomposed' as (q:chararray,decomposed:chararray);
/* A2 = SAMPLE A1 0.001; */
/* A2 = SAMPLE A1 0.005; */
A2 = SAMPLE A1 0.01;
A3 = foreach A2 generate q, FLATTEN(TOKENIZE(decomposed,'|'));
A4 = join A3 by $1, unit_vector by $0;
q_unit_vector = foreach A4 generate $0, $1, $3;

q_vector = load '$target_vector' as (q:chararray,v:chararray);

B1 = group q_unit_vector by $0;
B2 = join B1 by $0, q_vector by $0;

qv_set_of_unit_vectors = foreach B2 generate $3, $1;

store qv_set_of_unit_vectors into '$output';
