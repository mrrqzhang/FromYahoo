DEFINE CMD `python clean_qry.py` ship('$gateway_working_dir/clean_qry.py');

c0 = load 'usmlr/session/click*/*' USING PigStorage('\t') as (f1:chararray,f2:chararray,f3:int);
c1 = stream c0 through CMD;
c2 = group c1 by ($0,$1);
c3 = foreach c2 generate group.$0, group.$1, SUM(c1.$2);
c4 = order c3 by $0;

store c4 into 'usmlr/session/qu_click.gz';
