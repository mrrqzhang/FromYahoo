register /grid/0/gs/pig/current/libexec/released/sds.jar;
register  /homes/kfujii/yahoo-piggy-bank/string.jar ;

DEFINE LOADFUNC `perl load.pl` SHIP('/homes/ruiqiang/qrwtrans/load.pl') ;

-- A = LOAD 'test.data test2.data'   ;

-- A = load '/grid/0/tmp/ruiqiang/chain-data-from-yoshi.txt' ;

A = LOAD '/user/inagakiy/qc_test/US2009*norm/[gm]*' ;

B =  stream A through LOADFUNC AS (session:long, qpos:long, query:chararray, url:chararray, clkpos:long) ;

C = foreach B generate query, url ;

C1 = group C by (query,url) ;

E = foreach C1 generate flatten(group), COUNT(C) ;

H = group E by $0 ;

I = foreach H generate group,  SUM(E.$2) ;

J = join I by $0, E by $0 ;

J2 = filter J by (float)$4/$1>=0.1 AND $1>=10 ;

-- confident query
Q1 = foreach J2 generate $0 ;
Q2 = group Q1 by $0 ;
Q3 = foreach Q2 generate $0 AS query;

-- confident url
U1 = foreach J2 generate $3 ;
U2 = group U1 by $0 ;
U3 = foreach U2 generate $0 AS url ;

D1 = join B by query, Q3 by query ;
D2 = foreach D1 generate $0,$1,$2,$3,$4  ;

D3 = group D2 by $0 ;

E1 = join D2 by $3, U3 by url ;
E2 = foreach E1 generate $0,$1,$2,$3,$4  ;
-- group by session
E3 = group E2 by $0 ;

E4 = foreach E3 generate $1.($1,$2,$3), COUNT($1) ;


E5 = filter E4 by $1>1 ;

E6 = foreach E5 generate $0 ;

E7 = stream E6 through `sed "s/),(/\t/g" | sed "s/^{(//g" | sed "s/)}$//g"` ;

STORE E7 INTO  'output-session-clk0.1-qry10' USING PigStorage;

-- group by url

-- pos=x, query, url
F0 = foreach E2 generate $4,$2,$3 ;

FB0 = group E2 by ($4,$2,$3) ;
FB1 = foreach FB0 generate flatten(group),COUNT(E2) ;

F1 = group FB1 by $2 ;

F2 = foreach F1 generate $1, COUNT($1) ;


F3 = filter F2 by $1>1 ;

F4 = foreach F3 generate $0 ;

F5 = stream F4 through `sed "s/),(/\t/g" | sed "s/^{(//g" | sed "s/)}$//g" | awk '{if(NR>1) print $0}'` ;

-- F5 = foreach F4 generate FB1.query, FB1.$3 ;

STORE F5 INTO  'output-url-clk0.1-qry10' USING PigStorage;





