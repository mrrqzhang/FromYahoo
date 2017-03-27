#! /usr/bin/env python

import string
import random
from string import *
import sys, os

def count(keyidxb=0, keyidxe=0):
	qct=[]
	pre_key=""
	while 1:
		line=sys.stdin.readline()
		if not line: break
		line = line[:-1]
		flds=line.split("\t")
		key='\t'.join(flds[keyidxb:keyidxe])
		#print >> sys.stderr, key, len(flds), keyidxe, keyidxb
		if key <> pre_key:
			if len(qct) <>0:
				printcount(pre_key, qct) 
			qct=[]
			for i in range(keyidxe,len(flds)):
				try:
					qct.append(atoi(flds[i]))
				except:
					qct.append(atof(flds[i]))
		else:
			for i in range(keyidxe,len(flds)):
				try:
					qct[i-keyidxe]+=atoi(flds[i])
				except:
					qct[i-keyidxe]+=atof(flds[i])
		pre_key=key

	if len(qct) <> 0:
		printcount(pre_key, qct) 
	return 

def printcount(key, qct):
	sys.stdout.write("%s"%(key))
	for i in range(len(qct)):
		sys.stdout.write("\t%d"%(qct[i]))
	sys.stdout.write("\n")

def main():
	if len(sys.argv)<>3:
		print '''
		Usage: python Count.py KeyIndexStart KeyIndexEnd < Input > Output
		'''
		sys.exit()
	count(atoi(sys.argv[1]), atoi(sys.argv[2]))

if __name__=="__main__":

	main()

