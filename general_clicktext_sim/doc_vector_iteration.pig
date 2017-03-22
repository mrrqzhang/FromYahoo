/*
input:
	prev_query_vector
	qu_click.gz
output:
	next_doc_vector
*/

DEFINE CMD `python aggregate_lcw.py` ship('$gateway_working_dir/aggregate_lcw.py');
DEFINE CMD_NORM `python normalize_vector.py 0.0001 500` ship('$gateway_working_dir/normalize_vector.py');
DEFINE CMD_NORM_QV `python normalize_vector.py 0.00001 10` ship('$gateway_working_dir/normalize_vector.py');
DEFINE URL_NORM `python url_norm.py` ship('$gateway_working_dir/url_norm.py');

query_url_clicks_tmp0 = load '$input_qu_click' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:chararray);
query_url_clicks_tmp = filter query_url_clicks_tmp0 by Not (f1 matches 'xxxx+');
query_url_clicks = stream query_url_clicks_tmp through URL_NORM;

/* next doc vector */
url_query_clicks = foreach query_url_clicks generate $1, $0, $2;
q_vec_norm_0 = load '$output_hdfs_dir/$prev_query_vector' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:chararray);
q_vec_norm = stream q_vec_norm_0 through CMD_NORM_QV;

qry_join = join url_query_clicks by $1, q_vec_norm by $0;
url_clicks_vec = foreach qry_join generate $0 as url, $2 as clicks, $4 as vec;

C0 = group url_clicks_vec by $0;
C1 = foreach C0 generate FLATTEN(url_clicks_vec);
C2 = stream C1 through CMD;
C3 = stream C2 through CMD_NORM;
C4 = foreach C3 generate $0,$1,$2;
C5 = order C4 by $0;
store C5 into '$output_hdfs_dir/$next_doc_vector';
