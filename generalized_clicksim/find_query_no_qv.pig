A = load '$queries' as (q:chararray);
B = load '$qv' as (q:chararray,v:chararray);
C = join A by $0 LEFT OUTER, B by $0;
D = filter C by $1 is null;
E = foreach D generate $0;
store E into '$output';
