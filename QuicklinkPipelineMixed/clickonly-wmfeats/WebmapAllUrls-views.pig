
REGISTER /home/jyj/mylib/jars/webmap-table-format-2.5.0.jar;

%default root 'clickedcrawledfeats'
%default clickfilter 0
%default table crawledurl
%DEFAULT out '$root/WebmapAllUrls-views'
%DEFAULT outlinkcnt '$root/WebmapAllUrls-views-linkcnt'
%default rootdictfile 'rootdict.norm.onejson.abf'
%default viewfilter 0

set mapred.compress.map.output true;
set output.compression.enabled true;
set output.compression.codec org.apache.hadoop.io.compress.BZip2Codec;

SET default_parallel 2000;

%default wmv wm-2014-09-30-20-45-18
%DEFAULT webmap_data_path '/webmap/batches/$wmv/atoms/' -- wm-34 full data set; check out yo/wmb

SET pig.noSplitCombination true; 

--remove dup and non-crawled

urlMap = LOAD 'wmtf:/' USING com.yahoo.corp.yst.webmap.input.pig.impl.MD5KeyTableLoader('$webmap_data_path:$table:url,clicks,views,linkflux,inlinkcnt,internalinlinkcnt:2000') AS (url:CHARARRAY,clicks:FLOAT,views:FLOAT,linkflux:FLOAT,inlinkcnt:FLOAT,internalinlinkcnt:FLOAT);

urlMap = filter urlMap by clicks >= $clickfilter and views >= $viewfilter ;

DEFINE FindDomain `python JoinSr.py $rootdictfile FindDomain` ship('$rootdictfile','JoinSr.py','/home/jyj/mylib/genLibs.py');

urlMap = stream urlMap through FindDomain as (url:chararray, clicks:float, views:float, linkflux:float, inlinkcnt:float, internalinlinkcnt:float, domain:chararray);

urlMap2 = foreach urlMap generate url as url:chararray,clicks as clicks:FLOAT,views as views:FLOAT ,linkflux as linkflux:FLOAT,domain AS domain:CHARARRAY;

urlMap3 = foreach urlMap generate url as url:chararray, domain AS domain:CHARARRAY,inlinkcnt AS inlinkcnt:FLOAT, internalinlinkcnt  AS internalinlinkcnt:FLOAT ;

store urlMap2 into '$out' USING PigStorage('\t','-schema');

store urlMap3 into '$outlinkcnt' USING PigStorage('\t','-schema');







