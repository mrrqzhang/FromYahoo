set grid = gwbl444n05.blue.ygrid.yahoo.com 
set gateway_working_dir = /homes/ckang/clksim_test
set gateway_dir = $grid\:$gateway_working_dir
set gateway_tmp = /grid/0/tmp/ckang

# input (query,url,clicks)
set input_qu_click = /projects/clickmodel/ckang/usmlr/qu_clicks_examples.gz 

set output_hdfs_dir = /projects/clickmodel/ckang/clksim_test 
set output_suffix = "_test"
set normalize_query = normalize_query # replace punctuation with a space or not
set click_threshold = 0 # minimum number of clicks to be meaningful
set max_terms_per_vector = 20

set start_from_doc_vector = no
# the following parameters are used when start_from_doc_vector=yes
set input_doc_vector = local/primary/id_dcat # when starting from doc vectors
set weight_given = no # whether a weight is specified for each item in input_doc_vector
