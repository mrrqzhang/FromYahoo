
DEFINE  DETECTOUTLIER `python detect-outlier.py` ship('detect-outlier.py');
%default output 'temp' ;

%default unit_weight /projects/clickmodel/ckang/usmlr/gen_clicksim/unit_weight.txt
%default unit_vector /projects/clickmodel/ckang/usmlr/gen_clicksim/unit_vector_truncated.gz
%default query_vector /projects/clickmodel/ckang/usmlr/sim_20150826/query_qvec_out_combined

A = load '$query_vector' as (query:chararray, fv:chararray) ;

B = stream A through DETECTOUTLIER  as (query:chararray, fv:chararray) ;

rmf $output ;
store B into '$output' ;


