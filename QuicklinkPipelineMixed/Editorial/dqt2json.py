#!/usr/bin/env python
# input is domain, quicklink, title tsv, output is json: {ndom: {nql: [(title1,label1), (title2,label2)]}}
# label can be timestamp, source filename, or anything that denotes the circumstance under which the title is added
# default is timestamp
import sys,re,math,datetime,time
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import normalize,TryEval
try: import simplejson as json
except ImportError: import json

def Dedup(mylist):
    # forward deduping
    ret = []
    for item in mylist:
        if not item in ret:
            ret.append(item)
    return ret
if __name__ == "__main__": 

    jsonfile='qltitle_edit.onejson'

    if len(sys.argv) > 1:
        jsonfile = sys.argv[1]

    label = time.time()
    timestamp = label
    if len(sys.argv) > 2:
        label = ';'.join([str(label), sys.argv[2]])

    mode = 'update'
    if len(sys.argv) > 3:
        mode = sys.argv[3]
    try: 
        with open(jsonfile) as f:
            titledict = json.loads(f.readline())

        with open('backlog/%s.bak.%s'%(jsonfile,str(timestamp)),'w') as f:
            f.write(json.dumps(titledict))
    except:
        titledict= {}

    if mode == 'update':
        for line in sys.stdin:
            domain, ql, title = line.strip('\n').split('\t')
            ndom = normalize(domain)
            nql = normalize(ql)
            titledictndom = titledict.setdefault(ndom,{})
            titledictndomnql = titledictndom.setdefault(nql,[])
            titledictndomnql.append((title, label))

        with open(jsonfile,'w') as f:
            f.write(json.dumps(titledict))

    elif mode == 'dedup':
        ret = {}
        for k,v in titledict.items():
            ret[k] = {}
            for k2,v2 in v.items():
                ret[k][k2] = Dedup(v2)
        with open(jsonfile,'w') as f:
            f.write(json.dumps(ret))
