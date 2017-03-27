
import sys

from collections import defaultdict
from functools import partial

#judgemap={'Excellent':4, 'Good':3.5, 'Fair':1.5, 'Bad':1}
judgemap={'Excellent':1, 'Good':1, 'Fair':0, 'Bad':0, 'N/A':-1}
fname=[]

'''
 BM25_title:39.69683855024498 TOKENS_title:3 LSI_title:0.032024227274804175 COSINE_title:0.862456206590818 CHARS_title:25
'''

f = open(sys.argv[1],'r')
for item in iter(partial(f.readline),''):
    fname.append(item.strip('\r\t\n').split('\t')[1])
fname.append('BM25_title')
fname.append('TOKENS_title')
fname.append('LSI_title')
fname.append('COSINE_title')
fname.append('CHARS_title')


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
        if len(fs)==2:fmap[fs[0]]=fs[1]
        else: fmap[fs[0]+'$'] = 1
    for feat in fname:
        if feat in fmap: sys.stdout.write('\t%s' % fmap[feat])
        else: sys.stdout.write('\t0')
    sys.stdout.write('\t1\t%s\n' % judgemap[label])






