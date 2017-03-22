import sys
import sys,re,math
import xml.etree.ElementTree as ET # xml too big
from  collections import defaultdict
try: import simplejson as json
except ImportError: import json

def xmlparser ( xml, domlst ): 
  xmldict = defaultdict(dict)
  xmlstr=''
  for line in open(xml,'r') :
    xmlstr += line.strip('\n\r')
    if '<doc>' in line:
        xmlstr=""
        xmlstr += line.strip('\n\r')
    if '</doc>' in line:
        root = ET.fromstring(xmlstr)
        for doc in root.getiterator("doc"):       
            url = doc.find('url').text.encode('utf-8')
            for ql in doc.getiterator("sublink"):
                 rank = ql.find('rank').text
                 anchor = ql.find("anchor").text
                 link = ql.find('link').text
                 if url not in domlst: continue
                 try:
                    xmldict[url.encode('utf-8')][link.encode('utf-8')]=anchor.encode('utf-8') + '\t' + rank
                 except:
                    pass
  return xmldict

    
domlst = [ s.strip('\r\t\n') for s in sys.stdin ]
modelfiles = sys.argv[1:]
if len(modelfiles)==0: 
	print "no xml files"
	sys.exit()

xmlnlst=[]

for f in modelfiles:
    xlst = xmlparser(f,domlst)
    xmlnlst.append(xlst)


for key in xmlnlst[0]:  #domain
    kl=0
    for j in range(1,len(xmlnlst)):
        if key not in xmlnlst[j]: 
		kl=1
		break
    if kl==1: continue 
    out=[]
    contained=set()
    for skey in xmlnlst[0][key]:
        m = '\t'.join([key,skey,xmlnlst[0][key][skey]])
        member = '\t'.join([key,skey,xmlnlst[0][key][skey],modelfiles[0]])
        if m not in contained:
             contained.add(m)
	     out.append(member)

    kl=1
    for j in range(1,len(xmlnlst)):
       for skey in xmlnlst[j][key]:
           m = '\t'.join([key,skey,xmlnlst[j][key][skey]])
           member = '\t'.join([key,skey,xmlnlst[j][key][skey],modelfiles[j]])
           if m not in contained: 
	       kl=0
               contained.add(m)
               out.append(member)

    if kl==0 or len(xmlnlst)==1:
         for l in range(len(out)):
             sys.stdout.write('%s\n' % out[l])






