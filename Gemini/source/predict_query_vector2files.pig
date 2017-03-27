register 'kangudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

%default bt '/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000/normal-advertiser/'
%default wlist ''

%default input ''
%default output ''

%default unit_weight /projects/clickmodel/ckang/usmlr/gen_clicksim/unit_weight.txt
%default unit_vector /projects/clickmodel/ckang/usmlr/gen_clicksim/unit_vector_truncated.gz
%default query_vector /projects/clickmodel/ckang/usmlr/sim_20150826/query_qvec_out_combined

unit_weight = load '$unit_weight' as (unit:chararray,weight:chararray);
unit_vector = load '$unit_vector' as (unit:chararray,vector:chararray);
query_vector = load '$query_vector' as (query:chararray,vector:chararray);

QueryInput = load '$wlist' using PigStorage('\t')  ;

Query = foreach QueryInput generate (chararray)$0 as (query:chararray) ;

BtInput = load '$bt' using PigStorage('\t')  ;
Bidterm = foreach BtInput generate (chararray)$0 as (query:chararray) ; 

AllQuery = union Query, Bidterm ;
AllQuery = distinct AllQuery ;

-- generating query and its units (query segmentation)
query_unit = foreach AllQuery generate $0, flatten(myudf.gen_all_units($0));

JoinQuUvA1 = join query_unit by $1 LEFT OUTER, unit_vector by $0;
QueryQuUvA2 = foreach JoinQuUvA1 generate $0, $1, $3;
QvA3 = join QueryQuUvA2 by $1 LEFT OUTER, query_vector by $0;

-- query, unit, unit vector, query vector
query_unit_uv_qv = foreach QvA3 generate $0, $1, $2, $4;

-- query, unit, unit vector
query_unit_uv = stream query_unit_uv_qv through `awk -F"\t" '{if($3==""){print $1"\t"$2"\t"$4}else{print $1"\t"$2"\t"$3}}'` as (query:chararray,unit:chararray,v:chararray);
A4 = join query_unit_uv by $1 LEFT OUTER, unit_weight by $0;

-- query, unit, unit vector, unit weight
query_unit_uv_weight = foreach A4 generate $0, $1, $2, $4;


query_predictedvector_decomposed = foreach (group query_unit_uv_weight by $0)  generate group, flatten(myudf.predict_query_vector($1)) as (vector:chararray,decomposed:chararray);

/* store query_predictedvector_decomposed into '$output_decomposed'; */

query_predictedvector = foreach query_predictedvector_decomposed generate $0, $1;
query_predictedvector = filter query_predictedvector by $1 is not null;

/* try normalizing query (e.g., drop double quotes) */
normalized_query = foreach AllQuery generate $0, myudf.gen_normalized_query($0);
-- B1 = join normalized_query by $1, query_vector by $0;
normalized_query_vector = foreach (join normalized_query by $1, query_vector by $0)  generate $0, $3;

FinalQueryVector = join query_predictedvector by $0 LEFT OUTER, normalized_query_vector by $0;
FinalQueryVector = foreach FinalQueryVector generate $0, $1, $3;
FinalQueryVector = stream FinalQueryVector through `awk -F"\t" '{if($3!=""){print $1"\t"$3}else{print $1"\t"$2}}'` as (query:chararray,v:chararray);

rmf $output
store FinalQueryVector into '$output';
