import sys
import string

prekey=""
count=[]
num=0
if len(sys.argv)<2: 
   print ("command: top-first-key  topN seperator")
   sys.exit()
top=sys.argv[1] 
sep='\t' 
if len(sys.argv)==3: sep=sys.argv[1]
for line in sys.stdin:
    fields = line.strip('\r\n ').split(sep)
    if fields[0].isspace() or fields[0]=='':    continue
    key=fields[0]
    if key==prekey and num<int(top) :
       sys.stdout.write('%s\n' % line.strip('\r\n '))
       num += int(1)
    else:
       if key!=prekey:
                sys.stdout.write('%s\n' % line.strip('\r\n '))
                num=int(1)
                prekey=key
