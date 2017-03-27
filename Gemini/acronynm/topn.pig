A = load 'temp/part*' using PigStorage('\t','-noschema') ;

B = foreach A generate (chararray)$0 as query:chararray, (double)REGEX_EXTRACT($4,'(.*) (.*) (.*)',1) as c:double ;


D = group B by query ;

D = foreach D {
    tmp = TOP(1,1,B) ;
    generate flatten(tmp) as  (query:chararray,  c:double) ;
}



D = order D by c DESC ;

rmf /projects/qrw/ruiqiang/Gemini/ttable-high-query
store D into '/projects/qrw/ruiqiang/Gemini/ttable-high-query' using PigStorage('\t','-noschema') ;
