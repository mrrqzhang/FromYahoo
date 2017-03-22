import sys,re,math
try: import simplejson as json
except ImportError: import json
for i,line in enumerate(sys.stdin):
    tmp = line.strip('\r\t\n ').split('\t')
    js = json.loads(tmp[1])
    feats = ' '.join(' '.join([t] * c) for t,c in js.items() if t.isalnum())
    if not feats: continue
    print '%s %d '%(re.sub('[^a-zA-Z0-9\.\-_\/]','',tmp[0]),i) + feats
    #print '| ' + feats 
