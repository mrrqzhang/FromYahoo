SET mapred.create.symlink yes;
SET mapred.cache.archives /user/jyj/distcachesrc/localpython2.tar.gz#local-py

%default root 'clickedcrawledfeats'

%default input '$root/WebmapAllUrls-views-inlinkcnt/part*'

%DEFAULT output '$root/singlelayer-quicklink' 



define JoinSr `./local-py/bin/python JoinSr-singlelayer.py single-layer.dict.largedomain.json` ship('/home/jyj/mylib/genLibs.py', 'JoinSr-singlelayer.py', 'single-layer.dict.largedomain.json');

A = load '$input' AS (domain:chararray,  ql:chararray,  inlinkcnt:int,  internalinlinkcnt:int ) ;

A = filter A by (internalinlinkcnt > 0) ;

B =  stream A through JoinSr  AS (domain:chararray,url:chararray,title:chararray,inlinkcnt:int,internalinlinkcnt:int);

B = foreach B generate domain AS domain:chararray, url AS url:chararray,  (internalinlinkcnt+1000000000) AS internalinlinkcnt:int ;


C = foreach (group B by domain) {
    tmp = TOP(10,2,B) ;
    generate flatten(tmp);
};

C = ORDER C by domain ASC, internalinlinkcnt DESC;

STORE C INTO '$output' USING PigStorage('\t','-schema');
