
%default bidterm ''
%default phrases ''
%default out ''


bt = load '$bidterm' using PigStorage('\t') ;
bt = distinct bt ;
phrase = load '$phrases' using PigStorage('\t') ;


final = join phrase by $1, bt by $0;
final = foreach final generate $0,$1 ;


store final into '$out' ;


