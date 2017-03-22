A1 = load '$input1' as (unit:chararray);
A2 = load '$input2' as (unit:chararray);
A3 = union A1, A2;
units = distinct A3;

B = load '$input_vector' as (q:chararray,v:chararray);
C = join B by $0 LEFT OUTER, units by $0;
D = filter C by $2 is null;

store D into '$output';
