source config.sh

if ($start_from_doc_vector == 'no') then

# document vector
# you can use input_q_attr_u_click as input if query attributes are used instead of query
scp exclude_terms.txt $gateway_dir
scp clicktext_mapper.py $gateway_dir
scp clicktext_reducer.py $gateway_dir
scp gen_doc_vector.sh $gateway_dir
ssh $grid 'cd '"$gateway_working_dir"';csh gen_doc_vector.sh '"$input_qu_click"' '"$output_hdfs_dir"'/doc_vector'"$output_suffix"' '"$queue"' '"$normalize_query"' '"$click_threshold"''

# filter/normalize document vector
scp filter_vec.py $gateway_dir
scp filter_vec.sh $gateway_dir
ssh $grid 'cd '"$gateway_working_dir"';csh filter_vec.sh '"$output_hdfs_dir"'/doc_vector'"$output_suffix"' '"$output_hdfs_dir"'/doc_vector_filtered'"$output_suffix"' '"$queue"' 500'
scp normalize_vector.py $gateway_dir
scp normalize_vector.sh $gateway_dir
ssh $grid 'cd '"$gateway_working_dir"';csh normalize_vector.sh '"$output_hdfs_dir"'/doc_vector_filtered'"$output_suffix"' '"$output_hdfs_dir"'/doc_vector_normalized'"$output_suffix"' '"$queue"''

else

scp gen_doc_vector_from_attributes.py $gateway_dir
scp gen_doc_vector_from_attributes.sh $gateway_dir
ssh $grid 'cd '"$gateway_working_dir"';csh gen_doc_vector_from_attributes.sh '"$input_doc_vector"' '"$output_hdfs_dir"'/doc_vector_normalized'"$output_suffix"' '"$queue"' '"$weight_given"''

endif

# generate query vector
scp query_vector.pig $gateway_dir
scp normalize_vector.py $gateway_dir
scp aggregate_lcw.py $gateway_dir
scp get_host.py $gateway_dir
scp gen_url_vec.py $gateway_dir
scp url_norm.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_vector'"$output_suffix"'.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -param input_qu_click='"$input_qu_click"' -param output_suffix='"$output_suffix"' -param output_hdfs_dir='"$output_hdfs_dir"' -param gateway_working_dir='"$gateway_working_dir"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=2000 query_vector.pig'

# next iteration for documents
scp doc_vector_iteration.pig $gateway_dir
scp normalize_vector.py $gateway_dir
scp url_norm.py $gateway_dir
scp aggregate_lcw.py $gateway_dir
set prev_query_vector = query_vector$output_suffix.gz
set next_doc_vector = doc_vector_normalized_i2$output_suffix.gz
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/'"$next_doc_vector"''
ssh $grid 'cd '"$gateway_working_dir"';pig -param prev_query_vector='"$prev_query_vector"' -param next_doc_vector='"$next_doc_vector"' -param input_qu_click='"$input_qu_click"' -param output_hdfs_dir='"$output_hdfs_dir"' -param gateway_working_dir='"$gateway_working_dir"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=2000 doc_vector_iteration.pig'

# may remove query_vector'"$output_suffix"'.gz at this point to save space

# next iteration for queries
scp query_vector_iteration.pig $gateway_dir
scp normalize_vector.py $gateway_dir
scp url_norm.py $gateway_dir
scp aggregate_lcw.py $gateway_dir
set doc_vector = doc_vector_normalized_i2$output_suffix.gz
set next_query_vector = query_vector_i2$output_suffix.gz 
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/'"$next_query_vector"''
ssh $grid 'cd '"$gateway_working_dir"';pig -param next_query_vector='"$next_query_vector"' -param doc_vector='"$doc_vector"' -param input_qu_click='"$input_qu_click"' -param output_hdfs_dir='"$output_hdfs_dir"' -param gateway_working_dir='"$gateway_working_dir"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=2000 query_vector_iteration.pig'

# truncate vectors
scp truncate_vector.py $gateway_dir
scp truncate_vector.pig $gateway_dir

ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_vector_i2'"$output_suffix"'_truncated_'"$max_terms_per_vector"'.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -param max_terms='"$max_terms_per_vector"' -param input=query_vector_i2'"$output_suffix"'.gz -param output=query_vector_i2'"$output_suffix"'_truncated_'"$max_terms_per_vector"'.gz -param output_hdfs_dir='"$output_hdfs_dir"' -param gateway_working_dir='"$gateway_working_dir"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=2000 truncate_vector.pig'

ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/doc_vector_normalized_i2'"$output_suffix"'_truncated_'"$max_terms_per_vector"'.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -param max_terms='"$max_terms_per_vector"' -param input=doc_vector_normalized_i2'"$output_suffix"'.gz -param output=doc_vector_normalized_i2'"$output_suffix"'_truncated_'"$max_terms_per_vector"'.gz -param output_hdfs_dir='"$output_hdfs_dir"' -param gateway_working_dir='"$gateway_working_dir"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=2000 truncate_vector.pig'

# combine new doc vectors with input doc vectors if using doc attributes 
if ($start_from_doc_vector == 'yes') then

scp combine_vectors.pig $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/doc_vector_normalized_i2'"$output_suffix"'_truncated_'"$max_terms_per_vector"'_combined.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -param input1='"$output_hdfs_dir"'/doc_vector_normalized'"$output_suffix"' -param input2='"$output_hdfs_dir"'/doc_vector_normalized_i2'"$output_suffix"'_truncated_'"$max_terms_per_vector"'.gz -param output='"$output_hdfs_dir"'/doc_vector_normalized_i2'"$output_suffix"'_truncated_'"$max_terms_per_vector"'_combined.gz -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=100 combine_vectors.pig'

endif
