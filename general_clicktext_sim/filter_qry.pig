A = load '$input' USING PigStorage('\t');
B = load '$query_file' USING PigStorage('\t');
C = join A by $0, B by $0;
store C into '$output';
