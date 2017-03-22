import sys,re,math
try: import simplejson as json
except ImportError: import json
from genLibs import normalize
mode = sys.argv[1]
if mode in ['aliasdict','rootdict']:
    dolower = True
    if len(sys.argv)> 2:
        dolower = eval(sys.argv[2])
# input is url, parenturl tsv, generated from fieldsdump
# output has normalized key, differing from previous version
if mode == 'aliasdict':
    minimal = True
    if len(sys.argv) > 3:
        minimal = eval(sys.argv[3])
    ret = {}
    for line in sys.stdin:
        url,parent = [a.lower() if dolower else a for a in line.strip('\r\t\n ').split('\t')]
        nurl,nparent = map(normalize,[url, parent])

        if not nurl == nparent: 
            rset = ret.setdefault(nurl,set())
            rset.add(url)
            rset = ret.setdefault(nparent,set())
            rset.add(parent)
        else:
            rset = ret.setdefault(nparent,set())
            rset.add(parent)
            rset.add(url)
        
    ret = dict((k,list(v)) for k,v in ret.items() if not minimal or len(v) > 1)
    print json.dumps(ret)

elif mode == 'rootdict':
    urlset  = set()
    trunkset = set()
    for line in sys.stdin:
        # take the parent urls only
        url, parent = [a.lower() if dolower else a for a in line.strip('\r\t\n ').split('\t')]
        nurl, np = map(normalize, [url, parent])
        if nurl == np: tmp,ntmp = parent,np
        else: tmp,ntmp = url,nurl
        urlset.add((tmp,ntmp))
        trunk = ntmp.split('/')[0]
        trunkset.add(trunk)

    rset = set()
    for trunk in trunkset:
        root = trunk
        while trunk.count('.') > 1:
            trunk = re.sub('^.*?\.','',trunk)
            if trunk in trunkset: 
                root = trunk
        # root will be the shortest substring of trunk that's in trunkset
        rset.add(root)

    rootdict = {}
    for url,nurl in urlset:
        root = nurl.split('/')[0]
    
        while root.count('.') > 0:
            if root in rset:
                rr = rootdict.setdefault(root, {})
                rr[nurl] = url
                break
            root = re.sub('^.*?\.','',root)
    print json.dumps(rootdict)

elif mode == 'test':
    # sanity test to make sure certain domains are in the file
    rootdictfile = sys.argv[2]
    with open(rootdictfile) as f:
        rootdict = json.loads(f.readline())
    testfile = sys.argv[3]
    testdomains = {}
    with open(testfile) as f:
        for i,line in enumerate(f.readlines()):
            testdomains[normalize(line.strip('\r\t\n '))] = i
    
    for k,v in rootdict.items():
        for k2,v2 in v.items():
            if k2 in testdomains:
                testdomains.pop(k2)
    # missing domains from rootdict 
    for domain,i in sorted(testdomains.items(),key = lambda t: float(t[1]), reverse= False):
        print i, domain
