import sys,re,math,json
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import normalize
# alias.dict.onejson
# {"http://www.state.in.us/": ["http://www.state.in.us/"], "http://www.hennepin.us/": ["http://www.hennepin.us/"], 

topk=6

with open(sys.argv[1]) as f:
    aliaspair = [(normalize(k),set(v)) for k,v in json.loads(f.readline()).items()]
aliasdict = {}
for k,v in aliaspair:
    if not k in aliasdict: aliasdict[k] = set()
    aliasdict[k] = aliasdict[k].union(v)


def fixstr(s):
    try:
        return str(s)
    except:
        return s.decode('utf-8','ignore')
ret = {}
for line in sys.stdin:
    domain, ql, title, score = line.strip('\r\t\n ').split('\t')
    ndom = normalize(domain)
    if not ndom in ret: ret[ndom] = {}
    if not domain in ret[ndom]: ret[ndom][domain] = []
    ret[ndom][domain].append((domain,ql,title,score))
    
ret2 = dict((k,max(v.values(),key = lambda t:len(t))) for k,v in ret.items())


for k,v in sorted(ret2.items(),key =lambda t:t[0]):
    for dom in aliasdict.get(k,[v[0][0]]):
        for domain, ql, title, score in v[:topk]:
            print '\t'.join(map(fixstr,[dom,ql,title,score]))
