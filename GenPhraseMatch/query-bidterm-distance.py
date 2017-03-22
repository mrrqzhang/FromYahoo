import sys,math
from collections import defaultdict

MinScore=0.5
btdict = defaultdict(str)
with open(sys.argv[2],'r') as f:
  for line in f:
    try:    
    	bidterm, feature = line.strip('\r\t\n').split('\t')
    	itemy = feature.split('|')
    	dicty = dict(y.split(':') for y in itemy)
    	for key in dicty: dicty[key]=float(dicty[key])
        sy=0
        for key in dicty: sy += dicty[key]*dicty[key]
    	btdict[bidterm]=(dicty,math.sqrt(sy))
    except:pass
    
with open(sys.argv[1],'r') as f:
 count=0
 for line in f:
  try:
    query, feature = line.strip('\r\t\n').split('\t')
    itemx = feature.split('|')
    dictx = dict(x.split(':') for x in itemx)
    for key in dictx: dictx[key]=float(dictx[key])
    sx=0
    for key in dictx: sx += dictx[key]*dictx[key]
    sx = math.sqrt(sx)
    for bidterm, (dicty,sy) in btdict.items():
        sum=0
        intersect = set(dictx.keys()).intersection(set(dicty.keys()))
        for key in intersect:
            sum += dictx[key]*dicty[key]
        score = float(sum)/sx/sy
        if score >= float(MinScore): 
            sys.stdout.write('%s\t%s\t%f\n' % (query, bidterm, score))
    count+=1
    if count%1000==0: sys.stderr.write('processed %d lines\n' % (count))
  except:  pass
