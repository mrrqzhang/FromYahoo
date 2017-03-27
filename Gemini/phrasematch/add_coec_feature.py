import sys,re

coectable={}
for line in open(sys.argv[1],'r'):
    fields = line.strip('\r\t\n').split('\t')
    key = fields[0]+'\t'+fields[1]
    coec = 'QUERY_COEC:' + fields[4]
    coectable[key]=coec


for line in sys.stdin:
    fields = line.strip('\r\t\n').split('\t')
    fields[0] = re.sub('^feature: ','',fields[0])
    key = fields[0]+'\t'+fields[1]
    if key in coectable: 
       sys.stdout.write('%s %s\n' % (line.strip('\r\t\n'),coectable[key]))
    else:
       sys.stdout.write('%s\n' % (line.strip('\r\t\n')))
