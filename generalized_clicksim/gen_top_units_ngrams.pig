register 'myudf.py' using org.apache.pig.scripting.jython.JythonScriptEngine as myudf;

A = load '$target_vector' as (q:chararray);

n1gram = foreach A generate FLATTEN(myudf.gen_ngrams($0,1)) as unit;
B1 = group n1gram by $0;
C1 = foreach B1 generate group, COUNT(n1gram);
D1 = order C1 by $1 DESC;
E1 = limit D1 5000000;

n2gram = foreach A generate FLATTEN(myudf.gen_ngrams($0,2)) as unit;
B2 = group n2gram by $0;
C2 = foreach B2 generate group, COUNT(n2gram);
D2 = order C2 by $1 DESC;
E2 = limit D2 5000000;

n3gram = foreach A generate FLATTEN(myudf.gen_ngrams($0,3)) as unit;
B3 = group n3gram by $0;
C3 = foreach B3 generate group, COUNT(n3gram);
D3 = order C3 by $1 DESC;
E3 = limit D3 2000000;

n4gram = foreach A generate FLATTEN(myudf.gen_ngrams($0,4)) as unit;
B4 = group n4gram by $0;
C4 = foreach B4 generate group, COUNT(n4gram);
D4 = order C4 by $1 DESC;
E4 = limit D4 1000000;

n5gram = foreach A generate FLATTEN(myudf.gen_ngrams($0,5)) as unit;
B5 = group n5gram by $0;
C5 = foreach B5 generate group, COUNT(n5gram);
D5 = order C5 by $1 DESC;
E5 = limit D5 500000;

S1 = union E1, E2;
S2 = union S1, E3;
S3 = union S2, E4;
S4 = union S3, E5;

store S4 into '$output';
