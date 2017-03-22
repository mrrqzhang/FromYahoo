%default root QuicklinkTitles
%default modelxml 'gbdt.xml'
SET mapred.create.symlink yes;
SET mapred.cache.archives /user/jyj/distcachesrc/localpython3.tar.gz#local-py

define ApplyModel `./local-py/bin/python DecideTitle.py $modelxml` ship('DecideTitle.py','$modelxml','/home/jyj/mylib/genLibs.py');
%default input '$root/traindata/par*'
%default out '$root/decided'
set default_parallel 100;
%default final_parallel 100 

ret = load '$input' using TextLoader;

ret = stream ret through ApplyModel as (domain:chararray, url:chararray, finaltitle:chararray);

ret = order ret by domain, url parallel $final_parallel;

store ret into '$out' using PigStorage('\t','-schema');

