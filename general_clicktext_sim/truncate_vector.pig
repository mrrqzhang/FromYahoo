DEFINE CMD `python truncate_vector.py $max_terms` ship('$gateway_working_dir/truncate_vector.py');
A = load '$output_hdfs_dir/$input' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:chararray);
B = stream A through CMD;
store B into '$output_hdfs_dir/$output';
