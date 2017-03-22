Script synopsis:
-----------------

1. QlSessions.pig scrapes all quicklink views/click event from ABF, along with search results of the same domain; the final output is sorted by timestamp to facilitate data analysis by dates
2. AggCtr.pig takes the output of QlSessions.pig and extracts ctr, conditional(i.e., given that the user clicked on a domain link, either ql or sr) ctr, etc. It does not use timestamp information. 
3. AbfAggCtr.pig combines the two scripts above, but simplifies QlSessions.pig by removing timestamp calculation, and ordering among other things.
4. MergeCtr.pig takes AbfAggCtr.pig results from disjoint date range and merge them.
5. AbfAggCtr.sh is the full pipeline shell integrating 3 and 4
6. AbfDedup.py first sort the quicklinks under each domain by click count, then remove title/nurl duplicates as well as beautify/clean in descending order
7. Sort.pig.py is a pig-in-python script that can do large scale sorting with the standard -k1rg -k2n etc format

Seed Urls for pipeline:
-------------------
1. run step 10 on nitroblue
2. transfer output of 1, domains.uniq, to webmap grid at AllBuckets.2/domains.uniq
3. run step 20, 21 on webmap machine
4. log file would include a testing result on which domains are missing in the end

ABF Domain Selection:
-----------------
1. Modify SelectDomains.py to change nviews_dom, nclicks_dom, and ctr_dom thresholds for grid search
2. Run AbfAggCtr.sh steps 30 - 31 to get the grid search ctr/coverage/#domains results in the log file
3. Pick the operating point, say row x, then put x+4 in step 32 to get the corresponding domain list
4. Transfer the domain list file to webmap machine QuicklinkPipeline/PostProcess folder
5. Run PostProcess step 4.15 and 4.2, after modifying the script PostProcess.sh
