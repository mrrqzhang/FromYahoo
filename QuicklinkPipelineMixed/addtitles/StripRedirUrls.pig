%default root 'QuicklinkTitles'
%default input '$root/url.redir.title.wmdata'
ret = load '$input' using PigStorage('\t') as (url:chararray, redt:chararray, title:chararray, wmdata:chararray);
ret = foreach ret generate redt;
ret = filter ret by redt != '';
ret = order ret by redt parallel 10;
%default out '$root/redirurls';
store ret into '$out' using PigStorage('\t','-schema');
