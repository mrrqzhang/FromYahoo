#! /usr/bin/env python

import string
import random
from string import *
import sys, os

dict={}
default_feature = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
def main():
   ffile = open(sys.argv[1],'r')
   for line in ffile:
     line2 = line.strip()
     fields = line2.split('\t') 
     if len(fields) != len(default_feature)+1:
	continue
     dict[fields[0]] = fields[1:]
#   urlf = open(sys.argv[2],'r')
   for line in sys.stdin:
     line2 = line.strip()
     fields = line2.split('\t')
     sys.stdout.write( '%s\t%s\t' % (fields[0],fields[1]))
     if fields[0][0:4] != "http":
         fields[0]="http://"+fields[0]
     if fields[1][0:4] != "http":
         fields[1]="http://"+fields[1]
#     print fields[0],fields[1].strip(), fields[0][0:4] 
     if dict.has_key(fields[0].strip()) :
             sys.stdout.write( '%s\t' % "\t".join(dict[fields[0].strip()]))
     else:
           sys.stdout.write('%s\t' % "\t".join(map(str,default_feature)))
     if dict.has_key(fields[1].strip()):
        sys.stdout.write( '%s' %  "\t".join(dict[fields[1].strip()]))
     else:
        sys.stdout.write( '%s' % "\t".join(map(str,default_feature)))
     sys.stdout.write('\t%s\t%s\n' % (fields[2],fields[3]))

if __name__ == "__main__":
    main()

