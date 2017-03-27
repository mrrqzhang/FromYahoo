import sys

for line in sys.stdin:
    if 'INFO' not in line: continue
    fields = line.strip('\r\t\n ').split('')
    q=''
    for i in range(2,len(fields)):
        fields2 = fields[i].split('')
        if fields2[0]=='0': q = fields2[1]
        else:
           sys.stdout.write('%s\t%s\t%s\n' %(q,fields2[1],fields2[2]))
             
