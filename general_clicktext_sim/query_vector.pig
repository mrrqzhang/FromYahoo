DEFINE CMD `python aggregate_lcw.py` ship('$gateway_working_dir/aggregate_lcw.py');
DEFINE CMD_NORM `python normalize_vector.py` ship('$gateway_working_dir/normalize_vector.py');
DEFINE URL_NORM `python url_norm.py` ship('$gateway_working_dir/url_norm.py');

query_url_clicks_tmp0 = load '$input_qu_click' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:chararray);
query_url_clicks_tmp = filter query_url_clicks_tmp0 by Not (f1 matches 'xxxx+');
query_url_clicks = stream query_url_clicks_tmp through URL_NORM;

B = load '$output_hdfs_dir/doc_vector_normalized$output_suffix' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:chararray);

url_join = join query_url_clicks by $1, B by $0;
query_clicks_vec = foreach url_join generate $0 as qry, $2 as clicks, $4 as vec;

C0 = group query_clicks_vec by $0;
C1 = foreach C0 generate FLATTEN(query_clicks_vec);
C2 = stream C1 through CMD;
C3 = stream C2 through CMD_NORM;
C4 = foreach C3 generate $0,$1,$2;
C5 = order C4 by $0;

store C5 into '$output_hdfs_dir/query_vector_i1$output_suffix.gz';
