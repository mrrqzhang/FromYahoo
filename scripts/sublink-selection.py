import sys,re
sublink=[]
count={}
MAX_Token_Num=4
MAX_Children_Num=6
MAX_Domain_Num=50
url_delimiter = ['/','\?','&','=','\$','@',';',':',',','\+']
word_delimiter = ['\+','-','_']
old_domain=""
total=0
for line in sys.stdin:
   line = line.strip()
   domain = line.split('\t')[0]
   if domain != old_domain:
      old_domain = domain
      parent={}
      total=0
   ql = line.split('\t')[1]
   if ql[len(ql)-1] in url_delimiter:
      ql = ql.strip(ql[len(ql)-1])
   fields = re.split('|'.join(url_delimiter),ql)
   litem = fields[len(fields)-1]
   pstr = ql[0:len(ql)-len(litem)]

   fields2 = ql.split('/')
   fields2 = re.split('|'.join(word_delimiter),fields2[len(fields2)-1])
   if len(fields2)>=MAX_Token_Num: continue  #print "==== ",ql       # remove long final node 
   fields2 = re.split('|'.join(word_delimiter),fields2[len(fields2)-2])
   if len(fields2)>=MAX_Token_Num: continue   #last second    #remove long last second node
   if total==MAX_Domain_Num: continue
   if parent.has_key(pstr) :
      if parent[pstr] < MAX_Children_Num:  #each level can't output more than 4
         sys.stdout.write("%s\n" % line)
         parent[pstr] += 1
         total+=1
   else:
      sys.stdout.write("%s\n" % line)
      parent.setdefault(pstr,1)
      total+=1
