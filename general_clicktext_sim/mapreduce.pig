DEFINE CMD `python $mapper` ship('$gateway_working_dir/$mapper');

A = load '$input' USING PigStorage('\t');
B = stream A through CMD;
store B into '$output';

