register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

A = load '$input' as (u:chararray,v:chararray,norm:chararray);
B = foreach A generate u, myudf.truncate_and_apply_norm(v,norm);
store B into '$output';
