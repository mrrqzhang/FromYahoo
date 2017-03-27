#!/usr/bin/env python

#! /usr/bin/env python

import string
import random
from string import *
import sys, os

dict_source={}
dict_target={}

def main():
    fsource = open(sys.argv[1],'r')
    for line in fsource:
       fields = line.strip()
       dict_source[fields] = 1
    
    
    ftarget = open(sys.argv[2],'r')
    for line in ftarget:
        fields = line.strip()
        dict_target[fields] = 1

    for line in sys.stdin:
        fields = line.strip().split(" \t ")
	if len(fields)!=2:
            continue
        source = fields[0].split(' ')
        target = fields[1].split(' ')
        featurelist=[]
	for word in source:
#                print "aaa",source
		if dict_source.has_key(word):
			featurelist.append(word)
	if len(featurelist)==0:
		continue
        for word in target:
		if not dict_target.has_key(word):
		    continue
		print '%s\t%s' % (word, " ".join(featurelist))


if __name__ == "__main__":
    main()

