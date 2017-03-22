%default root 'clickedcrawledfeats'
%default topk 1000
%default input '$root/clicked-immchildren.sr.top-$topk'
%default out '$root/urls.domql'
%default final_parallel 100

set default_parallel 100;


ret = load '$input' using PigStorage('\t');
domains = foreach ret generate $1 as url;
qls  = foreach ret generate $2 as url;
ret = union domains, qls;
ret = distinct ret;
ret = order ret by url parallel $final_parallel;
store ret into '$out' using PigStorage('\t','-schema');
