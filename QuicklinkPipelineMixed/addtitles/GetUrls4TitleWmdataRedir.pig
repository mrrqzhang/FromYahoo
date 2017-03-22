SET default_parallel 100;
--SET pig.noSplitCombination true;
%default root 'QuicklinkTitles'


%default domqlf 'clickedcrawledfeats/clicked-immchildren.sr.top-100.dedup/part-r-*'

domql  = load '$domqlf' using PigStorage('\t') as (domain:chararray, ql:chararray, score:float);
ret = foreach domql generate ql;
ret0 =  foreach domql generate domain;
ret = union ret, ret0;
ret = DISTINCT ret;
%default out '$root/urls.domqls';
ret = order ret by ql parallel 100;
store ret into '$out' using PigStorage('\t','-schema');
ret2 = foreach domql generate domain, ql;
%default out2 '$root/domql';
ret2 = DISTINCT ret2;
ret2 = order ret2 by domain, ql parallel 100;
store ret2 into '$out2' using PigStorage('\t','-schema');
