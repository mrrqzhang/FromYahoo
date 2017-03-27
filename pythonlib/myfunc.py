#!/usr/bin/env python
import os,sys,re,math,string
import sys,re,string,math
import array
import jarray
from types import *

import ast 
try:    # this library needs to be imported by jython
    try: import simplejson as json
    except ImportError: import json
except:
    pass

mylibdir =  os.path.expanduser('~/pythonlib')

@outputSchema('outstr:chararray')
def join(bag, sep):
    if len(bag)==0: return ''
    str=bag[0][1]
    for [w,b] in bag[1:]:
        str = str +'_'+b
    return str

@outputSchema('ret:bag{t:(sr:chararray)}')
def tokenize(str, sep):
    try:
    	fields=str.split(sep)
    except: pass
    return [ t for t in fields ]
    
def Byte2Str(txt):
	return txt
#    return txt.tostring().decode('utf-8').strip()


def remove_punct(sent):
    regex = re.compile(r'([%s])' % re.escape(string.punctuation))
    sent = regex.sub(r' ', sent)
    sent = re.sub('\s+',' ',sent)
    sent = re.sub('\s+$','',sent)
    sent = re.sub('^\s+','',sent)
    return sent

@outputSchema('outstr:chararray')
def normalize_wiki_entity(entity):
    entity = re.sub('\(.*\)','',entity, re.I)
    entity = remove_punct(entity)
    return entity.lower()



@outputSchema('sim:float')
def cosine(x,y):
  try:
  	xs=x.split()
  	ys=y.split()
  	if len(xs)==0 or len(ys)==0: return 0
  	num=0
  	for i in range(0,len(xs)):
     		for j in range(0,len(ys)):
       			if xs[i]==ys[j]:
        			num+=1
        			break
  	return float(num)/math.sqrt(len(xs)*len(ys))
  except:
        return 0

@outputSchema('sim:float')
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

@outputSchema('query:chararray')
def qnormalize(query):
    regex = re.compile('[%s]' % re.escape(string.punctuation))
    query = regex.sub(' ', query.lower())
    query = query.strip(' ')
    query = re.sub(' +',' ',query)
    return query

@outputSchema('nquery:chararray')
def sort_str(wordstr):
    if wordstr is None: return ''
    input=wordstr
    if isinstance(wordstr,array.array):
       try:
          s=[]
          [ s.append(int(wordstr[i])) for i in range(0,len(wordstr)) ]
          input = ''.join([chr(x) for x in s])
       except:
          return ''
    wv = input.split()
    return ' '.join(sorted(wv))

 
@outputSchema('ret:bag{t:(sr:chararray, ql:chararray,pos:chararray, dpos:chararray, ql_txt:chararray)}')
def viewinfo2srs(viewinfo):
    ret =[]
    qlret=[]
    topSr = None
    for v in viewinfo:
        m = v[0]
        if not ('slk' in m and 'targurl' in m and 'sec' in m and 'pos' in m): continue
        if (not m['slk']) or (not m['targurl']) or (not m['sec']) or (not m['pos']): continue
        if not (Byte2Str(m.get('sec')) == 'sr' ) : continue
        if int(m.get('pos')) > 1: 
	    if m['slk'] == 'title' :
		url = Byte2Str(m.get('targurl'))
                pos = m['pos']
                ret.append([url,'',pos,'',''])
        elif m.get('pos') == '1': 
            slk = Byte2Str(m['slk'])
            url = Byte2Str(m.get('targurl'))
            if slk == 'title':
               topSr = url
            elif slk == 'aa_link':
               if not ( 'dpos' in m and 'ql_txt' in m): continue
               dpos = Byte2Str(m['dpos'])
               ql_txt = Byte2Str(m['ql_txt'])
               if not dpos: continue
               qlret.append([url, m['pos'], dpos, ql_txt])
    if not topSr: return []
    else:
          tmp = [([topSr] + t) for t in qlret] + ret
          return [tuple(t) for t in tmp]


@outputSchema('ret:bag{t:(sr:chararray, ql:chararray, dpos:chararray, ql_txt:chararray)}')
def viewinfo2srqls(viewinfo):
    ret =[]
    topSr = None
    for v in viewinfo:
        m = v[0]
        if not ('slk' in m and 'targurl' in m and 'sec' in m and 'pos' in m): continue
        if (not m['slk']) or (not m['targurl']) or (not m['sec']) or (not m['pos']): continue
        if not ( Byte2Str(m.get('sec')) == 'sr' and Byte2Str(m.get('pos')) == '1' ) : continue
        slk = Byte2Str(m['slk'])
        url = Byte2Str(m.get('targurl'))
        if slk == 'title':
            topSr = url
        elif slk == 'aa_link':
            if not ( 'dpos' in m and 'ql_txt' in m): continue
            dpos = Byte2Str(m['dpos'])
            ql_txt = Byte2Str(m['ql_txt'])
            if not dpos: continue
            
            ret.append([url, dpos, ql_txt])
    if not topSr: return []
    else:
        return [tuple([topSr] + t) for t in ret ]

if __name__ == "__main__":
    for line in sys.stdin:
#       print line
       print viewinfo2srs(line.strip('\r\t\n '))
    
