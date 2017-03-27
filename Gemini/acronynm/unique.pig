A = load 'temp/part*' using PigStorage('\t','-noschema') ;
B = foreach A generate $0, REGEX_EXTRACT($4,'(.*) (.*) (.*)',1) ;
C =foreach A generate $1,REGEX_EXTRACT($4,'(.*) (.*) (.*)',2) ;
D= union B,C ;
D = distinct D ;
D = order D by $1 ;
rmf /projects/qrw/ruiqiang/Gemini/ttable-high-query
store D into '/projects/qrw/ruiqiang/Gemini/ttable-high-query' using PigStorage('\t','-noschema') ;
