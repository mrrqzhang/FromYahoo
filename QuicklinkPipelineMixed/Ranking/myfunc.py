#!/usr/bin/env python
import os,sys,re,math,string

try:    # this library needs to be imported by jython
    try: import simplejson as json
    except ImportError: import json
except:
    pass

mylibdir =  os.path.expanduser('~/pythonlib')

def qnormalize(query):
    regex = re.compile('[%s]' % re.escape(string.punctuation))
    query = regex.sub(' ', query.lower())
    query = query.strip(' ')
    query = re.sub(' +',' ',query)
    return query

def cosine2(x,y):
  sx = len(x)
  sy = len(y)
  if sx==0 or sy==0: return 0
  num=0
  for i in range(0,sx):
     for j in range(0,sy):
       if x[i]==y[j]: 
	num+=1
	break
  return float(num)/math.sqrt(sx*sy)


def cosine(x,y):
  sx = len(x)
  sy = len(y)
  if sx==0 or sy==0: return 0
  num=0
  for i in range(0,sx):
     for j in range(0,sy):
       if x[i]==y[j]: num+=1
  return float(num)/(sx*sy)

