import sys,re,math,logging,unidecode,heapq
sys.path.append('../addtitles/')
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from GenTrainToken import BadAnchor
from genLibs import normalize
import simplejson as json

def stdgen(lastline=None):
    for line in sys.stdin:
        if not lastline: lastline = line
        yield line
        break
    for line in sys.stdin:
        yield line
    yield lastline

stopwords = set(['a','an','and','are','is','at','be','by','for','from','has','he','in',
            'is','it','its','of','on','that','the','to','was','were','will','with'])

def tokenize(s):
    s = s.lower()
    return [t for t in re.split('\s+',s) if t and t.isalpha() and len(t) > 2 and not t in stopwords]

def ud(s):
    if s == None: return s
    s = re.sub('\n','\\n',re.sub('\t','\\t',s))
    try:
        return unidecode.unidecode(s.decode('utf-8','ignore'))
    except:
        return unidecode.unidecode(s)


def parseIntAnc(wmdata,topk=20):
    EnglishOnly = True
    linkdict = {'int':[],'ext':[]}
    wmdlen = len(wmdata)
    if not wmdata: linkdict = linkdict
    else:
        """
        <LINKS type="int"><AT weight="3.00" lang="en">Burst</AT><AT weight="1.00" lang="en">Burst.net</AT></LINKS><LINKS type="ext"><AT weight="0.50" lang="en">BurstNET Fraudsters</AT><AT weight="0.50" lang="en">BurstNET Scammers</AT></LINKS>
        """
        linktype ='int'
        loc = wmdata.find('<LINKS type="%s">'%linktype)
        loc2 = wmdata.find('<LINKS type="%s">'%'ext')
        loc0 = loc + 10000
        if loc < loc2: loc0 = min(loc0, loc2)
        if not loc == -1:
            ancdata = ud(wmdata[loc:loc0])
            for weight, lang, anchortext in re.findall('<AT weight="([^"]*)" lang="([^"]*)">(.*?)</AT>',ancdata):
                if EnglishOnly and not lang.startswith('en'): continue
                if not BadAnchor(anchortext): 
                    linkdict[linktype].append((anchortext, float(weight)))
    return [x[0] for x in heapq.nlargest(topk, linkdict['int'],key = lambda t:t[1])]

if __name__ == '__main__':
    pd = None
    mode = 'ql'
    if len(sys.argv)> 1:
        mode = sys.argv[1]
    nQlAncs = 3 if len(sys.argv) <= 2 else int(sys.argv[2])
    if mode == 'domain':
        for line in stdgen('\t'.join(['None'] * 7)):
            domain, url, redit, title, wmdata, dom_title, dom_wmdata = line.strip('\n').split('\t')[:7]
            if not domain == pd:
                if not pd == None:
                    print '%s\t%s'%(normalize(pd), json.dumps(ret))
                ret = {}
                pd = domain
                domaintokens = set(tokenize(dom_title) + [t for x in parseIntAnc(dom_wmdata,1) for t in tokenize(x)])
                
            for s in tokenize(title) + [t for x in parseIntAnc(wmdata,nQlAncs) for t in tokenize(x)]:
                if not s in domaintokens: ret[s] = ret.get(s,0) + 1
                
    elif mode =='ql':
        pd,pq = None,None
        for line in stdgen():
            score, domain, dom_title, dom_wmdata, ql, title, wmdata, qlc, qlc_title, qlc_wmdata = line.strip('\n').split('\t')[:10]
            if not (pd,pq) == (domain, ql):
                if not domain == pd:
                    domaintokens =  set(tokenize(dom_title) + [t for x in parseIntAnc(dom_wmdata,1) for t in tokenize(x)])
                if not ( pd == None or pq == None):
                    print '%s\t%s\t%s'%(normalize(pd),pq, json.dumps(ret))
                ret = {}
                pd,pq = domain,ql
                
                for s in tokenize(title) + [t for x in parseIntAnc(wmdata,nQlAncs) for t in tokenize(x)]: 
                    if not s in domaintokens: ret[s] = ret.get(s,0) + 1
            for s in tokenize(qlc_title) + [t for x in parseIntAnc(qlc_wmdata,nQlAncs) for t in tokenize(x)]:
                if not s in domaintokens: ret[s] = ret.get(s,0) + 1


            
