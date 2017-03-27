import sys
import re

from collections import defaultdict

pdict=defaultdict()

for line in sys.stdin:
    query,phrase,feature = line.strip('\r\t\n').split('\t')
    query = re.sub('Query: ','',query)
    phrase = re.sub('Phrase: ','',phrase)
    feature = re.sub('Feature: ','',feature)
    key='\t'.join([query,phrase])
#    pdict[key].append(feature)
    if key in pdict: pdict[key].append(feature)
    else: pdict[key] = [feature]


for key,value in pdict.items():
    sys.stdout.write('%s\t%s\n' % (key, '\t'.join(value)))
