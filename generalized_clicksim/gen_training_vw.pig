register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

A = load '$input' as (qv:chararray,u:{(q:chararray,unit:chararray,uv:chararray)});
B1 = filter A by $1 is not null;
B2 = foreach B1 generate myudf.gen_vw_case($0,$1);
B3 = foreach B2 generate flatten($0);
B4 = group B3 by $0;
B5 = foreach B4 generate group, COUNT(B3);
B6 = filter B5 by $0 is not null;
B7 = foreach B6 generate myudf.vw_add_weight($0,$1);
B8 = filter B7 by $0 is not null;
B9 = foreach B8 generate RANDOM(),$0;
B10 = order B9 by $0;
B11 = foreach B10 generate $1;

store B11 into '$output';
