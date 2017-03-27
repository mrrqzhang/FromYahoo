variant_line = LOAD 'pm-bing-raw-phrases.txt' AS (
 spellQuery:chararray,
 rawBidTerm:chararray);


post_canon = FOREACH variant_line GENERATE 
    *,
    (chararray)com.yahoo.curveball.common.GetPhraseCanon('./canon/canon', spellQuery) as phraseCanonQuery,
    (chararray)com.yahoo.curveball.common.GetVariantCanon('./canon/canon', spellQuery) as variantCanonQuery,
    (chararray)com.yahoo.curveball.common.GetPhraseCanon('./canon/canon', rawBidTerm) as phraseCanonBidTerm,
    (chararray)com.yahoo.curveball.common.GetVariantCanon('./canon/canon', rawBidTerm) as variantCanonBidTerm;


rmf temp ;

STORE post_canon into  'temp' USING PigStorage();
