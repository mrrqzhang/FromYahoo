A = load '/projects/qrw/ruiqiang/GeminiBuckets/alldesktop/' using PigStorage('\t','-schema') ;
A = foreach A generate phraseCanonQuery ;
A = foreach (group A by phraseCanonQuery) generate group as phraseCanonQuery, COUNT(A) as cnt:long;
A = order A by cnt DESC ;
rmf /projects/qrw/ruiqiang/querysample/ ;
store A into '/projects/qrw/ruiqiang/querysample/' ;
