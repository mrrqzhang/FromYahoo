c1 = load 'usmlr/session/click*/*' USING PigStorage('\t') as (f1:chararray,f2:chararray,f3:int);
c2 = group c1 by ($0,$1);
c3 = foreach c2 generate group.$0, group.$1, SUM(c1.$2);

v1 = load 'usmlr/session/view*/*' USING PigStorage('\t') as (f1:chararray,f2:chararray,f3:int);
v2 = group v1 by ($0,$1);
v3 = foreach v2 generate group.$0, group.$1, SUM(v1.$2);

j1 = join v3 by ($0,$1) LEFT OUTER, c3 by ($0,$1);
j2 = foreach j1 generate $0,$1,$5,$2;
j3 = order j2 by $0,$3 DESC;

k1 = load 'usmlr/session/qfreq*/*' USING PigStorage('\t') as (f1:chararray,f2:int);
k2 = group k1 by $0;
k3 = foreach k2 generate group, SUM(k1.$1);
k4 = join j3 by $0, k3 by $0;
k5 = foreach k4 generate $0, $1, $2, $3, $5;

store k5 into 'usmlr/session/qu_click_view_qfreq.gz';
