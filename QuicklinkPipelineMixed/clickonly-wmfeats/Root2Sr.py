import sys,re,math
import simplejson as json

sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import normalize
rootfile = sys.argv[1]
# input must be unique root file, so news.yahoo.com and yahoo.com cannot both be in 
with open(rootfile) as f:
    rset = set(json.loads(f.readline()))
ret = {}
for line in sys.stdin:
    url = line.strip('\r\t\n ')
    root = normalize(url).split('/')[0]

    while root.count('.') > 0:
        if root in rset:
            if not root in ret: ret[root] = []
            ret[root].append(url)
            break
        root = re.sub('^.*?\.','',root)
print json.dumps(ret)
    
