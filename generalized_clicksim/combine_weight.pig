register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

A1 = load '$unit_vector' as (u:chararray,v:chararray);
A2 = load '$unit_weight' as (u:chararray,w:float);
A3 = join A1 by $0 LEFT OUTER, A2 by $0;
A4 = foreach A3 generate $0, myudf.combine_unit_vector_weight($1,$3);

store A4 into '$output';
