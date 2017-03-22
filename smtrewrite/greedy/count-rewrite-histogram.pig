%defaut input ''

A = load '$input' ;

A = foreach A generate (chararray)$0 as (q:chararray) ;

A = group A by q ;

A = foreach A generate COUNT(A) as rwcnt:long ;

A = group A by rwcnt ;

A = foreach A generate rwcnt, COUNT(A) as cntcnt:long ;  

rmf $out ;

store A into '$out' ;
 

