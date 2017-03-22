REGISTER /homes/ruiqiang/pythonlib/myfunc.py USING jython AS pyudf ;

%default out '/projects/qrw/ruiqiang/PhraseGenGoldenSet2/OnlyNewPhrases'
%default input1 '/projects/qrw/ruiqiang/DirForPhraseGolden/phrasematchgolenset.txt'
%default input2 '/projects/qrw/ruiqiang/PhraseGenGoldenSet2/highrel/withscore'


dataFrom1 = load '$input1' using PigStorage('\t','-noschema')  ;
dataFrom1 = foreach dataFrom1 generate (chararray)$0 as query:chararray, (chararray)$1 as bidterm:chararray ;

dataFrom1 = foreach dataFrom1 generate query, flatten(pyudf.tokenize(bidterm,'_')) as bidterm:chararray ;

dataFrom2 = load '$input2' using PigStorage('\t','-noschema')  ;
dataFrom2 = foreach dataFrom2 generate (chararray)$0 as query:chararray, (chararray)$1 as bidterm:chararray ;

dataFrom2 = foreach dataFrom2 generate query, flatten(pyudf.tokenize(bidterm,'_')) as bidterm:chararray ;

groupinput = cogroup dataFrom1 by ($0,$1) outer, dataFrom2 by ($0,$1) outer ;

filter1from2 = filter groupinput by IsEmpty(dataFrom2)==false and IsEmpty(dataFrom1)==true ;

filter1from2 = foreach filter1from2 generate flatten(dataFrom2) ;

filter2from1 = filter groupinput by IsEmpty(dataFrom2)==true and IsEmpty(dataFrom1)==false ;

filter2from1 = foreach filter2from1 generate flatten(dataFrom1) ;
rmf $out ;

store filter1from2 into '$out/filter1from2' using PigStorage('\t') ;

store filter2from1 into '$out/filter2from1' using PigStorage('\t') ;
