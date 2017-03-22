DEFINE CMD `python aggregate_lcw.py` ship('$gateway_working_dir/aggregate_lcw.py');
DEFINE CMD_NORM `python normalize_vector.py` ship('$gateway_working_dir/normalize_vector.py');
DEFINE CMD_GET_HOST `python get_host.py` ship('$gateway_working_dir/get_host.py');

A0 = load 'usmlr/session/qu_click_view_qfreq.gz' USING PigStorage('\t');
A1 = foreach A0 generate $0, $1, $2;
A2 = filter A1 by $2 is not null;
A = stream A2 through CMD_GET_HOST;
B = load 'usmlr/sim/doc_vector_normalized' USING PigStorage('\t');
C = join A by $1, B by $0 PARALLEL 500;
D = foreach C generate $0 as qry, $2 as weight, $4 as lcw PARALLEL 500;
E = order D by $0 PARALLEL 1;
F = stream E through CMD PARALLEL 500;
G = stream F through CMD_NORM PARALLEL 500;
H = foreach G generate $0,$1,$2;
I = order H by $0;
store I into 'usmlr/sim/query_vector_host.gz';
