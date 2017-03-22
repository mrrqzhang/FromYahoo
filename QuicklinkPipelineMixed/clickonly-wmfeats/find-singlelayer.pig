SET mapred.create.symlink yes;
SET mapred.cache.archives /user/jyj/distcachesrc/localpython2.tar.gz#local-py

%default root 'clickedcrawledfeats'

%default input '$root/clicked-immchildren.sr.top-1000.dedup/part*'

%DEFAULT output '$root/single-layer-domainlist' 

define Selection `./local-py/bin/python singlelayer-selection.py` ship('/home/jyj/mylib/genLibs.py', 'singlelayer-selection.py');

A = load '$input' ;

A = foreach A generate $0 as domain:chararray, $1 as ql:chararray;
B =  stream A through Selection  AS (domain:chararray);

C = ORDER B by domain ASC;

STORE C INTO '$output' USING PigStorage('\t','-schema');
