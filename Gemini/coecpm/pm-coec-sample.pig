
%default Overflow 0.0001
%default CountDiscount 3
%default output '/projects/qrw/ruiqiang/coec-phrasematch/rbo-train-data'

DEFINE CoecDiscountMean(INPUTBID) RETURNS BidtermAverage
{
	Temp = foreach (group $INPUTBID by bidterm parallel 1000) generate group as bidterm:chararray, SUM($INPUTBID.value)/COUNT($INPUTBID) as mean:double, COUNT($INPUTBID) as totalcnt:long, flatten($INPUTBID.value) as value:double   ;

	Temp = foreach Temp generate bidterm, mean, totalcnt, (mean-value)*(mean-value) as diff:double ; -- discount all zero cases

	Temp = foreach (group Temp by (bidterm,mean,totalcnt)) generate flatten(group) as (bidterm:chararray,mean:double,totalcnt:long), SQRT(SUM(Temp.diff)/(group.totalcnt-1+$Overflow)) as sd:double ; -- standard deviation   

	Temp = foreach Temp generate bidterm, mean, totalcnt, sd, (sd+$CountDiscount)/SQRT(totalcnt) as se:double ; -- standard error

	$BidtermAverage = foreach Temp generate bidterm, mean-se as se_mean:double, mean as mean:double, totalcnt, sd, se ;

};


clickdata = load '/tmp/cb_clkb/kmahen/modeling_data_v7_2/*/desktop/*' using PigStorage('\t','-schema') ;

clickdata = foreach clickdata generate ModelingData::ModelingDataWithDwellTime::ModelingData::phraseCanonQuery as phraseCanonQuery:chararray,
				ModelingData::ModelingDataWithDwellTime::ModelingData::ImpressionsWithCF::bt_ec as ec:double,
				ModelingData::ModelingDataWithDwellTime::ModelingData::ImpressionsWithCF::bt_coec as coec:double,
				ModelingData::ModelingDataWithDwellTime::ModelingData::ImpressionsWithCF::q_ec as qec:double,
				ModelingData::ModelingDataWithDwellTime::ModelingData::ImpressionsWithCF::q_coec as qcoec:double,
				AdditionalData::advertiser_bidded_phrase_canon_term as pcanon:chararray,
				AdditionalData::bidded_variant_canon_term as vcanon:chararray ;

-- bidcoec = foreach (filter clickdata by qcoec != -1)  generate vcanon as bidterm:chararray, qcoec as value:double ;
bidcoec = foreach (filter clickdata by qcoec != -1)  generate phraseCanonQuery as bidterm:chararray, qcoec as value:double ;
bidcoecMean = CoecDiscountMean(bidcoec);

bidec = foreach (filter clickdata by qec != -1)  generate phraseCanonQuery as bidterm:chararray, qec as value:double ;
bidecMean = CoecDiscountMean(bidec);


rmf $output;

store bidcoecMean into '$output/bidtermcoec' using PigStorage('\t','-schema') ;
store bidecMean into '$output/bidtermec' using PigStorage('\t','-schema') ;

testquery = load 'rbo-train.txt' using PigStorage('\t','-noschema') as (query:chararray, bidterm:chararray, grade:chararray, rel:chararray) ;

FilterQuery = foreach (join testquery by bidterm, bidcoecMean by bidterm, bidecMean by bidterm) generate 
		testquery::query as query:chararray,
                testquery::bidterm as bidterm:chararray,
                testquery::grade as grade:chararray,
                testquery::rel as rel:chararray,
                bidcoecMean::mean as mean:double,
--                bidcoecMean::se_mean as se_mean:double,
--                bidcoecMean::variance as variance:double ;
		bidecMean::mean as ec_mean:double;

store FilterQuery into '$output/samples' using PigStorage('\t','-schema') ;



