-- this script is only used for training mode

%default froot QuicklinkFeatures
%default in $froot/traindata
%default out $froot/traindata.tsv

%default nwmfeats 88

%default naggfeats 22
%default ntitlefeats 2
%default nldafeats_plus_one 31
%default ntoolbarfeats 6
%default final_parallel 100;
set default_parallel 1000;
SET mapred.create.symlink yes;
SET mapred.cache.archives /user/jyj/distcachesrc/localpython3.tar.gz#local-py


-- 4,5,6,7,8,9 are the positions of the json columns; 22,88,88,2,31,6 are the sizes of the json lists; -1 is the default value
define JsonList2Tsv `./local-py/bin/python JsonList2Tsv.py 4,5,6,7,8,9 $naggfeats,$nwmfeats,$nwmfeats,$ntitlefeats,$nldafeats_plus_one,$ntoolbarfeats -1` ship('JsonList2Tsv.py');

ret = load '$in' using TextLoader;



-- schema below would be domain, ql, weight, target, 22 agg features, 88 domain wm features, 88 ql wm features, 2 ql title features, 31 lda category scores plus top category, and 6 toolbar features
ret2 = stream ret through JsonList2Tsv;

-- just to get the double 
ret3 = foreach ret2 generate $0 as domain, $1 as ql, $2 as weight, (double) $3 as target, $4 .. ;

ret4 = order ret3 by $0, $3 DESC parallel $final_parallel;

store ret4 into '$out' using PigStorage('\t','-schema');

