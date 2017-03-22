import sys,re,math
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import normalize,stdgen

domainfile = sys.argv[1]
nvcut = 0 if len(sys.argv) < 3 else int(sys.argv[2])
domdict= {}
with open(domainfile) as f:
    for line in f.readlines():
        tmp = line.strip('\r\t\n ').split('\t')
        tmp[0] = normalize(tmp[0])
        domdict[tmp[0]] = tmp

pd = None
for line in stdgen('lastdomain\tlastql\tlasttitle\t0.0'):
    tmp = line.strip('\n')
    domain = tmp.split('\t')[0]
    if not domain == pd:
        if not pd == None:
            tmp0 = domdict.get(ndom,None)
            if tmp0 and float(tmp0[2]) >= nvcut:
                assert len(ret) == 6
                print '\n'.join(ret)
        pd = domain
        ndom = normalize(pd)
        ret = []
    ret.append(tmp)

