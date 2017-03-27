#!/usr/bin/env python

import string
import random
from string import *
import sys, os

map={}

defaultmap={}
firstfeature=True

for line in sys.stdin:
   if "QUERY_NUMBER" in line:
        fields = line.strip().split('\t')
        if len(fields)<3:
            continue
        domain = fields[1]
        qlurl = fields[2]
     #   print domain,qlurl 
   fields = line.strip().split(' ')
   if len(fields) > 1000:
      map.clear()
      for i in range(len(fields)):
	ff = fields[i].split('=')
        name = ff[0]
        value = ff[1]
        if firstfeature:
	   defaultmap.setdefault(name, 1)
        map.setdefault(name, value)
      if firstfeature:
        print "domain\tql_url",
        for key in defaultmap:
            print "\t%s" % key,
        print
      firstfeature=False
      print "%s\t%s" % (domain, qlurl),
      for key in defaultmap:
         if map.has_key(key):
             print "\t%s" % map[key],
         else:
             print "\t0"
      print


  
      
