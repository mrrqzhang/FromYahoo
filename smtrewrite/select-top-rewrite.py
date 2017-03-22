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

sys.stderr.write('Threshold: %f\t%f\t%f\t%f\t\n' % (WL1TH,WL2TH,WL3TH,WL4TH))

topn=int(sys.argv[1])
RCUTOFF=float(sys.argv[2])  # log cutoff, range(0,-unlimited)

ar = []
preq = '' 
outrw=[]
maxscore=float(-1000)
for line in sys.stdin:
  fields = line.strip('\r\n ').split('\t')
  query = fields[0]
  adgroup = fields[1]
  rewrite = fields[2]
  score = float(fields[3])
  sys.stderr.write('query=%s\n' % query)
  if query != preq and preq != '' :
    x = sorted(ar, key=lambda ar:ar[2], reverse=True )
    outn=0
#    maxscore=x[0][2]
    if len(preq.split())==1: threshold=float(WL1TH)
    elif len(preq.split())==2: threshold=float(WL2TH)
    elif len(preq.split())==3: threshold=float(WL3TH)
    elif len(preq.split())==4: threshold=float(WL4TH)
    else: threshold = float(-5)
    rcutoff = max(threshold, RCUTOFF)
    sys.stderr.write('preq=%s\tquery=%s\n' % (preq,query))
#    print "rcutoff:",rcutoff
    outrw=[]
    for loop in range(topn):
      adgid=set()   # output only one rewrite from each adgroup
      ln=0 if outn==0 else outn-1
      for item in x:
        if item[0] in adgid: continue  # output only one rewrite from each adgroup
        if ln+1!=outn and ln!=0 and item[1:3] in outrw[ln:]: 
             adgid.add(item[0])  # skip this adgroup if it has the same rewrite as previous ad group
             continue
        if outn<=topn and float(item[2])>=rcutoff+maxscore and item[1]!=preq and item[1:3] not in outrw :
          outrw.append(item[1:3])
          adgid.add(item[0])
          outn += 1
      if len(adgid)==0: break
      # for item in sorted(outrw, key=lambda outrw:outrw[1],reverse=True) :
    for item in outrw:
      sys.stdout.write('%s\t%s\t%f\n' % (preq,item[0],item[1]))
    ar=[]
    ar.append([adgroup, rewrite, score])
    maxscore=score
    preq=query
  else:
    preq=query
    if score>maxscore: maxscore = score
    if query!=rewrite:  #increase first best rewrite score -- maxscore. "airasia". but dropped ctr from 0.075 to 0.067
      ar.append([adgroup, rewrite, score])


x = sorted(ar, key=lambda ar:ar[2], reverse=True )
outn=0
if len(preq.split())==1: threshold=float(WL1TH)
elif len(preq.split())==2: threshold=float(WL2TH)
elif len(preq.split())==3: threshold=float(WL3TH)
elif len(preq.split())==4: threshold=float(WL4TH)
else: threshold = float(-5)
rcutoff = max(threshold, RCUTOFF)
#    print "rcutoff:",rcutoff
outrw=[]
for loop in range(topn):
      adgid=set()   # output only one rewrite from each adgroup
      ln=0 if outn==0 else outn-1
      for item in x:
        sys.stderr.write('%s\t%s\t%f\n' % (item[0],item[1],item[2]))
        if item[0] in adgid: continue  # output only one rewrite from each adgroup
        if ln+1!=outn and ln!=0 and item[1:3] in outrw[ln:]:
          adgid.add(item[0])  # skip this adgroup if it has the same rewrite as previous ad group
          continue
        if outn<=topn and float(item[2])>=rcutoff+maxscore and item[1]!=preq and item[1:3] not in outrw :
          outrw.append(item[1:3])
          adgid.add(item[0])
          outn += 1
      if len(adgid)==0: break
      # for item in sorted(outrw, key=lambda outrw:outrw[1],reverse=True) :
for item in outrw:
      sys.stdout.write('%s\t%s\t%f\n' % (preq,item[0],item[1]))


