%default input 'noncrawled-250kroots/WebmapAllUrls/par*.bz2'
--%default input 'noncrawled-250kroots/WebmapAllUrls/par*00000.bz2'
SET pig.noSplitCombination true;
set default_parallel 5000;
--https://www.facebook.com/shares/view?id=697717730303092   0.0 19.855423   false   facebook.com
ret = load '$input' using PigStorage('\t') as (url:chararray, clicks:float, linkflux:float, crawled:boolean, domain:chararray);
ret = filter ret by crawled == true and clicks > 0;
ret = foreach ret generate url, domain, clicks, linkflux;
%default out 'noncrawled-250kroots-feats/allclickedcrawled'
store ret into '$out' using PigStorage('\t','-schema');
