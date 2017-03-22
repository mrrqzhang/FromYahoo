import sys,re,math,urllib
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
try: import simplejson as json
except ImportError: import json
toptitledict = {}
titlenormdict = {}
def normalizetitle(t):
    return re.sub('\s+','',t.lower())

if __name__ == '__main__':
    toptitlefile = sys.argv[1]
    topk = 5000
    if len(sys.argv) > 2:
        topk = int(sys.argv[2])

    with open(toptitlefile) as f:
        for i,line in enumerate(f.readlines()):
            freq,title = line.strip('\r\t\n ').split('\t')
            toptitledict[normalizetitle(title)] = int(freq)
            if i < topk:
                # to get rid of comma, <>, etc
                titlenormdict[normalizetitle(title)] = urllib.quote(title)
        #topktitles = set([k for k,v in sorted(toptitledict.items())][:topk])

    # input is QuicklinkTitles/scoretitle
    for line in sys.stdin:
        dom, ql, title, score = line.strip('\r\t\n ').split('\t')
        ntitle = normalizetitle(title)
        print '\t'.join([dom, ql, json.dumps([ titlenormdict.get(ntitle, 'Freq Below Top %d'%topk), toptitledict.get(ntitle,-1)]) ] )


