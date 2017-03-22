register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

A1 = load '$input' as (q:chararray,qv:chararray,u:{(q:chararray,unit:chararray,uv:chararray)},w:{(q:chararray,unit:chararray,weight:chararray)});
A2 = foreach A1 generate qv, u, w;
B1 = filter A2 by ($0 is not null) and ($1 is not null) and ($2 is not null);
B2 = foreach B1 generate flatten(myudf.sim_weight($0,$1,$2)) as (s1:float,s2:float,s3:float);

C = group B2 all;
D = foreach C generate SUM(B2.s1)/COUNT(B2), SUM(B2.s2)/COUNT(B2), SUM(B2.s3)/COUNT(B2);
store D into '$output';

/* store B2 into '$output_hdfs_dir/tmp_B2.gz'; */
