import sys,re,math,json
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import normalize,fixstr,stdgen

# assuming ndom are unique

with open(sys.argv[1]) as f:
    aliaspair = [(normalize(k),set(v)) for k,v in json.loads(f.readline()).items()]
aliasdict = {}
for k,v in aliaspair:
    if not k in aliasdict: aliasdict[k] = set()
    aliasdict[k] = aliasdict[k].union(v)

qlsPerDomain = 6 if len(sys.argv) < 3 else int(sys.argv[2])

keepFewQls = False if len(sys.argv) < 4 else eval(str(sys.argv[3]))

pd = None
printed_domain=set()
for line in stdgen('lastdomain\tlastql\tlasttitle\t0.0'):
    tmp = line.strip('\r\t\n ').split('\t')
    domain, ql, title, score = tmp
    if not domain == pd:
        if not pd == None:
            ret = sorted(ret,key=lambda t:float(t[3]), reverse=True)[:qlsPerDomain]
            if keepFewQls or len(ret) == qlsPerDomain:
                aliases = aliasdict.get(ndom, [pd])
                for alias in aliases:
                    if alias not in printed_domain:
                        print '\n'.join('\t'.join(map(fixstr,[alias] +  r[1:4])) for r in ret)
                        printed_domain.add(alias)
        ret = []
        ndom = normalize(domain)
        pd = domain

    ret.append(tmp)
