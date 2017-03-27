'''
==========================================================================================
program to generate various metrics for quicklinks
run as: /home/y/bin64/python ~/ql_metrics/gen_ql_metrics.py --g_ql_file ~/ql_metrics/quicklinks_east --out_file metrics1.out --max_y_qls_to_read 6 --max_g_qls_to_read 6 --top1k_queries_file ~/ql_metrics/top_1k_queries --y_ql_file prod_quicklinks-us.xml --y_ql_override_file ~/ql_metrics/quicklinks-us-override.xml
author: pranav
==========================================================================================
'''

import sys
import pprint
import xml.etree.cElementTree as ET
from sets import Set
import os.path
import argparse
import string
from collections import defaultdict
from datetime import datetime

# global vars
g_qls = defaultdict(set) # hash of url (stripped of http/s) -> [set of quicklinks]
y_qls = defaultdict(set) # hash of url (stripped of http/s) -> [set of quicklinks]
y_qls_o = defaultdict(set) # override file
yproxy_qls = defaultdict(set) # hash of url -> [set of quicklinks]
top1k = Set()
set_all_g_result_urls = Set() # set of all urls (stripped of http/s) from google scrape

set_g_urls = Set() # set of urls (NOT stripped of http/s) for which google has qls
set_y_urls = Set() # set of urls (NOT stripped of http/s) for which yahoo has qls

set_g_urls_with_no_qls = Set()
set_g_non_root_urls = Set()
set_g_queries = Set()
set_g_root_urls = Set()

# functions
def read_top1k_queries_file(top1k_queries_file_f):
    fptop = open(top1k_queries_file_f, 'r')
    for line in fptop:
        line = line.strip()
        if (len(line)==0):
            continue
        top1k.add(line)
    fptop.close()

def isNonRootUrl(url):
    toks = url.split('/')
    if len((toks[len(toks)-1])) == 0:
        del toks[len(toks)-1]
    if (len(toks) > 3): 
        return True
    else:
        return False

def read_g_ql_file(g_ql_file, max_g_qls_to_read):
    start_t = datetime.now()
    print "reading [%s]..." % g_ql_file
    print "will read max [%d] quicklinks" % max_g_qls_to_read
    fp_g_ql_file = open(g_ql_file, 'r')
    count_lines = 0
    #num_non_root_urls = 0
    num_less_tokens = 0

    for line in fp_g_ql_file:
        count_lines += 1
        
        line = line.strip()
        if len(line) == 0:
            continue

        tokens = line.split("\t")
        if (len(tokens) < 9):
            num_less_tokens += 1
            continue
        
        g_query = tokens[0].strip()
        set_g_queries.add(g_query)
        g_url = tokens[3].strip()
        g_orig_url = g_url
        g_ql = tokens[8].strip()

        if len(g_url)==0:
            continue

        # remove http or https from the url
        g_url = string.replace(g_url, "http://", "", 1)
        g_url = string.replace(g_url, "https://", "", 1)

        set_all_g_result_urls.add(g_url)

        if len(g_ql)==0:
            continue

        if (g_ql.find("Quick Links Url: ") == -1):
            set_g_urls_with_no_qls.add(g_url)
            continue

        g_ql = g_ql.replace("Quick Links Url: ", "", 1)
        if (len(g_ql)==0):
            continue

        # collect for top 1K queries only
        #if (g_query not in top1k):
        #    continue
            
        # skip nonroot urls
        if isNonRootUrl(g_orig_url):
            #num_non_root_urls += 1
            set_g_non_root_urls.add(g_url)
            #print "non root url: [%s]" % g_url
            continue

        set_g_root_urls.add(g_url)
        #if g_url not in g_qls:
        #    g_qls[g_url] = Set()

        if (max_g_qls_to_read<0 or (len(g_qls[g_url]) < max_g_qls_to_read)):
            g_qls[g_url].add(g_ql)
            set_g_urls.add(g_orig_url);

        #if count_lines % 10000 == 0:
        #    print "read [%d] lines of file [%s] so far" % (count_lines, g_ql_file)

    fp_g_ql_file.close()
    end_t = datetime.now()
    print "read total [%d] lines of file [%s]" % (count_lines, g_ql_file)
    print "read [%d] root urls for which google had qls from file [%s]" % (len(g_qls), g_ql_file)
    print "read num_non_root_urls: ", len(set_g_non_root_urls)
    print "read num_queries: ", len(set_g_queries)
    print "read lines with less than 9 tokens: ", num_less_tokens
    print "read num_urls_with_no_qls: ", len(set_g_urls_with_no_qls)
    print "read num root urls: ", len(set_g_root_urls)
    print "read total number of urls: ", len(set_all_g_result_urls)
    print "time taken to read google file: ", (end_t-start_t)

