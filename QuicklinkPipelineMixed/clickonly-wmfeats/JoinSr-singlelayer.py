import sys,re,math
try: import simplejson as json
except ImportError: import json
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import ConservativeNormalize as normalize
from genLibs import normalize as normalize_strict
#domain:chararray, url:chararray, selfclicks:float, totalclicks:float, ourl:chararray

exclude = ['legal','email','faq','privacy','contact','copyright','terms','registration','map','help','home','xmlrpc','login','.xml','feed','css','plugin','rss','favicon','about','contact']

rootdictfile = sys.argv[1]

with open(rootdictfile) as f:
    rdict = json.loads(f.readline())


def findroot(url):
  try:
    root = normalize_strict(url).split('/')[0]
    while root.count('.') > 0:
        if root in rdict:
            return root
        root = re.sub('^.*?\.','',root)
    return None
  except:
    return None

# url is conservatively normalized
def IsSrCandidate(sr,url):
  try:
    nsr = normalize(sr)
    nurl = normalize(url)
    """
    examples: 
    1. url = maps.google.com, sr = www.google.com
    2. url = maps.google.com/help/en, sr = maps.google.com/help
    3. url = yahoo.com, sr = www.yahoo.com 
    4. url = news.yahoo.com, sr = finance.yahoo.com
    """
    if nsr == nurl: return False
    elif nurl[0:len(nsr)]==nsr: return True 
    elif not ( '/' in nsr or '/' in nurl) and nurl.endswith(nsr): return True
    else: return False
  except:
    return False 

for line in sys.stdin:
  try:
    fields = line.strip('\r\t\n ').split('\t')
    if len(fields)!=4: continue
    url,title,inlinkcnt,internalinlinkcnt = fields
    if any(term in url for term in exclude): continue
    if len(url)>=200: continue
    root = findroot(url)
    if root == None: continue
    SrCandidates = [sr for sr in rdict[root] if IsSrCandidate(sr, url)]
    for sr in SrCandidates:
        sys.stdout.write( '%s\t%s\t%s\t%s\t%s\n'  % (sr,url,title,inlinkcnt,internalinlinkcnt))
  except:
    continue

