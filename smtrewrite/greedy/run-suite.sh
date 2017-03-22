#remove nav query from travel
sh suite-greedy.sh -s 8 -e 8 -r  /projects/qrw/ruiqiang/GreedySelection-click/

#sh suite-greedy.sh -s 8 -e 8 -r  /projects/qrw/ruiqiang/GreedySelection-travel/

#run travel 
#sh suite-greedy.sh -s 3 -e 7 -r  /projects/qrw/ruiqiang/GreedySelection-travel/

#join advertiser, re-run all results, remove merge with old
#sh suite-greedy.sh -s 5 -e 7 -r  /projects/qrw/ruiqiang/GreedySelection-click/

#rerun step 3 to generate score, but I used 100M threshold. before it used excluded.
#sh suite-greedy.sh -s 3 -e 3 -r  /projects/qrw/ruiqiang/GreedySelection-click/ 

#sh suite-greedy.sh -s 2 -e 7 -b /projects/qrw/ruiqiang/selected-bidterm-clickfeature/ -r /projects/qrw/ruiqiang/GreedySelection-all-verticals/ -i /projects/qrw/ruiqiang/Gemini/AllBidTerms//decode/postclickrewrite/thresholdcut/

#generate new bidterm and clicksim feature intersection
#sh suite-greedy.sh -s 0 -e 0 -b /projects/qrw/ruiqiang/selected-bidterm-clickfeature/ -w hdfs://dilithiumblue-nn1.blue.ygrid.yahoo.com:8020/user/ruiqiang/data/all-vertical-wl.txt 
 
#used threshold 1G for greedysearch. rerun for travel but saved to travel2. /qrw reduced from 23B to 19B. but time reduced from 10hr to 4hr
#sh suite-greedy.sh -s 2 -e 2 -r  /projects/qrw/ruiqiang/GreedySelection-travel2/ -i /projects/qrw/ruiqiang/Gemini/smtrewrite_trv/decode/postclickrewrite/thresholdcut -b  /projects/qrw/ruiqiang/intersection-bidterm-clickfeature/

#fix location handling bug (city/state/country) not match, rerun other verticals 2015/12/02
#sh suite-greedy.sh -s 6 -e 7 -r  /projects/qrw/ruiqiang/GreedySelection-click/

#travel greedy search 2015/12/02
#sh suite-greedy.sh -s 6 -e 7 -r  /projects/qrw/ruiqiang/GreedySelection-travel/ -i /projects/qrw/ruiqiang/Gemini/smtrewrite_trv/decode/postclickrewrite/thresholdcut -b  /projects/qrw/ruiqiang/intersection-bidterm-clickfeature/

#sh suite-greedy.sh -s 5 -e 6 -r  /projects/qrw/ruiqiang/GreedySelection-click/ 
