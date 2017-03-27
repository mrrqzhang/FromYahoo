A = load '/projects/qrw/ruiqiang/Gemini/qbert-product-dump/' ;
A = foreach A generate (chararray)$0 as q:chararray ;
A = distinct A ;

B = load '/projects/qrw/ruiqiang/GeminiBuckets/nonWLdump' ;
B = filter B by $2 matches 'n1' and $3 matches 'PHRASE' ;

B = foreach B generate (chararray)$8 as b:chararray ;

rmf temp ;

store B into 'temp/totalq' ;

C = join B by b, A by q ;
store C into 'temp/matched' ;



