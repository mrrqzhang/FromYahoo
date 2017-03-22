register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

A = load '/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz' as (q:chararray,v:chararray);
unit_vec = foreach A generate FLATTEN(myudf.gen_units($0)) as u, $1 as v;
unit_term_w_0 = foreach unit_vec generate $0, FLATTEN(myudf.gen_term_w($1));
unit_term_w = foreach unit_term_w_0 generate $0 as unit, $1 as term, (float)$2 as weight;
B = group unit_vec by $0;
C = foreach B generate group, COUNT(unit_vec);

D = group unit_term_w by ($0,$1);
E = foreach D generate group.$0, group.$1, SUM(unit_term_w.weight);

F = join E by $0, C by $0;
unit_term_avg = foreach F generate $0 as unit, $1 as term, $2/$4 as avgweight;

G = group unit_term_avg by $0;
H = FOREACH G {
    SA = ORDER unit_term_avg BY avgweight DESC;
    SB = LIMIT SA 50;
    GENERATE group, SB;
};

I = foreach H generate $0, myudf.gen_avg($1);

store I into '$output';
