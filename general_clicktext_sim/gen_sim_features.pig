DEFINE CMD `python gen_sim_features.py` ship('$gateway_working_dir/gen_sim_features.py');

A1 = load '$output_hdfs_dir/$input_qu' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:chararray,f4:chararray);
A2 = load '$output_hdfs_dir/host_topurl.gz' USING PigStorage('\t') AS (f1:chararray,f2:chararray);
A3 = join A1 by $3 LEFT OUTER, A2 by $0;
A4 = foreach A3 generate $0, $1, $2, $3, $5;
A = stream A4 through `awk -F"\t" '{if($4==$5){print $1"\t"$2"\t"$3"\t"$4}else{print $1"\t"$2"\t"$3"\t"$5}}'` as (f1:chararray,f2:chararray,f3:chararray,f4:chararray);

B = load '$output_hdfs_dir/query_vector_i2$output_suffix.gz' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:chararray);
C = load '$output_hdfs_dir/doc_vector_normalized_i2$output_suffix.gz' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:chararray);

qry_vec = foreach B generate $0,$1;
doc_vec = foreach C generate $0,$1;

tmp1 = join A by $0 LEFT OUTER, qry_vec by $0;
/* qry, u, u',host, qry_vec */
tmp2 = foreach tmp1 generate $0,$1,$2,$3,$5;
tmp3 = join tmp2 by $2 LEFT OUTER, doc_vec by $0;
q_u1_u2_host_qv_dv = foreach tmp3 generate $0,$1,$2,$3,$4,$6;

/* qry, u, u',host, qry_vec, host_vec */
doc_vec_modified_0 = load '$output_hdfs_dir/doc_vector_normalized_modified_i2$output_suffix.gz' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:chararray);
doc_vec_modified = foreach doc_vec_modified_0 generate $0,$1;
tmp4 = join q_u1_u2_host_qv_dv by $3 LEFT OUTER, doc_vec_modified by $0;
q_u1_u2_host_qv_dv_hv = foreach tmp4 generate $0,$1,$2,$3,$4,$5,$7;

q_u_features = stream q_u1_u2_host_qv_dv_hv through CMD;

store q_u_features into '$output_hdfs_dir/$output';
