source config.sh

# input data
# - input_qu_click
# - target_vector
# output data
# - unit_vector_weighted.gz

set target_vector = /projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz

# choose top units
scp gen_top_units_ngrams.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/top_units_ngrams.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param target_vector='"$target_vector"' -param output='"$output_hdfs_dir"'/top_units_ngrams.gz -param gateway_working_dir='"$gateway_working_dir"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=2000 gen_top_units_ngrams.pig'

# find queries that are completely covered by units
# and do not match any single unit
scp find_queries_covered_by_units.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/queries_decomposed.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param target_vector='"$target_vector"' -param units='"$output_hdfs_dir"'/top_units_ngrams.gz -param output='"$output_hdfs_dir"'/queries_decomposed.gz -param gateway_working_dir='"$gateway_working_dir"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=5000 find_queries_covered_by_units.pig'

# generate unit vectors
scp gen_unit_vectors.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
scp sample_for_each_key_avg.py $gateway_dir
scp avg_vectors.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/unit_doc_clicks.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param input_qu_click='"$input_qu_click"' -param input='"$output_hdfs_dir"'/top_units_ngrams.gz -param output='"$output_hdfs_dir"'/unit_doc_clicks.gz -param gateway_working_dir='"$gateway_working_dir"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=8000 gen_unit_vectors.pig'

scp query_vector_iteration.pig $gateway_dir
scp normalize_vector.py $gateway_dir
scp url_norm.py $gateway_dir
scp $MLR_SCRIPTS/aggregate_lcw.py $gateway_dir
set doc_vector = /projects/clickmodel/ckang/usmlr/sim_v4/doc_vector_normalized_i2$output_suffix.gz
set next_query_vector = $output_hdfs_dir/unit_vector.gz
ssh $grid 'hadoop fs -rm -r -skipTrash '"$next_query_vector"''
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param next_query_vector='"$next_query_vector"' -param doc_vector='"$doc_vector"' -param input_doc_click='"$output_hdfs_dir"'/unit_doc_clicks.gz -param gateway_working_dir='"$gateway_working_dir"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=5000 query_vector_iteration.pig'

scp truncate_apply_norm.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/unit_vector_truncated.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param input='"$output_hdfs_dir"'/unit_vector.gz -param output='"$output_hdfs_dir"'/unit_vector_truncated.gz -param gateway_working_dir='"$gateway_working_dir"' -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=2000 truncate_apply_norm.pig'

# generate training data for vw
scp gen_training.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/training.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param input_unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param target_vector='"$target_vector"' -param queries_decomposed='"$output_hdfs_dir"'/queries_decomposed.gz -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/training.gz -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=5000 gen_training.pig'

scp gen_training_vw.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/training_vw.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param input='"$output_hdfs_dir"'/training.gz -param output='"$output_hdfs_dir"'/training_vw.gz -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=5000 gen_training_vw.pig'

ssh $nb 'hadoop fs -cat '"$output_hdfs_dir"'/training_vw.gz/*'  > training_vw.gz
rm vw.cache
#cat training_vw.txt | /mnt/shared06/ss06/ckang/local/local_intent/vw/vowpal_wabbit_6fix/vw --loss_function squared -b 28 --passes 100 --cache_file vw.cache --readable_model model.txt -f model -l 0.1
#cat training_vw.txt | vw --loss_function squared -b 28 --passes 100 --kill_cache --cache_file vw.cache --readable_model model.txt -f model -l 0.1
zcat training_vw.gz | vw --loss_function squared -b 28 --passes 5 --kill_cache --cache_file vw.cache --readable_model model.txt -f model -l 0.5

echo '1 |features best#buy' | vw -t -i model -p /dev/stdout
#echo '1 |features starbucks' | /mnt/shared06/ss06/ckang/local/local_intent/vw/vowpal_wabbit_6fix/vw -t --loss_function=logistic -i model -p /dev/stdout 

python avg_loss_default.py training_vw.txt
cut -d' ' -f1 training_vw.txt > t1
paste t1 test.txt > t2
python avg_loss_test.py t2

# evaluation
# test data
scp gen_test.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/test.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param input_unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param target_vector='"$target_vector"' -param queries_decomposed='"$output_hdfs_dir"'/queries_decomposed.gz -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/test.gz -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=5000 gen_test.pig'

scp eval.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/avg_sim'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/avg_sim -Dmapred.job.queue.name='"$queue"' -param input='"$output_hdfs_dir"'/test.gz -Dmapred.reduce.tasks=5000 eval.pig'

