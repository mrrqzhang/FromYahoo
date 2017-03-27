
import sys

from collections import defaultdict
from functools import partial

#judgemap={'Excellent':4, 'Good':3.5, 'Fair':1.5, 'Bad':1, 'N/A':-1}
judgemap={'Excellent':1, 'Good':0.8, 'Fair':0.5, 'Bad':0, 'N/A':-1}
fname=[]


f = open(sys.argv[1],'r')
for item in iter(partial(f.readline),''):
   try:
    fname.append(item.strip('\r\t\n').split('\t')[1])
   except: pass

sys.stdout.write('query\trewrite\t%s\tweight\tlabel\n' % '\t'.join(fname))

for line in sys.stdin:
    fmap=defaultdict(int)
    fields = line.strip('\r\t\n').split('\t')
    query,rewrite,label,features = fields[0],fields[1],fields[2],fields[3:]
    if label not in judgemap: 
        label='N/A'
    sys.stdout.write('%s\t%s' % (query, rewrite))
    for feat in features[0].split():
#        print feat
        fs = feat.split(':')
        fs[0]=fs[0].upper()
        if len(fs)==2:fmap[fs[0]]=fs[1]
        else: fmap[fs[0]+'$'] = 1
    for feat in fname:
        if feat in fmap: sys.stdout.write('\t%s' % fmap[feat])
        else: sys.stdout.write('\t0')
    if label in judgemap:
    	sys.stdout.write('\t1\t%s\n' % judgemap[label])
    else: 
	sys.stdout.write('\t1\t%s\n' % label)






