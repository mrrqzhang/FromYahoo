REGISTER /home/jyj/mylib/hdstreamlib.py USING jython AS pyudf;
SET default_parallel 1000;
%default root 'QuicklinkTitles'

%default rawf '$root/url.redir.title.wmdata';
%default redirf '$root/redirurl.title.wmdata';
%default domqlf '$root/domql';
%default nitems 100
%default buffersize 10000

raw = load '$rawf' using PigStorage('\t') as (url:chararray, redt:chararray, title:chararray, wmdata:chararray);

raw = foreach raw generate url, redt, title, pyudf.ShortWmdata(wmdata,$nitems,$buffersize) as wmdata;

redir = load '$redirf' using PigStorage('\t') as (redt:chararray, title:chararray, wmdata:chararray);

redir = foreach redir generate redt, title, pyudf.ShortWmdata(wmdata,$nitems,$buffersize) as wmdata;


domql  = load '$domqlf' using PigStorage('\t') as (domain:chararray, ql:chararray);


ret2 = join raw by redt, redir by redt;

ret2 = foreach ret2 generate raw::url as url, raw::redt as redt, redir::title as title, redir::wmdata as wmdata;

--SET pig.noSplitCombination true;


--raw = filter raw by title != '' or wmdata != '';


ret = foreach (cogroup raw by (url,redt) inner, ret2 by (url,redt) ) {
    tmpraw = TOP(1,0,raw);
    tmpret2 = TOP(1,0,ret2);
    generate flatten(group) as (url,redt), flatten(tmpraw.(title,wmdata)) as (rawtitle,rawwmdata), 
        flatten( ( IsEmpty(tmpret2.title) ? tmpraw.(title,wmdata) : tmpret2.(title,wmdata) ) ) as (redirtitle,redirwmdata);
}

ret = foreach ret generate url, redt, ( ( rawtitle == '' OR rawtitle is null ) ? redirtitle : rawtitle ) as title, ( ( rawwmdata == '' OR rawwmdata is null ) ? redirwmdata : rawwmdata ) as wmdata ;

ret3 = distinct ret;

ret = join domql by ql, ret3 by url;

ret = foreach ret generate domql::domain as domain, ret3::url as url, ret3::redt as redt, ret3::title as title, ret3::wmdata as wmdata;

ret = foreach ( cogroup ret by domain inner, ret3 by url ) {
    tmpret3 = TOP(1,0,ret3);
    generate flatten(ret.(domain, url, redt, title, wmdata )) as (domain, url, redt, title, wmdata ), flatten(( IsEmpty(tmpret3.url) ? TOBAG(TOTUPLE('','')) : tmpret3.(title,wmdata)) ) as (dom_title,dom_wmdata);
} 


ret = order ret by domain, url, redt parallel 100;

%default out '$root/combined.redir.title.wmdata';
store ret into '$out' using PigStorage('\t','-schema');