def read_yproxy_ql_file(yproxy_ql_file, max_y_qls_to_read):
    print "reading [%s]..." % yproxy_ql_file
    print "will read max [%d] quicklinks" % max_y_qls_to_read
    fp_yproxy_ql_file = open(yproxy_ql_file, 'r')
    count_lines = 0
    num_non_root_urls = 0
    for line in fp_yproxy_ql_file:
        count_lines += 1
        
        line = line.strip()
        if len(line) == 0:
            continue

        tokens = line.split("\t")
        if (len(tokens) < 6):
            continue
        
        y_url = tokens[1].strip()
        #g_title = tokens[1].strip()
        y_ql = tokens[5].strip()

        if len(y_url)==0 or len(y_ql)==0:
            continue

        if y_url not in yproxy_qls:
            yproxy_qls[y_url] = Set()
            toks = y_url.split('/')
            if len((toks[len(toks)-1])) == 0:
                del toks[len(toks)-1]
            if (len(toks) > 3): 
                num_non_root_urls += 1
                #print "non root url: [%s]" % y_url

        if (max_y_qls_to_read<0 or (len(yproxy_qls[y_url]) < max_y_qls_to_read)):
            yproxy_qls[y_url].add(y_ql)

        #if count_lines % 10000 == 0:
        #    print "read [%d] lines of file [%s] so far" % (count_lines, yproxy_ql_file)
        #if (count_lines == 10):
        #    break

    fp_yproxy_ql_file.close()
    print "read total [%d] lines of file [%s]" % (count_lines, yproxy_ql_file)
    print "read [%d] urls from file [%s]" % (len(yproxy_qls), yproxy_ql_file)
    print "read num_non_root_urls: ", num_non_root_urls

def read_y_ql_file(y_ql_file, max_y_qls_to_read):
    start_t = datetime.now()
    print "reading [%s]..." % y_ql_file
    print "will read max [%d] quicklinks" % max_y_qls_to_read
    tree = ET.parse(y_ql_file)
    root = tree.getroot()
    y_url = None
    for docs in root:
        for c_docs in docs:
            if c_docs.tag == "url":
                y_url = c_docs.text
                y_orig_url = y_url
                y_url = string.replace(y_url, "http://", "", 1)
                y_url = string.replace(y_url, "https://", "", 1)
            if c_docs.tag == "sublink":
                for c_sublinks in c_docs:
                    #if c_sublinks.tag == "anchor":
                    #    print "anchor: %s" % c_sublinks.text
                    if c_sublinks.tag == "link":
                        #if y_url not in y_qls:
                        #    y_qls[y_url] = Set()
                        if (max_y_qls_to_read<0 or (len(y_qls[y_url]) < max_y_qls_to_read)):
                            #print "adding ", c_sublinks.text
                            y_qls[y_url].add(c_sublinks.text)
                            set_y_urls.add(y_orig_url)

    end_t = datetime.now()
    print "read [%d] urls from [%s]" % (len(y_qls), y_ql_file)
    print "time taken to read yahoo qls file: ", (end_t-start_t)

def read_y_ql_override_file(y_ql_override_file, max_y_qls_to_read):
    print "reading [%s]..." % y_ql_override_file
    print "will read max [%d] quicklinks" % max_y_qls_to_read
    tree = ET.parse(y_ql_override_file)
    root = tree.getroot()
    y_url = None
    for docs in root:
        for c_docs in docs:
            if c_docs.tag == "url":
                y_url = c_docs.text
                y_orig_url = y_url
                y_url = string.replace(y_url, "http://", "", 1)
                y_url = string.replace(y_url, "https://", "", 1)                
            if c_docs.tag == "sublink":
                for c_sublinks in c_docs:
                    #if c_sublinks.tag == "anchor":
                    #    print "anchor: %s" % c_sublinks.text
                    if c_sublinks.tag == "link":
                        #if y_url not in y_qls_o:
                        #    y_qls_o[y_url] = Set()
                        if (max_y_qls_to_read<0 or (len(y_qls_o[y_url]) < max_y_qls_to_read)):
                            #print "adding ", c_sublinks.text
                            y_qls_o[y_url].add(c_sublinks.text)
                            set_y_urls.add(y_orig_url)

    print "read [%d] urls from [%s]" % (len(y_qls_o), y_ql_override_file)

def merge_y_qls():
    for y_url in y_qls_o:
        if y_url in y_qls:
            y_qls.remove(y_url)
            y_qls[y_url] = y_qls_o[y_url]

