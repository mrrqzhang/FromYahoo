register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

unit_vector = load '$unit_vector' as (unit:chararray,vector:chararray);
query_vector = load '$query_vector' as (query:chararray,vector:chararray);

query = load '$query' as (query:chararray);

query_unit = foreach query generate $0, flatten(myudf.gen_all_units($0));

A1 = join query_unit by $1 LEFT OUTER, unit_vector by $0;
A2 = foreach A1 generate $0, $1, $3;
A3 = join A2 by $1 LEFT OUTER, query_vector by $0;
query_unit_uv_qv = foreach A3 generate $0, $1, $2, $4;
query_unit_uv = stream query_unit_uv_qv through `awk -F"\t" '{if($3==""){print $1"\t"$2"\t"$4}else{print $1"\t"$2"\t"$3}}'` as (query:chararray,unit:chararray,v:chararray);
A4 = group query_unit_uv by $0;

query_predictedvector_decomposed = foreach A4 generate group, flatten(myudf.predict_query_vector($1,'$missing_term_vector')) as (vector:chararray,decomposed:chararray);
query_predictedvector = foreach query_predictedvector_decomposed generate $0, $1;
A6 = filter query_predictedvector by $1 is not null;

/* try normalizing query (e.g., drop double quotes) */

normalized_query = foreach query generate $0, myudf.gen_normalized_query($0);
B1 = join normalized_query by $1, query_vector by $0;
B2 = foreach B1 generate $0, $3;

C1 = join A6 by $0 LEFT OUTER, B2 by $0;
C2 = foreach C1 generate $0, $1, $3;
C3 = stream C2 through `awk -F"\t" '{if($3!=""){print $1"\t"$3}else{print $1"\t"$2}}'` as (query:chararray,v:chararray);

store C3 into '$output';

