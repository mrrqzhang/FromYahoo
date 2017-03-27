# selection logic
# get all rewrite for single query. then sort by rewrite score, then output rewrite averagely on adgroup

import sys,operator
from collections import defaultdict

topn=50

ar = []
outrw=[]

for line in sys.stdin:
  query, value = line.strip('\r\n ').split('\t')
  field = value.strip('()').split(',')
  ar=[]
  for i in range(0,len(field),6):
     try:
      rewrite = field[i+1]
      adgroup = field[i+2]
      cscore = float(field[i+3])    #click feature score
      bid = float(field[i+4]) #bid price
      score = float(field[i+5])
      if query!=rewrite:  #increase first best rewrite score -- maxscore. "airasia". but dropped ctr from 0.075 to 0.067
           ar.append([rewrite,adgroup,cscore, bid, score])
     except:
       pass
  x = sorted(ar, key=lambda ar:ar[4], reverse=True )
  outn=0
  outrw=[]
  rset=set()
  for loop in range(topn):
         adgid=set()   # output only one rewrite from each adgroup
         for item in x:
            if item[1] in adgid or item[0] in rset: continue  # output only one rewrite from each adgroup
            if outn<topn  :
                outrw.append([item[0],item[2],item[3]])
                adgid.add(item[1])
                rset.add(item[0])
                outn += 1
         if outn==topn or len(adgid)==0: break
  for item in outrw:
            sys.stdout.write('%s\t%s\t%f\t%f\n' % (query,item[0],item[1],item[2]))




 


x = sorted(ar, key=lambda ar:ar[4], reverse=True )
outn=0
outrw=[]
rset=set()
for loop in range(topn):
      adgid=set()   # output only one rewrite from each adgroup
      for item in x:
        if item[1] in adgid or item[0] in rset: continue  # output only one rewrite from each adgroup
        if outn<topn :
          outrw.append([item[0],item[2],item[3]])
          adgid.add(item[1])
          rset.add(item[0])
          outn += 1
      if len(adgid)==0: break
      # for item in sorted(outrw, key=lambda outrw:outrw[1],reverse=True) :
for item in outrw:
      sys.stdout.write('%s\t%s\t%f\t%f\n' % (query,item[0],item[1],item[2]))