def compute_coverage():
    print "computing coverage..."
    num_g_urls_with_y_ql = 0
    num_g_urls_with_g_ql = 0
    num_g_urls = len(set_all_g_result_urls)
    for g_url in set_all_g_result_urls:
        if g_url in y_qls:
            num_g_urls_with_y_ql += 1
        if g_url in g_qls:
            num_g_urls_with_g_ql += 1

    #print "num_g_urls_with_y_ql: ", num_g_urls_with_y_ql
    print "num_g_urls: ", num_g_urls
    print "google coverage for root urls: ", (num_g_urls_with_g_ql*1.0/len(set_all_g_result_urls))
    print "yahoo coverage for root urls: ", (num_g_urls_with_y_ql*1.0/len(set_all_g_result_urls))
    #print "coverage: [%.2f %%]" % ((num_g_urls_with_y_ql*1.0*100)/num_g_urls)

# As for urls for which both google and we've qls, find out how many times our top ql matches that of google.
def count_top_matching_qls(set_common_urls):
    matching_count = 0
    for url in set_common_urls:
        g_first_ql = next(iter(g_qls[url]))
        y_first_ql = next(iter(yproxy_qls[url]))
        if (g_first_ql == y_first_ql):
            matching_count += 1
    return matching_count

# As for urls for which both google and we've qls, find out how many times google's top ql is present 
# in our full list of qls (we'll start with the default set of 15 qls we generate and increase it to 
# 30 if needed). The idea here is to see if the ranking needs to be improved.
def count_top_matching_qls2(set_common_urls):
    matching_count2 = 0
    for url in set_common_urls:
        g_first_ql = next(iter(g_qls[url]))
        if (g_first_ql in yproxy_qls[url]):
            matching_count2 += 1
    return matching_count2

#def compare_y_g_results(out_file):
def compare_y_g_results():
    #print "comparing google and yahoo results for top 1K queries..."
    #print "number of urls for which google has qls: ", len(g_qls)
    #print "number of urls for which we've qls: ", len(yproxy_qls)
    #print "number of urls for which we've qls: ", len(y_qls)

    #num = len(Set(g_qls.keys()).difference(Set(y_qls.keys())))
    #print "number of urls for which google has qls, "\
    #    "but we don't (compared to the full set we've): ", num, (num*1.0/len(g_qls))*100, "%"
        
    #print "\nlist of urls for which google has qls, but we don't"
    #print "============================================================="
    in_g_not_y = Set(g_qls.keys()).difference(Set(y_qls.keys()))
    #in_g_not_y = set_g_urls.difference(set_y_urls)
    #for url in in_g_not_y:
    #    print url
    num = len(in_g_not_y)
    print "\nnumber of urls for which google has qls, but we don't: ", num #, " percentage: ", (num*1.0/len(g_qls))*100, "%"

    #print "\nlist of urls for which we've qls, but google doesn't"
    #print "============================================================="
    #in_y_not_g = Set(y_qls.keys()).difference(Set(g_qls.keys()))
    #for url in in_y_not_g:
    #    print url
    #num = len(in_y_not_g)
    #print "\nnumber of urls for which we've qls, but google doesn't: ", num #, " percentage: ", (num*1.0/len(y_qls))*100, "%"

    #print "\nlist of urls for which both google and us have qls"
    #print "============================================================="
    #set_common_urls = Set(y_qls.keys()).intersection(Set(g_qls.keys()))
    #for url in set_common_urls:
    #    print url
    #num = len(set_common_urls)
    #print "\nnumber of urls for which both google and us have qls: ", num
    
    #matching_count = count_top_matching_qls(set_common_urls)
    #print "for urls for which both google and we've qls, number of times our top ql matches that of google's: ", matching_count,\
    #    (matching_count*1.0/len(set_common_urls)*100), "%"

    #matching_count2 = count_top_matching_qls2(set_common_urls)
    #print "for urls for which both google and we've qls, number of times google's top ql matches one of our qls: ", matching_count2,\
    #    (matching_count2*1.0/len(set_common_urls)*100), "%"

    #fout = open(out_file, 'w')
    total_num_common = 0
    total_num_y_qls = 0
    total_num_g_qls = 0
    set_all_g_qls = Set()
    set_all_yg_qls = Set() # set of all y qls for which google has qls
    #fout.write("num_google\tnum_yahoo\tnum_common\tnum_in_g_not_in_y\tnum_in_y_not_in_g\n")
    for g_url in g_qls:
        #total_num_g_qls += len(g_qls[g_url])
        if g_url in y_qls:
            set_all_g_qls.update(g_qls[g_url])
            set_all_yg_qls.update(y_qls[g_url])
            #common_qls_set = y_qls[g_url].intersection(g_qls[g_url])
            #qls_in_g_not_in_y = g_qls[g_url].difference(y_qls[g_url])
            #qls_in_y_not_in_g = y_qls[g_url].difference(g_qls[g_url])

            #num_google = len(g_qls[g_url])

            #num_yahoo = len(y_qls[g_url])
            #total_num_y_qls += num_yahoo

            #num_common = len(common_qls_set)
            #total_num_common += num_common

            #num_in_g_not_in_y = len(qls_in_g_not_in_y)
            #num_in_y_not_in_g = len(qls_in_y_not_in_g)
            
            #fout.write("\nresults for [%s]\n" % y_url)
            #fout.write("===================================================================\n")
            #fout.write("%d\t%d\t%d\t%d\t%d\n" % (num_google, num_yahoo, num_common, num_in_g_not_in_y, num_in_y_not_in_g))
    #fout.close()
    total_num_common = len(set_all_g_qls.intersection(set_all_yg_qls))
    total_num_y_qls = len(set_all_yg_qls)
    total_num_g_qls = len(set_all_g_qls)

    print "num of overlapped qls: ", total_num_common
    print "num of yahoo generated qls (starting each url for which google has qls): ", total_num_y_qls
    print "num of google generated qls: ", total_num_g_qls
    print "jaccard index between the set of all google qls and yahoo qls: ", (total_num_common*1.0)/(total_num_y_qls + total_num_g_qls)
    print "overlap coefficient between the set of all google qls and yahoo qls: ", (total_num_common*1.0)/min(total_num_y_qls,total_num_g_qls)
    #print "ratio of total number of overlapped qls to total num of yahoo qls: ", (total_num_common*1.0)/total_num_y_qls
    #print "ratio of total number of overlapped qls to total num of google qls: ", (total_num_common*1.0)/total_num_g_qls

