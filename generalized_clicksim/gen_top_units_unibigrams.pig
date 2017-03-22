register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

A = load '/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz' as (q:chararray);
uni = foreach A generate FLATTEN(myudf.gen_unigrams($0)) as u;
B = group uni by $0;
C = foreach B generate group, COUNT(uni);
D = order C by $1 DESC;
E = limit D 5000000;

bi = foreach A generate FLATTEN(myudf.gen_bigrams($0)) as bi;
B2 = group bi by $0;
C2 = foreach B2 generate group, COUNT(bi);
D2 = order C2 by $1 DESC;
E2 = limit D2 5000000;

F = union E, E2;

store F into '$output';
