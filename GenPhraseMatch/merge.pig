DEFINE  POSTPROCESS `python postprocess.py` ship('postprocess.py');

%default out /projects/qrw/ruiqiang/GreedySelection-click/clickfeaturscore/merge
%default second '/projects/qrw/ruiqiang/GreedySelection-click/clickfeaturscore//thresholdcut/'
%default first '/projects/qrw/ruiqiang/Gemini/smtrewrite_*/decode-*-secondpass/postprocess/part*'
%default threshold '0.9'

A = load '$second'  using PigStorage('\t') ;

A = foreach A generate (chararray)$0 as (q:chararray), (chararray)$1 as (r:chararray), (float)$2 as score:float ;

B = load '$first' using PigStorage('\t') ;
B = foreach B generate (chararray)$0 as (q:chararray), (chararray)$1 as (r:chararray), (float)$3 as score:float ;


C = union A, B ;
C = group C by (q,r) ;


C = foreach C generate flatten(group) as (q:chararray ,r:chararray), MAX(C.$2) as score:float ;

-- set threshold to 0.9
C = filter C by score>=$threshold and q != r ;    

C = stream C through POSTPROCESS as (q:chararray, r:chararray, score:float) ;

C = order C by q, score DESC ;

rmf $out ;

store C into '$out/rewrites' using PigStorage('\t') ;

D1 = foreach C generate $0 as (q:chararray) ;
D2 = foreach C generate $1 as (q:chararray) ;
D = union D1,D2 ;
D = distinct D ;
D = order D by $0 ;

store D into '$out/qlasqueries' using PigStorage('\t') ;
