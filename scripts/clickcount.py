#! /usr/bin/env python

import string
import random
from string import *
import sys, os

ql_click={}
domain_click={}
click={}
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
       if ql_click.has_key(fields[0]+"\t"+fields[1]):
       	    ql_click[fields[0]+"\t"+fields[1]] += 1 
       else:
	    ql_click.setdefault(fields[0]+"\t"+fields[1], 1)
   if fields[2] == "view":
	if ql_view.has_key(fields[1]):
             ql_view[fields[1]] += 1
        else:
             ql_view.setdefault(fields[1],  1)
for key in ql_click:
    fields = key.split("\t")
    print key,"\t",domain_click[fields[0]],"\t",ql_click[key],"\t",ql_view[fields[1]],"\t",float(ql_click[key])/ql_view[fields[1]]
