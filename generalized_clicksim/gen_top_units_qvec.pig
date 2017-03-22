A = load '/projects/clickmodel/ckang/session/q_sumclicks.gz' as (q:chararray,clicks:int);
B = load '/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz' as (q:chararray,v:chararray);
C = join B by $0, A by $0;
D = foreach C generate $0, $1, $3;
E = order D by $2 DESC;
F = limit E 10000000;

store F into '$output';
