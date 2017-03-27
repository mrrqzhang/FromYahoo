import sys,math
from collections import defaultdict

btdict = defaultdict(str)

with open(sys.argv[2],'r') as f:
    
    id,bidterm, feature = f.readline().strip('\r\t\n').split('\t')
    itemy = feature.split('|')
    dicty = dict(y.split(':') for y in itemy)
    for key in dicty: dicty[key]=float(dicty[key])
    btdict[bidterm]=dicty
    print bidterm

with open(sys.argv[1],'r') as f:
  try:
    query, feature = f.readline().strip('\r\t\n').split('\t')
    itemx = feature.split('|')
    dictx = dict(x.split(':') for x in itemx)
    for key in dictx: dictx[key]=float(dictx[key])
    sx=0
    for key in dictx: sx += float(dictx[key])*float(dictx[key])
    print "query score", sx
    for bidterm, dicty in btdict.items():
        print "query:", query, sx
        print "bidterm:", bidterm
        sum=0
        for key in dictx:
            if key in dicty:
                sum += float(dictx[key])*float(dicty[key])
                print "sum:",sum
        sy=0 
        for key in dicty: sy += float(dicty[key])*float(dicty[key])
        print "sy:",sy
        score = float(sum)/math.sqrt(sx)/math.sqrt(sy)
        print "score:",score
#        if score >= MinScore: 
        sys.stdout.write('%s\t%s\t%f\n' % (query, bidterm, score))

  except:  pass
