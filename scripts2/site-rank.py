#!/usr/bin/env python

import string
import random
from string import *
import sys, os

map={}

finput = open(sys.argv[1],"r")
for line in finput:
  fields = line.strip().split("\t")
  if(len(fields)<2):
     continue
  key = fields[0]+"\t"+fields[1]
  map[key]=-1


for line in sys.stdin:
   if "QUERY_NUMBER" in line:
	istart=0
        fields = line.strip().split(':')
        domain = ':'.join(fields[2:])
   
   if line[0:4] == "http":
      istart += 1
      qlurl = line.strip()
      key = domain +"\t" + qlurl
      if map.has_key(key):
         map[key]=istart

for key in map:
   print key,"\t",map[key]
