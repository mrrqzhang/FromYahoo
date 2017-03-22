import sys,re,math
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import normalize

"""
http://000sweb.co.monterey.ca.us/cob/   http://000sweb.co.monterey.ca.us/cob/supervisor.htm     1.0
http://000sweb.co.monterey.ca.us/cob/   http://000sweb.co.monterey.ca.us/cob/minutes/2001/010403M.htm   1.0
http://002salvage.com/  http://www.002salvage.com/product/default.asp   1.0
http://002salvage.com/  http://www.002salvage.com/about/news.asp        1.0
http://005.housedems.com/       http://005.housedems.com/contact-me     2.0
http://005.housedems.com/       http://005.housedems.com/biography      1.0
"""
if __name__ == "__main__":
    pd = None
    top10kfile = 'seed_urls.top10k' if len(sys.argv) < 2 else sys.argv[1]
    top10kset= set()
    with open(top10kfile) as f:
        for line in f.readlines():
            top10kset.add(normalize(line.strip('\r\t\n ')))
    mode = 'Missing' if len(sys.argv) < 3 else sys.argv[2]
    if mode == 'Found': ret = set()
    doNorm = True if len(sys.argv) < 4 else eval(str(sys.argv[3]))
    for line in sys.stdin:
        domain = line.strip('\r\t\n ').split('\t')[0]
        if not domain == pd:
            pd = domain
            ndom = normalize(domain) if doNorm else domain
            if ndom in top10kset:
                if mode == 'Found': ret.add(ndom)
                elif mode == 'Missing': top10kset.remove(ndom)
    if mode == 'Found':
        print '\n'.join(ret)
    elif mode == 'Missing':
        print '\n'.join(top10kset)

