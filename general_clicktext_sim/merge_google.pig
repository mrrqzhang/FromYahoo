DEFINE CMD `python google_pos_to_clicks.py` ship('$gateway_working_dir/google_pos_to_clicks.py');
DEFINE URL_NORM `python url_norm.py` ship('$gateway_working_dir/url_norm.py');

A0 = load 'usmlr/sim/google_qu_1' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:chararray);
A = stream A0 through URL_NORM AS (f1:chararray,f2:chararray,f3:chararray);

B0 = load 'usmlr/session/qu_click.gz' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:int);
B1 = stream B0 through URL_NORM AS (f1:chararray,f2:chararray,f3:int);
B2 = group B1 by ($0,$1);
B = foreach B2 generate group.$0 as f1, group.$1 as f2, SUM(B1.$2) as f3;

C = group B by $0;
D = foreach C {
        SA = order B by f3 DESC;
        SB = LIMIT SA 1;
        generate flatten(SB);
};
q_maxclick = foreach D generate $0, $2;
E = join A by $0 LEFT OUTER, q_maxclick by $0;
q_u_pos_maxclicks = foreach E generate $0, $1, $2, $4;
q_u_newclicks = stream q_u_pos_maxclicks through CMD as (f1:chararray,f2:chararray,f3:int);
F = union B, q_u_newclicks;
G = group F by ($0,$1);
H = foreach G generate group.$0, group.$1, SUM(F.$2);

store H into '$output_hdfs_dir/qu_click_with_google.gz'; 
