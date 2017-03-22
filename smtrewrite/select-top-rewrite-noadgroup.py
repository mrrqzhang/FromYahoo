# selection logic
# get all rewrite for single query. then sort by rewrite score, then output rewrite averagely on adgroup

import sys,operator
from collections import defaultdict
'''
for travel
WL1TH=-0.5
WL2TH=-1.8
WL3TH=-3.0
WL4TH=-4.0
for edu:
WL1TH=-3.0
WL2TH=-4.0
WL3TH=-4.0
WL4TH=-5.0

default:
WL1TH=-10.0
WL2TH=-10.0
WL3TH=-10.0
WL4TH=-10.0
'''

WL1TH=-0.5
WL2TH=-1.8
WL3TH=-3.0
WL4TH=-4.0

OutputQuery=True
#sys.stderr.write('Threshold: %f\t%f\t%f\t%f\t\n' % (WL1TH,WL2TH,WL3TH,WL4TH))

topn=int(sys.argv[1])
RCUTOFF=float(sys.argv[2])  # log cutoff, range(0,-unlimited)

ar = []
preq = '' 
maxscore=float(-1000)
score = maxscore
for line in sys.stdin:
  try:
  	fields = line.strip('\r\n ').split('\t')
 	query = fields[0]
  	rewrite = fields[1]
  	score = float(fields[2])
  	bid = float(fields[3])
  except: continue
#  sys.stderr.write('query=%s\n' % query)
  if query != preq and preq != '' :
    x = sorted(ar, key=lambda ar:ar[1], reverse=True )
    if len(preq.split())==1: threshold=float(WL1TH)
    elif len(preq.split())==2: threshold=float(WL2TH)
    elif len(preq.split())==3: threshold=float(WL3TH)
    elif len(preq.split())==4: threshold=float(WL4TH)
    else: threshold = float(-5)
    rcutoff = max(threshold, RCUTOFF)
#    sys.stderr.write('preq=%s\tquery=%s\n' % (preq,query))
#    print "rcutoff:",rcutoff
    outn=0
    for item in x:
         if outn<topn and float(item[1])>=rcutoff+maxscore and (item[0]!=preq or OutputQuery):
              sys.stdout.write('%s\t%s\t%f\t%f\n' % (preq,item[0],item[1],item[2]))
	      outn += 1
    ar=[]
    ar.append([rewrite, score, bid])
    maxscore=score
    preq=query
  else:
    preq=query
    if score>maxscore: maxscore = score
    if query!=rewrite or OutputQuery:  
      ar.append([rewrite, score,bid])


x = sorted(ar, key=lambda ar:ar[1], reverse=True )
if len(preq.split())==1: threshold=float(WL1TH)
elif len(preq.split())==2: threshold=float(WL2TH)
elif len(preq.split())==3: threshold=float(WL3TH)
elif len(preq.split())==4: threshold=float(WL4TH)
else: threshold = float(-5)
rcutoff = max(threshold, RCUTOFF)
#    print "rcutoff:",rcutoff

outn=0
for item in x: 
      if outn<topn and float(item[1])>=rcutoff+maxscore and (item[0]!=preq or OutputQuery):
          sys.stdout.write('%s\t%s\t%f\t%f\n' % (preq,item[0],item[1],item[2]))
	  outn += 1


