%default input '/tmp/cb_nctr/ruiqiang/queryadgroup/qrw'
%default out '/tmp/cb_nctr/ruiqiang/queryadgroup/qadscore'
%default bidterms '/user/ruiqiang/ruiqiang_gemini/bidtermpairs_adgroup/'  

A = load '$bidterms' using PigStorage('\t','-noschema') ; -- as (tmp1:chararray,adgroup:chararray, tmp2:chararray, tmp3:chararray, bt:chararray) ;
-- A = filter A by (chararray)$9 matches 'BROAD' ;

A = foreach A generate (chararray)$5 as adgroup:chararray, (chararray)$10 as bt:chararray ;

B = load '$input' using PigStorage('\t', '-noschema') as (query:chararray,  rw:chararray,  score:double) ;

-- p(r|q)p(b|r)

C = join B by rw, A by bt parallel 2000 ;
C = foreach C generate $0 as query:chararray, $3 as adgroup:chararray, $4 as bt:chararray, $2  as rwscore:double, EXP($2) as exprwscore:double ;
C = group C by (query,adgroup) parallel 2000 ;
C = foreach C generate flatten(C) as ( query:chararray, adgroup:chararray,bt:chararray, rwscore:double,exprwscore:double), COUNT(C) as rwcount:long, SUM(C.rwscore) as summatchedrwscore:double, SUM(C.exprwscore) as sumexpscore:double, LOG(SUM(C.exprwscore)) as logsumexpscore:double, SUM(C.rwscore)/(double)COUNT(C) as averagematchedrwscore:double ;

D = group A by adgroup ;
D = foreach D generate group as adgroup:chararray, COUNT(A) as btnum:long ;

E = cogroup C by adgroup, D by adgroup parallel 100 ;
E = foreach E generate flatten(C) as (query:chararray, adgroup:chararray,bt:chararray, rwscore:double , exprwscore:double, rwcount:long, summatchedrwscore:double, sumexpscore:double, logsumexpscore:double, averagematchedrwscore:double), flatten(D.btnum) as btnum:long;
E = foreach E generate query as query:chararray, adgroup as adgroup:chararray, bt as bt:chararray, rwscore as rwscore:double, exprwscore as exprwscore:double, rwcount as rwcount:long, summatchedrwscore as summatchedrwscore:double, sumexpscore as sumexpscore:double, logsumexpscore as logsumexpscore:double,averagematchedrwscore as averagematchedrwscore:double, btnum as btnum:long,  summatchedrwscore/(double)btnum as averageadgroup:double ;

E = order E by query, logsumexpscore DESC , rwscore DESC parallel 100;

store E into '$out' using PigStorage('\t','-schema');
