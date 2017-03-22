DEFINE EXTRACT `python minimize-table.py` ship('minimize-table.py'); ;

%default smtroot ''
%default out  'temp'


-- main idea: the python scripts generate (key,value). Value is (source, target) pairs but key is the value after removing same words from source and target. If the key has been existed in other targets, that is, if this key has been as the same as the other key's value, then remove this translation pairs. to do this,
-- step 1: join all keys with values
-- step 2: from the join, got all keys that is the same as values.
-- step 3: remove values that its key == key in step2. 
-- step 4: keep values that its key not in step 2;

-- original table
SmtTable = load '$smtroot' using PigStorage('\t','-noschema') ;


-- cut smt table by query length and score threshold
MiniSmt = stream SmtTable through EXTRACT as (key:chararray, value:chararray, source:chararray, target:chararray, smt:double,  translation:chararray); -- smt: loglinear score

-- clean duplication due to multiple translation table ( key: reduced part of query_rewrite, value: query_rewrite )
MiniSmtDedup = foreach (group MiniSmt by value parallel 200) {
     tmp = order MiniSmt by smt DESC ;
     top = limit tmp 1 ;
     generate flatten (top)  as (key:chararray, value:chararray, source:chararray, target:chararray, smt:double,  translation:chararray) ; #source: query, target:rewrite
}

-- if two key value pair such as
-- (q1_r1 q_r) and (q_r q_r) then remove (q_r) because (q1_r1) is a short extraction
QryRwtKey = foreach MiniSmtDedup generate value as (key2:chararray) ; -- B has two type: value==key and value!=key

QryRwtKey = distinct QryRwtKey ;

-- remove keys from MiniSmtDedup that can be reduced by minimization  
QryRwtKeySameValueKey = foreach (join MiniSmtDedup by key, QryRwtKey by key2) generate $0 as (key2:chararray) ;


QryRwtKeySameValueKey = distinct QryRwtKeySameValueKey ;

AllKeyGrp = cogroup MiniSmtDedup by key outer, QryRwtKeySameValueKey by key2 outer parallel 2000 ;


-- all translations whose key not in QryRwtKeySameValueKey
NonSameValueKey = filter AllKeyGrp by IsEmpty(QryRwtKeySameValueKey) ; 

-- keep values  whose key not in B
ValueFromNonSameValueKey = foreach NonSameValueKey generate flatten(MiniSmtDedup.$1) as value:chararray ; 

RemainSameValueKey = filter (cogroup QryRwtKeySameValueKey by $0 outer, ValueFromNonSameValueKey by $0 outer parallel 2000) by isEmpty(QryRwtKeySameValueKey) as value:chararray  ;



-- all values should be saved
AllValue = union RemainSameValueKey, ValueFromNonSameValueKey ;

 
CoAllValueSmt = cogroup AllValue by $0 inner,MiniSmtDedup by $1 inner parallel 200 ; -- join A and D by values

AllValueSmt = foreach CoAllValueSmt generate flatten(MiniSmtDedup)  as ( key:chararray, value:chararray,source:chararray,target:chararray, smt:double, translation:chararray) ;


AllValueSmt = foreach (group AllValueSmt by source parallel 200 ){
        tmp = order AllValueSmt by smt DESC ; 
        top = limit tmp 60 ;   -- only use top 60
        generate flatten (top.(source,smt,translation))  as ( source:chararray, smt:double, translation:chararray) ;
}



AllValueSmt = foreach AllValueSmt generate 'PHRASETABLE' as (tag:chararray), translation as ( translation:chararray) ;


AllValueSmt = order AllValueSmt by translation ASC parallel 1 ;

rmf $out;
store AllValueSmt into '$out' using PigStorage('\t','-noschema') ;
