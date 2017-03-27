#!/usr/bin/python

import sys, re
from operator import itemgetter, attrgetter


BAD_TITLE_SCORE=2.0

def normalize(url,strip=False):
    ret = url
    for p,q in [('//m\.','//'),
              ('//touch\.','//'),
              ('//www\.','//'),
              ('https*://','')]:
        ret= re.sub(p,q,ret)
    # important to strip forward slash at the end
    if strip:
        ret = re.sub('/.*','',ret)
    return ret.strip('\r\t\n/ ')

def rank_title(domain_ql,n):
      i=0
#      print domain_ql
      while i<n:
         if float(domain_ql[i][3])<BAD_TITLE_SCORE:
            p=i
            for j in range(i+1,n):
              if domain_ql[i][3]<domain_ql[j][3]:
                 p = j
            #put i behind p
         #   print "p=",p, "i=",i, domain_ql
            if p==i:
               i+=1
               continue
            else:
                tmp = domain_ql[i]
                for j in range(i+1,p+1):
                    domain_ql[j-1] = domain_ql[j]
                domain_ql[p]=tmp
         #       print domain_ql
         else:
             i+=1
      return 


fctr = open(sys.argv[1],"r")

dctr = dict()

for line in fctr:
   fields = line.strip().split("\t")
   if fields[0][0:6] is not "http://":
      fields[0] = "http://" + fields[0]
   if fields[1][0:6] is not "http://":
      fields[1] = "http://" + fields[1]
   if dctr.has_key(normalize(fields[0].strip())+"\t"+normalize(fields[1].strip())) :
       if dctr[normalize(fields[0].strip())+"\t"+normalize(fields[1].strip())] < fields[2]:
	   dctr[normalize(fields[0].strip())+"\t"+normalize(fields[1].strip())] = fields[2]
   else:
       dctr[normalize(fields[0].strip())+"\t"+normalize(fields[1].strip())] = fields[2]
#   dctr[fields[:1]] = fields[2]


last_domain=""
n=0
domain_ql=[]
for line in sys.stdin:
   fields = line.strip().split("\t")
   if fields[0] == last_domain:
       domain_ql.append(fields[:4])
       key = normalize(fields[0])+ "\t" + normalize(fields[1]) 
       ctr=0
       if dctr.has_key(key):
            ctr = dctr[key]
 #           print ctr,key
       domain_ql[n].append(ctr) 
       n += 1
   else:
      if n==0:
          last_domain = fields[0]
          continue
      old_domain_ql = domain_ql
#      newlist=sorted(domain_ql, key=itemgetter(4), reverse=True)
      newlist=sorted(domain_ql, lambda x,y:cmp(float(x[4]),float(y[4])), reverse=True)
#      if domain_ql != newlist: 
#           for i in range(n):
#               sys.stdout.write( "OLD\t".join(domain_ql[i][:3])+"\t"+domain_ql[i][3]+"\t"+str(domain_ql[i][4])+"\n")
#      domain_ql = newlist 
#      rank_title(newlist,n)
      domain_ql = newlist
      if domain_ql != old_domain_ql:
         for i in range(n):
             sys.stdout.write( "OLD\t"+"\t".join(old_domain_ql[i][:3])+"\t"+old_domain_ql[i][3]+"\t"+str(old_domain_ql[i][4])+"\n")
         for i in range(n):
            sys.stdout.write( "NEW\t"+"\t".join(domain_ql[i][:3])+"\t"+domain_ql[i][3]+"\t"+str(domain_ql[i][4])+"\n")
      else:
         for i in range(n):
            sys.stdout.write( "\t".join(domain_ql[i][:3])+"\t"+domain_ql[i][3]+"\t"+str(domain_ql[i][4])+"\n")

      domain_ql=[]
      domain_ql.append(fields[:4])
      key=normalize(fields[0])+ "\t" + normalize(fields[1])
      ctr=0
      if dctr.has_key(key):
            ctr = dctr[key]
 #           print ctr,key
      domain_ql[0].append(ctr)

      n=1
      last_domain = fields[0]
  