# get unit vector weights
ssh $nb 'hadoop fs -cat /projects/clickmodel/ckang/usmlr/gen_clicksim/unit_vector_truncated.gz/*|zcat|cut -f1' > all_units.txt
sed 's/ /#/g' all_units.txt | sed 's/:/#COLON#/g' | sed 's/:/#PIPE#/g' > modified_unit_names
awk -F\\t '{print "1 |features "$1}' modified_unit_names | vw -t -i model -p test.scores

echo '1 |features a#ereaibeae#akd' | vw -t -i model -p constant
set val_constant = `cat constant`

paste all_units.txt test.scores | awk -F\\t '{print $1"\t"$2-'"$val_constant"'}' > unit_weight.txt
scp unit_weight.txt $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/unit_weight.txt'
ssh $grid 'cd '"$gateway_working_dir"';hadoop fs -copyFromLocal unit_weight.txt '"$output_hdfs_dir"''

scp gen_test_with_weight.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/test_with_weight.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param unit_weight='"$output_hdfs_dir"'/unit_weight.txt -param queries_decomposed='"$output_hdfs_dir"'/queries_decomposed.gz -param test='"$output_hdfs_dir"'/test.gz -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/test_with_weight.gz -Dmapred.job.queue.name='"$queue"' -Dmapred.reduce.tasks=5000 gen_test_with_weight.pig'

scp eval_weight.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/avg_sim_weight'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/avg_sim_weight -Dmapred.job.queue.name='"$queue"' -param input='"$output_hdfs_dir"'/test_with_weight.gz -Dmapred.reduce.tasks=5000 eval_weight.pig'

# generate query vectors for new queries
scp predict_query_vector.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_vector_predicted.gz'
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_predictedvector_decomposed.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/query_vector_predicted.gz -param output_decomposed='"$output_hdfs_dir"'/query_predictedvector_decomposed.gz -Dmapred.job.queue.name='"$queue"' -param unit_weight='"$output_hdfs_dir"'/unit_weight.txt -param unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param query_vector=/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz -param query='"$output_hdfs_dir"'/query_no_qv -Dmapred.reduce.tasks=5000 predict_query_vector.pig'

# for white list queries
scp query.140M.q3.txt.gz $nb\:/grid/0/tmp/ckang
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query.140M.q3.txt.gz;hadoop fs -copyFromLocal /grid/0/tmp/ckang/query.140M.q3.txt.gz '"$output_hdfs_dir"''
scp find_query_no_qv.pig $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_no_qv.140M.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/query_no_qv.140M.gz -Dmapred.job.queue.name='"$queue"' -param qv=/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz -param queries='"$output_hdfs_dir"'/query.140M.q3.txt.gz -Dmapred.reduce.tasks=5000 find_query_no_qv.pig'

scp predict_query_vector.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_vector_predicted.140M.gz'
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_predictedvector_decomposed.140M.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/query_vector_predicted.140M.gz -param output_decomposed='"$output_hdfs_dir"'/query_predictedvector_decomposed.140M.gz -Dmapred.job.queue.name='"$queue"' -param unit_weight='"$output_hdfs_dir"'/unit_weight.txt -param unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param query_vector=/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz -param query='"$output_hdfs_dir"'/query_no_qv.140M.gz -Dmapred.reduce.tasks=5000 predict_query_vector.pig'

# for Jiliang
scp predict_query_vector.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_vector_predicted.jiliang.gz'
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_predictedvector_decomposed.jiliang.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/query_vector_predicted.jiliang.gz -param output_decomposed='"$output_hdfs_dir"'/query_predictedvector_decomposed.jiliang.gz -Dmapred.job.queue.name='"$queue"' -param unit_weight='"$output_hdfs_dir"'/unit_weight.txt -param unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param query_vector=/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz -param query='"$output_hdfs_dir"'/t_uniq_quries -Dmapred.reduce.tasks=5000 predict_query_vector.pig'

scp predict_query_vector.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_vector_predicted.jiliang.whitelist.gz'
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_predictedvector_decomposed.jiliang.whitelist.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/query_vector_predicted.jiliang.whitelist.gz -param output_decomposed='"$output_hdfs_dir"'/query_predictedvector_decomposed.jiliang.whitelist.gz -Dmapred.job.queue.name='"$queue"' -param unit_weight='"$output_hdfs_dir"'/unit_weight.txt -param unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param query_vector=/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz -param query='"$output_hdfs_dir"'/whitelist.uniq -Dmapred.reduce.tasks=5000 predict_query_vector.pig'

scp predict_query_vector.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_vector_predicted.jiliangQ3.gz'
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_predictedvector_decomposed.jiliangQ3.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/query_vector_predicted.jiliangQ3.gz -param output_decomposed='"$output_hdfs_dir"'/query_predictedvector_decomposed.jiliangQ3.gz -Dmapred.job.queue.name='"$queue"' -param unit_weight='"$output_hdfs_dir"'/unit_weight.txt -param unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param query_vector=/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz -param query='"$output_hdfs_dir"'/jiliangQ3.uniq -Dmapred.reduce.tasks=5000 predict_query_vector.pig'

