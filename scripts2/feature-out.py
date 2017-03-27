#! /usr/bin/env python

import string
import random
from string import *
import sys, os

dict={}
default_feature = [0,0,0,0,0,0]
def main():
   ffile = open(sys.argv[1],'r')
   for line in ffile:
     line2 = line.strip()
     fields = line2.split('\t') 
     dict[fields[0]] = fields[1:]
   urlf = open(sys.argv[2],'r')
   for line in urlf:
     line2 = line.strip()
     fields = line2.split('\t')
     print '%s\t%s\t' % (fields[0],fields[1]),
     if dict.has_key(fields[0]) :
	     print '%s\t' % "\t".join(dict[fields[0]]),
     else:
         print '%s\t' % "\t".join(map(str,default_feature)),
     if dict.has_key(fields[1]):
        print '%s' %  "\t".join(dict[fields[1]])
     else:
        print '%s' % "\t".join(map(str,default_feature))

if __name__ == "__main__":
    main()

   


