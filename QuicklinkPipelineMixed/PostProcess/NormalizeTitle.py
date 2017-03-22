import sys,re,math
try: import simplejson as json
except ImportError: import json
# this script maps each title to its normalize form and use the most frequently occuring unnormalized title as the canonical one
def normalizetitle(t):
    return re.sub('\s+','',t.lower())
def standardspace(t):
    return re.sub('\s+',' ',t.strip('\r\t\n '))
def badtitle(t):
    if max(len(s) for s in re.split('\s+',t)) < 2: return True
    elif len([s for s in re.split('\s+',t) if len(s) == 1]) > 3: return True
    else: return False
def defgoodtitle(t):
    if min(len(s) for s in re.split('\s+',t)) > 1 and min(int(u[0].upper() == u[0] and u[0].isalpha()) for u in re.split('\s+',t)) == 1: return True
    else: return False 
if __name__ == '__main__':
    mode = sys.argv[1]
    ntitlefile = sys.argv[2]
    if mode == 'prepare':
        # assume input is freq \t title and sorted in reverse
        # cut -f3 processed.tsv | sort | uniq -c | sort -t$'\t' -k1,1nr | awk -F '\t' '{print $1"\t"$2}' | python NormalizeTitle.py prepare ntitles.onejson
        ret = {}
        for line in sys.stdin:
            tmp = re.split('\s+',line.strip('\n\t\r '))
            freq = tmp[0]
            title = ' '.join(tmp[1:])
            ntitle = normalizetitle(title)
            stitle = standardspace(title)
            if ( ( not ntitle in ret ) and not badtitle(stitle) and not stitle in [ 'Login', 'Servi Ces', 'Faqs', 'FAQS'] ) \
                    or ( False and defgoodtitle(stitle) and ntitle in ret and ret[ntitle].count(' ') < stitle.count(' ') ):  # Login is before Log In 
                #print ntitle, standardspace(title)
                ret[ntitle] = stitle
            if int(freq) == 1: break    # no preference for the unique titles
        with open(ntitlefile,'w') as f:
            f.write(json.dumps(ret))
    elif mode == 'apply':
        # here assume input is domain\turl\ttitle\score
        with open(ntitlefile) as f:
            ret = json.loads(f.readline())
        # mv processed.tsv processed.roughtitle.tsv ; cat processed.roughtitle.tsv | python NormalizeTitle.py apply ntitles.onejson > processed.tsv
        for line in sys.stdin:
            tmp = line.strip('\n').split('\t')
            print '\t'.join(tmp[:2] + [ ret.get(normalizetitle(tmp[2]),standardspace(tmp[2])) ] + tmp[3:])

