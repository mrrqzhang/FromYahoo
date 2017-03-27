import sys
import string

prekey=""
count=[]
for line in sys.stdin:
    fields = line.strip('\r\n ').split('\t')
    if fields[0].isspace() or fields[0]=='':	continue
    key=fields[0]
    if key!=prekey:
       sys.stdout.write('%s\t%s\n' % (prekey,'\t'.join(count)))
       count=fields[1:]
       prekey=key
    else:
       for i in range(1,len(fields)): count[i-1] = str(int(count[i-1])+int(fields[i]))
