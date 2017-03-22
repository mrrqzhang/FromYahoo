DEFINE  RECAP `python recap-train-id.py` ship('recap-train-id.py'); 

REGISTER smt_udf.py USING jython AS pyudf ;


%default input ''
%default out  ''


A = load '$input' using PigStorage('\t','-noschema') as (adgid:chararray, bt1:chararray, bt2:chararray) ;

B = foreach A generate adgid as adgid:chararray ;

B = foreach (group B by adgid) {
      generate group as adgid:chararray, COUNT(B) as count:long ;
}


B = stream B through RECAP as (oid:chararray, nid:chararray, count:long) ;

D = foreach B generate nid,count ;

D = distinct D ;

D = group D ALL ;

D = foreach D  generate flatten(pyudf.map_adgroupid((BagToTuple(D))))  as (nid:chararray, numid:int)  ;

B = join B by nid, D by nid ;

B = foreach B generate oid as oid:chararray, numid as numid:int ;




rmf $out/oid-nid-index;
store B into '$out/oid-nid-index' using PigStorage('\t','-noschema') ;


C = join A by adgid, B by oid parallel 1000 ;

C = foreach C generate B::numid as numid:int, A::bt1 as bt1:chararray, A::bt2 as  bt2:chararray ;

-- C = ORDER C BY numid, bt1 PARALLEL 15;

rmf $out/data;
store C into '$out/data' using PigStorage('\t','-noschema') ;
