#! /usr/bin/env python

import string
import random
from string import *
import sys, os
import math

ql_click={}
domain_ql_view={}
domain_ql_click={}
domain_click={}
ql_view={}

for line in sys.stdin:
   fields = line.strip().split("\t")
   if len(fields) != 3:
       continue
   if fields[2] == "click":
       if domain_click.has_key(fields[0]):
           domain_click[fields[0]] += 1
       else: 
	   domain_click.setdefault(fields[0],1)
       if domain_ql_click.has_key(fields[0]+"\t"+fields[1]):
       	    domain_ql_click[fields[0]+"\t"+fields[1]] += 1 
       else:
	    domain_ql_click.setdefault(fields[0]+"\t"+fields[1], 1)
       if ql_click.has_key(fields[1]):
            ql_click[fields[1]] += 1
       else:
            ql_click.setdefault(fields[1], 1)

   if fields[2] == "view":
	if ql_view.has_key(fields[1]):
             ql_view[fields[1]] += 1
        else:
             ql_view.setdefault(fields[1],  1)

        if domain_ql_view.has_key(fields[0]+"\t"+fields[1]):
            domain_ql_view[fields[0]+"\t"+fields[1]] += 1
        else:
            domain_ql_view.setdefault(fields[0]+"\t"+fields[1], 1)



sys.stdout.write("domain\tql_url\tdomain_count\tql_click\tql_view\tdomain_ql_click\tdomain_ql_view\tctr_ql\tctr_domain_ql\tlog_ctr_ql\tlogctr_domain_ql\n")


for key in domain_ql_click:
    fields = key.split("\t")
    domain_count = domain_click[fields[0]]
    domain_ql_click_count = domain_ql_click[key]
    domain_ql_view_count = domain_ql_view[key]
    ql_view_count = ql_view[fields[1]]
    ql_click_count = ql_click[fields[1]]


    ctr_ql = 0
    ctr_domain_ql = 0
    log_ctr_ql = 0
    logctr_domain_ql = 0 
    if ql_view_count != 0:
        ctr_ql=float(ql_click_count)/ql_view_count
    if domain_ql_view_count != 0 :
        ctr_domain_ql = float(domain_ql_click_count)/domain_ql_view_count

    if math.log(ql_view_count,2) != 0:
       log_ctr_ql = math.log(ql_click_count)/math.log(ql_view_count,2)

    if math.log(domain_ql_view_count,2) != 0:
       logctr_domain_ql = math.log(domain_ql_click_count,2)/math.log(domain_ql_view_count,2)


    sys.stdout.write('%s\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\n' % (key,domain_count,ql_click_count,ql_view_count,domain_ql_click_count,domain_ql_view_count,ctr_ql,ctr_domain_ql,log_ctr_ql,logctr_domain_ql))

#    print key,"\t",domain_click[fields[0]],"\t",ql_click[fields[1]],"\t",ql_view[fields[1]],"\t",domain_ql_click[key],"\t",domain_ql_view[key],"\t",ctr_ql,"\t",ctr_domain_ql,"\t",log_ctr_ql,"\t",logctr_domain_ql


for key in domain_ql_view:
    if domain_ql_click.has_key(key):
       continue
    fields = key.split("\t")
    domain_count = domain_click[fields[0]]
    domain_ql_click_count = 0
    domain_ql_view_count = domain_ql_view[key]
    if domain_ql_view_count < 8: continue
    ql_view_count = ql_view[fields[1]]
    ql_click_count = 0
    if ql_click.has_key(fields[1]): ql_click_count = ql_click[fields[1]]

    ctr_ql = 0
    ctr_domain_ql = 0
    log_ctr_ql = 0
    logctr_domain_ql = 0
    if ql_view[fields[1]] != 0:
        ctr_ql=float(ql_click_count)/ql_view[fields[1]]

    if math.log(ql_view[fields[1]],2) != 0 and ql_click_count != 0:
       log_ctr_ql = math.log(ql_click_count)/math.log(ql_view[fields[1]],2)

    sys.stdout.write('%s\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\n' % (key,domain_count,ql_click_count,ql_view_count,domain_ql_click_count,domain_ql_view_count,ctr_ql,ctr_domain_ql,log_ctr_ql,logctr_domain_ql)) 
    




