DEFINE CMD `python detect_loc_part.py city_state.txt` ship('$gateway_working_dir/detect_loc_part.py','$gateway_working_dir/city_state.txt');

A = load 'usmlr/sim/qu_click_with_google.gz' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:int);
B = stream A through CMD AS (f1:chararray,f2:chararray,f3:int);
C = group B by (f1,f2);
D = foreach C generate group.f1, group.f2, SUM(B.f3);
store D into 'usmlr/doc_location/qu_click.gz';
