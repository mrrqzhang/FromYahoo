DEFINE CMD `python add_host.py` ship('$gateway_working_dir/add_host.py');

url = load '$output_hdfs_dir/$input_url' USING PigStorage('\t') AS (f1:chararray);
url_docvector0 = load '$output_hdfs_dir/$input1' USING PigStorage('\t') AS (f1:chararray,f2:chararray);

url_tmp = join url by $0 LEFT OUTER, url_docvector0 by $0;
url_docvector = foreach url_tmp generate $0, $2;

host_topurl = load '$output_hdfs_dir/host_topurl.gz' USING PigStorage('\t') AS (f1:chararray,f2:chararray);
url_docvector_host = stream url_docvector through CMD;

A = join url_docvector_host by $2 LEFT OUTER, host_topurl by $0;
url_docvector_topurl = foreach A generate $0, $1, $4;

url_modifiedocvector = load '$output_hdfs_dir/$input2' USING PigStorage('\t') AS (f1:chararray,f2:chararray);

B = join url_docvector_topurl by $2 LEFT OUTER, url_modifiedocvector by $0;
url_docvector_hostvector = foreach B generate $0, $1, $4;

store url_docvector_hostvector into '$output_hdfs_dir/$output';
