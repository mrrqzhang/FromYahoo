DEFINE  POSTPROCESS  `python postprocess-for-bpb.py` ship('postprocess-for-bpb.py','/homes/ruiqiang/MyPythonLib/mypythonlib.py') ;



%default input ''
%default out ''


-- rewrite
R = load '$input'  ;
-- as (q:chararray, r:chararray, score:float) ;



W = stream R through POSTPROCESS ;

store W into '$out' ;




