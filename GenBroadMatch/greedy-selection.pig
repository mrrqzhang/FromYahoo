REGISTER smt_udf.py USING jython AS pyudf ;

DEFINE  GETTOKEN `python greedy-selection-token.py` ship('greedy-selection-token.py');


%default inputqry ''
%default inputbt ''
%default out ''
%default threshold 100000000  -- 100M

DEFINE GetWordIndex(INPUT_DIR) RETURNS WORDMAP
{
	A = load '$INPUT_DIR' using PigStorage('\t') ;
	A = foreach A generate (chararray)$0 as q, (chararray)$1 as r ;

	A = stream A through GETTOKEN as (w:chararray, q:chararray) ;

	$WORDMAP  = distinct A ;

};

DEFINE GetWordIndex2(INPUT_DIR) RETURNS WORDMAP
{
        A = load '$INPUT_DIR' using PigStorage('\t') ;
        A = foreach A generate (chararray)$0 as q, (chararray)$0 as r ;

        A = stream A through GETTOKEN as (w:chararray, q:chararray) ;

        $WORDMAP = distinct A ;


};

DEFINE GetQryBidterm(Query,Bidterm,TokenList) RETURNS QryBt
{
   QueryTokenUsed = foreach (join $Query by w, $TokenList by w) generate $Query::w as w:chararray, $Query::q as q:chararray ;
   BtTokenUsed = foreach (join $Bidterm by w, $TokenList by w) generate $Bidterm::w as w:chararray, $Bidterm::q as q:chararray ;
--   QueryTokenUsed = order QueryTokenUsed by w  ;
--   BtTokenUsed = order BtTokenUsed by w  ;
   QryBtJoin =  join QueryTokenUsed by w, BtTokenUsed by w  USING  'skewed' parallel 4000  ;
   QryBtJoin = foreach  QryBtJoin  generate QueryTokenUsed::q as q:chararray, BtTokenUsed::q as bt:chararray ;
   $QryBt = distinct QryBtJoin ;
}


DEFINE GetQryBidtermLarge(Query,Bidterm,TokenList) RETURNS QryBt
{
   QueryTokenUsed = foreach (join $Query by w, $TokenList by w using 'replicated') generate $Query::w as w:chararray, $Query::q as q:chararray ;
   BtTokenUsed = foreach (join $Bidterm by w, $TokenList by w using 'replicated') generate $Bidterm::w as w:chararray, $Bidterm::q as q:chararray ;
--   QueryTokenUsed = order QueryTokenUsed by w  ;
--   BtTokenUsed = order BtTokenUsed by w  ;
   QryBtJoin =  join BtTokenUsed by w, QueryTokenUsed by w  USING  'replicated' parallel 4000  ;
   QryBtJoin = foreach  QryBtJoin  generate QueryTokenUsed::q as q:chararray, BtTokenUsed::q as bt:chararray ;
   $QryBt = distinct QryBtJoin ;
}
   
DEFINE GetFilteredBidterm(Bidterm, TokenFilted) RETURNS SubsetBidterm
{

  Tokens = foreach $TokenFilted generate w as w:chararray ;
  BidtermJoin = join $Bidterm by w, Tokens by w using 'replicated' parallel 4000 ;
  BidtermJoin = foreach BidtermJoin generate (chararray)$1 as q:chararray, $0 as w:chararray ;
  BidtermGroup = group BidtermJoin by q parallel 4000 ;
  BidtermOut = filter BidtermGroup by COUNT(BidtermJoin) == pyudf.wordcount($0) ;
  $SubsetBidterm = foreach BidtermOut generate flatten(BidtermJoin.w) as w:chararray, $0 as q:chararray ; 
}

 
rmf $out ;

QueryToken = GetWordIndex('$inputqry') ;
BtToken = GetWordIndex2('$inputbt') ;

QueryTokenCnt = foreach (group QueryToken by w) generate group as w:chararray, COUNT(QueryToken) as cnt:long ;
BtTokenCnt = foreach (group BtToken by w) generate group as w:chararray, COUNT(BtToken) as cnt:long ;

-- to remove high cnt tokens to avoid memory overflow
TokenTotal = foreach(join QueryTokenCnt by w, BtTokenCnt by w) generate QueryTokenCnt::w as w:chararray, QueryTokenCnt::cnt*BtTokenCnt::cnt as cnt:long ;
-- K3 = filter K3 by cnt<1000000000 ;  --1G 
TokenUsed = filter TokenTotal by cnt<$threshold ; -- choose 100M 

TokenFilted = filter TokenTotal by cnt>=$threshold ;

store TokenFilted into '$out/filteredtokens' using PigStorage('\t','-schema') ;

-- BtFiltered = GetFilteredBidterm(BtToken, TokenFilted) ;

-- store BtFiltered into '$out/BtFiltered' using PigStorage('\t','-schema') ;

-- QryBtJoinFilter = foreach (join QueryToken by w, BtFiltered by w using 'skewed' parallel 4000) generate QueryToken::q as q:chararray, BtFiltered::q as bt:chararray ; 

QryBtJoin = GetQryBidterm(QueryToken,BtToken, TokenUsed) ;


-- QryBtJoin = union QryBtJoin,QryBtJoinFilter ;
QryBtJoin = distinct QryBtJoin ;

QryBtJoin = order QryBtJoin by q ;
store QryBtJoin into '$out/qrw' using PigStorage('\t','-schema') ;



 
