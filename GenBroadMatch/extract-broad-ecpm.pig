%default out '/projects/qrw/ruiqiang/PhraseMatch/PhraseBidtermEcpm'
%default input '/tmp/data_for_hong_new/' 
%default MaxBidterm 20000000
%default CountDiscount 3
%default VarianceDiscount 9.0*$CountDiscount -- use 9.0 to lower low-freq bidterm's ecpm
%default Overflow 0.0001

QuadTbl = load '$input' using PigStorage('\t','-schema') ;
BidtermEcpm = foreach QuadTbl generate 
	phraseCanonicalBidTerm as bidterm:chararray,
	bidMatchType as matchType:chararray,
	ecpm as ecpm:double ; 

BidtermEcpmMt = filter BidtermEcpm by ( matchType ==  'BROAD' ) ;

BidtermEcpmMt = foreach BidtermEcpmMt generate bidterm, ecpm ;

Temp = foreach (group BidtermEcpmMt by bidterm parallel 1000) generate group as bidterm:chararray, SUM(BidtermEcpmMt.ecpm)/COUNT(BidtermEcpmMt) as mean:double, COUNT(BidtermEcpmMt) as totalcnt:long, flatten(BidtermEcpmMt.ecpm) as ecpm:double   ;

Temp = foreach Temp generate bidterm, mean, totalcnt, (mean-ecpm)*(mean-ecpm) as diff:double ; -- discount all zero cases

Temp = foreach (group Temp by (bidterm,mean,totalcnt)) generate flatten(group) as (bidterm:chararray,mean:double,totalcnt:long), SQRT(SUM(Temp.diff)/(group.totalcnt-1+$Overflow)) as variance:double ;   

Temp = foreach Temp generate bidterm, mean, totalcnt, variance, (variance+$CountDiscount)/SQRT(totalcnt) as se:double ; -- standard error

BidtermEcpmAverage = foreach Temp generate bidterm, mean-se as ecpm:double, mean as mean:double, totalcnt, variance, se ;
BidtermEcpmAverage = order BidtermEcpmAverage by ecpm DESC ;
-- BidtermEcpmAverage = order BidtermEcpmAverage by mean DESC ; --nose
BidtermEcpmTop = limit BidtermEcpmAverage $MaxBidterm ;
rmf $out
store BidtermEcpmTop into '$out' ;

