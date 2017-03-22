import operator
import sys,re
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import normalize



MIN_QUESTION_COUNT_TOP_6=4   # number of ?
MAX_Top_Num=20
MIN_DIF_PARENT=100
MAX_Single_Parent=float(0.8*MAX_Top_Num)  #cant have too many same parent url
parent={}
url_delimiter = ['/','\?','&','=','\$','@',';',':',',','\+']
word_delimiter = ['\+','-','_']
old_domain=""
total=0
questioncount=0



for line in sys.stdin:
   line = line.strip('\r\n ')
   if '\t' not in line: continue
   domain,ql = line.split('\t')
   if not domain or not ql: continue
   ndom = normalize(domain)
   if not ndom: continue
   if domain != old_domain :
      maxvalue=0
      maxkey=""
      if len(parent):
          maxkey = max(parent,key = lambda a: parent.get(a))
          maxvalue = parent[maxkey]
#          print parent
#          print old_domain, maxvalue
#      print old_domain,len(parent)
      if maxvalue>=MAX_Single_Parent and len(parent)<MIN_DIF_PARENT or questioncount>=MIN_QUESTION_COUNT_TOP_6:
	 try:
	     sys.stdout.write('%s\n' % (old_domain))
         except: pass
      parent.clear()
      old_domain = domain
      questioncount=0
      total=0
   if '?' in line and total<6: questioncount+=1

   nql = normalize(ql)
   if not nql: continue
   fields = re.split('|'.join(url_delimiter),nql)
   litem = fields[len(fields)-1]   # last field of url
   pstr = nql[0:len(nql)-len(litem)]   #parent str
#   if pstr=="http://" or pstr=="https://":
#      pstr = ql[0:len(ql)]
#   print "AAA",pstr, line
   if pstr=="": continue # pstr = nql[0:len(nql)]

   if total<20: 
      if parent.has_key(pstr) and total<20 and normalize(pstr)!=ndom:  
         parent[pstr] += 1
      elif normalize(pstr)!=ndom :
         parent.setdefault(pstr,1)
   total+=1

if parent:
   maxkey = max(parent,key = lambda a: parent.get(a))
   maxvalue = parent[maxkey]
#   print maxvalue, maxkey
   if maxvalue>=MAX_Single_Parent and len(parent)<MIN_DIF_PARENT:
      try:
          sys.stdout.write('%s\n' % (old_domain))
      except: pass
