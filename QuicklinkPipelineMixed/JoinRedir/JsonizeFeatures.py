import sys,re,math,json
# use the first line as reference for schema
tagindices = [0]
if len(sys.argv) > 1:
    tagindices = map(int,sys.argv[1].split(','))
for line in sys.stdin:
    tmp = line.strip('\n').split('\t')
    tmp1 = [t for i,t in enumerate(tmp) if not i in tagindices]
    tmp0 = [tmp[i] for i in tagindices]
    if not tmp1 or ''.join(tmp1) == '':
        print '\t'.join(tmp0 + [ json.dumps([])  ] )
    else:
        print '\t'.join(tmp0 + [ json.dumps(tmp1) ])