# for Yuening
scp predict_query_vector.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_vector_predicted.yuening.gz'
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/query_predictedvector_decomposed.yuening.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/query_vector_predicted.yuening.gz -param output_decomposed='"$output_hdfs_dir"'/query_predictedvector_decomposed.yuening.gz -Dmapred.job.queue.name='"$queue"' -param unit_weight='"$output_hdfs_dir"'/unit_weight.txt -param unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param query_vector=/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz -param query='"$output_hdfs_dir"'/yuening.uniq -Dmapred.reduce.tasks=5000 predict_query_vector.pig'

# q3 local queries
set output_predicted = query_vector_predicted.q3local.gz
set query_set = /projects/clickmodel/ckang/usmlr/qrw_qvbased/q3_local_queries.txt

scp predict_query_vector.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/'"$output_predicted"''
ssh $grid 'cd '"$gateway_working_dir"';pig -useversion 0.11 -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/'"$output_predicted"' -Dmapred.job.queue.name='"$queue"' -param unit_weight='"$output_hdfs_dir"'/unit_weight.txt -param unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param query_vector=/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i2_google_truncated_20.gz -param query='"$query_set"' -Dmapred.reduce.tasks=5000 predict_query_vector.pig'

# generic q4 experiments
set output_predicted = query_vector_predicted.1201.gz
set query_set = /projects/clickmodel/ckang/usmlr/gen_clicksim/queries.1201.txt

scp predict_query_vector.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/'"$output_predicted"''
ssh $grid 'cd '"$gateway_working_dir"';pig -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/'"$output_predicted"' -param unit_weight='"$output_hdfs_dir"'/unit_weight.txt -param unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param query_vector=/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i3_google_truncated_20.gz -param query='"$query_set"' -Dmapred.reduce.tasks=5000 predict_query_vector.pig'

# generic q4 experiments
cut -f2 /nfs/mounts/b47846_mlrshare00/ynhu/title_sim/experiments/ib67/appen_ib67.quj > tmp
cut -f2 /nfs/mounts/b48224_mlrshare01/yst/data/appen_ib87k+wow.quj >> tmp
cut -f2 /nfs/mounts/b48224_mlrshare01/yst/ystEval/eval70020.quj >> tmp
cut -f2 /nfs/mounts/b48224_mlrshare01/yst/online_testdata/q3_u1k.2015q4ib87.quj >> tmp
cut -f2 /nfs/mounts/b48224_mlrshare01/yst/online_testdata/q3_u1k.localquery.explicit.quj >> tmp
cut -f2 /nfs/mounts/b48224_mlrshare01/yst/online_testdata/q3_u100.quj >> tmp
sort tmp | uniq > queries.1207.txt

set output_predicted = query_vector_predicted.1207.gz
set query_set = /projects/clickmodel/ckang/usmlr/gen_clicksim/queries.1207.txt

scp predict_query_vector.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/'"$output_predicted"''
ssh $grid 'cd '"$gateway_working_dir"';pig -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/'"$output_predicted"' -param unit_weight='"$output_hdfs_dir"'/unit_weight.txt -param unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param query_vector=/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i3_google_truncated_20.gz -param query='"$query_set"' -Dmapred.reduce.tasks=5000 predict_query_vector.pig'

set output_predicted = query_vector_predicted.question.gz
set output_decomposed = query_vector_decomposed.question.gz
set query_set = /projects/clickmodel/ckang/usmlr/gen_clicksim/queries.question.txt

scp predict_query_vector.pig $gateway_dir
scp $MLR_SCRIPTS/myudf.py $gateway_dir
ssh $grid 'hadoop fs -rm -r -skipTrash '"$output_hdfs_dir"'/'"$output_predicted"''
ssh $grid 'cd '"$gateway_working_dir"';pig -param output_hdfs_dir='"$output_hdfs_dir"' -param output='"$output_hdfs_dir"'/'"$output_predicted"' -param output_decomposed='"$output_hdfs_dir"'/'"$output_decomposed"' -param unit_weight='"$output_hdfs_dir"'/unit_weight.txt -param unit_vector='"$output_hdfs_dir"'/unit_vector_truncated.gz -param query_vector=/projects/clickmodel/ckang/usmlr/sim_v4/query_vector_i3_google_truncated_20.gz -param query='"$query_set"' -Dmapred.reduce.tasks=5000 predict_query_vector.pig'
