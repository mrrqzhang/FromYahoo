%default input ''
%default qlasout 'qlas'
%default scoreout ''

%default MinScore 0.8 

qrw = load '$input' ;
qrw = foreach qrw generate (chararray)$0 as query:chararray, (chararray)$1 as bidterm:chararray, (double)$2 as relscore:double ;
qrw = filter qrw by relscore >= $MinScore ;

rmf $scoreout
store qrw into '$scoreout' ;

D1 = foreach qrw generate $0 as (q:chararray) ;
D2 = foreach qrw generate $1 as (q:chararray) ;
D = union D1,D2 ;
D = distinct D ;
D = order D by $0 ;

rmf $qlasout ;

store D into '$qlasout' using PigStorage('\t') ;
