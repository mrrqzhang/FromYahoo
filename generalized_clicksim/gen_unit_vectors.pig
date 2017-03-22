register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

top_units = load '$input' as (u:chararray);

A1 = load '$input_qu_click' as (q:chararray,url:chararray,clicks:int);
A2 = filter A1 by clicks>=5;
A3_0 = foreach A2 generate FLATTEN(myudf.gen_all_units($0)) as unit, url, clicks;
A3_1 = join A3_0 by $0, top_units by $0;
A3 = foreach A3_1 generate $0, $1, $2;
A4 = group A3 by (unit,url);
A5 = foreach A4 generate group.$0, group.$1, SUM(A3.clicks) as clicks;
A6 = group A5 by $0;
A7 = FOREACH A6 {
    SA = ORDER A5 BY clicks DESC;
    SB = LIMIT SA 200;
    GENERATE flatten(SB);
};

store A7 into '$output';
