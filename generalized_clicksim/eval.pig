register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

A1 = load '$input' as (q:chararray,qv:chararray,u:{(q:chararray,unit:chararray,uv:chararray)});
A2 = foreach A1 generate qv, u;
B1 = filter A2 by ($0 is not null) and ($1 is not null);
B2 = foreach B1 generate flatten(myudf.compare_sim_baseline($0,$1)) as (s1:float,s2:float);

C = group B2 all;
D = foreach C generate SUM(B2.s1)/COUNT(B2), SUM(B2.s2)/COUNT(B2);
store D into '$output'; 
