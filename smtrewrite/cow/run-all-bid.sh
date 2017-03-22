#generate phrase match

sh dopig.sh all_bid_term_blackadvertiser_group_id_phrase.pig "-p COW_DATE=201601050000 root=/projects/qrw/ruiqiang/all_bid_terms_phrase/201601050000"

#generate mean bid
#sh dopig.sh all_bid_term_blackadvertiser_group_id.pig "-p COW_DATE=201512050000 -p root=/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201512050000"

#generate advertiser id and adgroup id
#sh dopig.sh all_bid_term_blackadvertiser_group_id.pig "-p COW_DATE=201512050000 -p root=/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201512050000"

#rerun using new codes
#sh dopig.sh all_bid_term_blackadvertiser.pig "-p COW_DATE=201511160000 -p root=/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000"

#sh dopig.sh all_bid_term_blackadvertiser.pig "-p COW_DATE=201511160000 -p root=/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_status_off/201511160000"


#compare cow for different date
#sh dopig.sh all_bid_term_blackadvertiser.pig "-p COW_DATE=201511160000 -p root=/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_binlu/201511160000"

#sh dopig.sh all_bid_term.pig "-p COW_DATE=201510120000 -p root=/projects/qrw/ruiqiang/all_bid_terms_with_matchtype"
#sh dopig.sh all_bid_term_blackadvertiser.pig "-p COW_DATE=201511110000 -p root=/projects/qrw/ruiqiang/all_bid_terms_use_blacklist_advertiser_status_on"
