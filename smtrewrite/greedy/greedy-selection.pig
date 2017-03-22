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
QueryTokenUsed = foreach (join QueryToken by w, TokenUsed by w) generate QueryToken::w as w:chararray, QueryToken::q as q:chararray ;
BtTokenUsed = foreach (join BtToken by w, TokenUsed by w) generate BtToken::w as w:chararray, BtToken::q as q:chararray ;

QryBtJoin = join QueryTokenUsed by w, BtTokenUsed by w  USING 'skewed' parallel 4000   ;
QryBtJoin = foreach  QryBtJoin  generate QueryTokenUsed::q as q:chararray, BtTokenUsed::q as bt:chararray ;
QryBtJoin = distinct QryBtJoin ;
QryBtJoin = order QryBtJoin by q ;
store QryBtJoin into '$out/qrw' using PigStorage('\t','-schema') ;



 
