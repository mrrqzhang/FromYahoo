DEFINE  FINDWOEID  `python find-woeid.py` ship('find-woeid.py') ;



%default input ''
%default out ''
%default qlas ''

R = load '$input'  ;
-- as (q:chararray, r:chararray, score:float) ;

R = foreach R generate (chararray)$0 as q:chararray, (chararray)$1 as r:chararray, (float)$2 as score:float ;

W = load '$qlas' ;

W = stream W through FINDWOEID as (q:chararray, citywoe:chararray,statewoe:chararray, countrywoe:chararray) ;


D = foreach (cogroup R by q outer, W by q outer ) {
    generate flatten(R) as (q:chararray, r:chararray, score:float), flatten(( IsEmpty(W) ? TOBAG(('null','null','null')) : W.(citywoe,statewoe,countrywoe ))) as (citywoeq:chararray,statewoeq:chararray, countrywoeq:chararray) ;
}

D = foreach (cogroup D by r outer, W by q outer) {
    generate flatten(D) as (q:chararray, r:chararray, score:float,citywoeq:chararray,statewoeq:chararray, countrywoeq:chararray), flatten(( IsEmpty(W) ? TOBAG(('null','null','null')) : W.(citywoe,statewoe,countrywoe) )) as (citywoer:chararray,statewoer:chararray, countrywoer:chararray) ;
}

E = filter D by (citywoeq is null or citywoeq=='null' or citywoer is null or citywoer=='null' or citywoeq==citywoer) and (statewoeq is null or statewoeq=='null' or statewoer is null or statewoer=='null' or statewoeq==statewoer) and (countrywoeq is null or countrywoeq=='null' or countrywoer is null or countrywoer=='null' or countrywoeq==countrywoer) ;

E = order E by q, score DESC ;


-- F = filter D by (citywoeq!='null' and citywoer!='null' and citywoeq!=citywoer) or (statewoeq!='null' and statewoer!='null' and statewoeq!=statewoer)  or (countrywoeq!='null' and countrywoer!='null' and countrywoeq!=countrywoer) ;

rmf $out ;
store E into '$out' ;

