import sys,re,math,logging
try: import simplejson as json
except ImportError: import json
sys.path.insert(0,'../AbfData')
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import normalize, stdgen, fixstr, mildsigmoid
from AbfDedup import QlPostProcess

if __name__ == '__main__':
    #blf = sys.argv[1]
    blf="None"
    titlefile = sys.argv[1]
    wlfs = sys.argv[2]
    edit = eval(str(sys.argv[3]))   # edit title override

    pad = pow(10,8)
    if len(sys.argv) > 4:
        pad = float(sys.argv[4])

    pad2 = 10  # this is to make sure editorial results that match ranking results get surfaced before those that didn't match
    if len(sys.argv) > 5: 
        pad2 = float(sys.argv[5])

    rankbyctr = False
    if len(sys.argv) > 6:
        rankbyctr = eval(str(sys.argv[6]))

    rankbyscore = True
    if len(sys.argv) > 7:
        rankbyscore = eval(str(sys.argv[7]))
    nitems = 10
    if len(sys.argv) > 8:
        nitems = eval(str(sys.argv[8]))

    bl = set()
    if not blf == 'None':
        with open(blf) as f:
            for line in f.readlines():
                tmp  = line.strip('\r\t\n ').split('\t')
                ndom = normalize(tmp[0])
                nql = normalize(tmp[1])
                bl.add((ndom,nql))

    titlebank = {}
    if not titlefile == 'None':
        with open(titlefile) as f:
            titlebank = dict(((ndom,nql),v[-1][0]) for ndom,v0 in json.loads(f.readline()).items() for nql, v in v0.items())

    wl = {}
    for wlf in wlfs.split(','):
        with open(wlf) as f:
            for line in f.readlines():
                tmp = line.strip('\r\t\n ').split('\t')[:4]
                ndom = normalize(tmp[0])
                nql = normalize(tmp[1])
                if not ndom in wl: wl[ndom] = {}
                if not nql in wl[ndom] and not rankbyctr:   # or any other predefined wl score; for editorial whitelist, cannot rank by ctr
                    score = 1.0 / ( len(wl[ndom]) + 1.0 )   # assume wl results are ranked 
                    tmp[3] = score
                    wl[ndom][nql] = tmp
                elif rankbyctr and ( not nql in wl[ndom] or wl[ndom][nql][3] < float(tmp[3]) ):
                    tmp[3] = float(tmp[3])
                    wl[ndom][nql] = tmp

    pd = None

    for line in stdgen('lastdomain\tlastql\tlasttitle\t0.0'):   # use first line as lastline
        tmp  =line.strip('\n').split('\t')

        domain = tmp[0]
        if not pd == domain:

            if not pd == None:

                for nql,v in wldom.items(): # whitelist enhancement
                    # first title enhancement
                    if (ndom,nql) in ret and not edit:
                        title = ret[(ndom,nql)][2]
                    else:
                        title = v[2]
                    # next ranking enhancement
                    if (ndom,nql) in ret and rankbyscore: score = pad + pad2 + ret[(ndom,nql)][3]   # if editorial matches one of the ranking results, it takes precedence over the unmatched editorial results
                    else: score = pad + v[3]
        
                    if not (ndom,nql) in ret or ret[(ndom,nql)][3] < score:
                        ret[(ndom,nql)] = [pd,v[1],title,score]
                # use title from titlebank
                for k,v in ret.items():
                    v[2] = titlebank.get(k,v[2])
                    ret[k] = v

                ret2 = QlPostProcess(ndom,ret.values(),nitems = nitems)
                if ret2:
                    print '\n'.join('\t'.join(map(fixstr,t)) for t in ret2)
            ndom = normalize(domain)
            wldom = wl.get(ndom,{})
            ret = {}
            pd = domain
            titlescoredict= {}


        ql = tmp[1]
        nql = normalize(ql)
        
        if (ndom,nql) in bl: continue
        title = tmp[2]
        # score from gbdt ranking is assumed between 0 and 1
        score = float(tmp[3])
        ret[(ndom,nql)] = [domain, ql, title, score]




