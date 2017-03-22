# this script generates bag of words for each quicklink, based on cleaned and truncated internal anchor text and title

import sys,re,math,logging,unidecode,heapq
sys.path.append('../addtitles/')
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from GenTrainToken import BadAnchor
from genLibs import normalize
try: import simplejson as json
except ImportError: import json
from DomainTokens import ud, parseIntAnc, stdgen, stopwords,tokenize

# get rid of non-ascii
# input = hcat pipeline.1/QuicklinkTitles/combined.redir.title.wmdata/par*
if __name__ == '__main__':
    nQlAncs = 3
    if len(sys.argv) > 1: nQlAncs = int(sys.argv[1])

    pd = None
    for line in sys.stdin:
        domain, url, redit, title, wmdata, dom_title, dom_wmdata = line.strip('\n').split('\t')[:7]
        if not domain == pd:
            ndom = normalize(domain)
            pd = domain
        domaintokens = set(tokenize(dom_title) + [t for x in parseIntAnc(dom_wmdata,1) for t in tokenize(x)])
        ret = {}
        for s in tokenize(title) + [t for x in parseIntAnc(wmdata,nQlAncs) for t in tokenize(x)]:
            if not s in domaintokens: ret[s] = ret.get(s,0) + 1
        print '\t'.join([ndom, url, json.dumps(ret)])

