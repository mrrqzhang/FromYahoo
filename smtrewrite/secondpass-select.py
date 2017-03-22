
import sys,operator
from collections import defaultdict

WL1TH=-0.5
WL2TH=-1.5
WL3TH=-1.5
WL4TH=-1.5
WL5TH=-1.5


for line in sys.stdin:
    try:
  	fields = line.strip('\r\n ').split('\t')
 	query = fields[0]
  	rewrite = fields[1]
  	score = float(fields[2])
    except: continue
    if len(query.split())==1: threshold=float(WL1TH)
    elif len(query.split())==2: threshold=float(WL2TH)
    elif len(query.split())==3: threshold=float(WL3TH)
    elif len(query.split())==4: threshold=float(WL4TH)
    else: threshold = float(WL5TH)

    if score >=  threshold:
       sys.stdout.write('%s' % line)