def get_max_qls_generated_per_domain():
    max_qls = 0
    ql_lens = []
    for key in y_qls:
        ql_lens.append(len(y_qls[key]))
        max_qls = max(max_qls, len(y_qls[key]))
    print "max qls generated per domain: ", max_qls
    #import numpy
    #print "histogram..."
    #bins = [x for x in range(1,52)]
    #print numpy.histogram(ql_lens, bins)

def main():
    start_t = datetime.now()
    print "Hello World Metrics"
    parser = argparse.ArgumentParser(description='gen_ql_metrics')
    
    parser.add_argument("--g_ql_file", dest="g_ql_file", required=True, help="google scraped ql data file")
    parser.add_argument("--y_ql_file", dest="y_ql_file", required=True, help="yahoo generated ql file")
    #parser.add_argument("--y_ql_override_file", dest="y_ql_override_file", required=True, help="yahoo overrides")
    #parser.add_argument("--yproxy_ql_file", dest="yproxy_ql_file", required=True, help="yahoo scraped ql data file")
    #parser.add_argument("--out_file", dest="out_file", required=True, help="output file")
    parser.add_argument("--max_y_qls_to_read", dest="max_y_qls_to_read", type=int, required=True, help="max_y_qls_to_read")
    parser.add_argument("--max_g_qls_to_read", dest="max_g_qls_to_read", type=int, required=True, help="max_g_qls_to_read")
    #parser.add_argument("--top1k_queries_file", dest="top1k_queries_file", required=True, help="top1k_queries_file")
    parser_out = parser.parse_args()

    g_ql_file = parser_out.g_ql_file
    y_ql_file = parser_out.y_ql_file
    #y_ql_override_file = parser_out.y_ql_override_file
    #yproxy_ql_file = parser_out.yproxy_ql_file
    #out_file = parser_out.out_file
    max_y_qls_to_read = parser_out.max_y_qls_to_read
    max_g_qls_to_read = parser_out.max_g_qls_to_read
    #top1k_queries_file = parser_out.top1k_queries_file

    #if os.path.exists(out_file):
    #    print "ERROR: output file [%s] already exists" % out_file
    #    sys.exit(1)

    #read_top1k_queries_file(top1k_queries_file)
    read_g_ql_file(g_ql_file, max_g_qls_to_read) # file obtained after scraping google
    #pprint.PrettyPrinter(indent=4).pprint(g_qls)
    read_y_ql_file(y_ql_file, max_y_qls_to_read) # the full set of qls we've
    #read_y_ql_file(y_ql_override_file, max_y_qls_to_read) # overrides
    #merge_y_qls()
    #pprint.PrettyPrinter(indent=4).pprint(y_qls)
    #read_yproxy_ql_file(yproxy_ql_file, max_y_qls_to_read) # file obtained after scraping the qlproxy
    #pprint.PrettyPrinter(indent=4).pprint(yproxy_qls)
    #compare_y_g_results(out_file)
    compare_y_g_results()
    compute_coverage()

    get_max_qls_generated_per_domain()

    end_t = datetime.now()
    print "total time taken by this script: ", (end_t-start_t)

if __name__ == "__main__":
    main()
