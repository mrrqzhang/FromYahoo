# -*- coding: utf-8 -*-

import sys,re,math,string
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
import simplejson as json
from kitchen.text.converters import to_bytes
from genLibs import normalize
#import urllib2

def entropy(weights):
    if not weights: return -1.

    weightsum = sum(weights)
    return - sum( (0. if w <= 0 else w  / weightsum * math.log (w/weightsum) ) for w in weights)

# logos shouldn't be included
exactmatchset = set(['canonical','alternate','prev','previous','next','website','web site','visit site','webpage','more','skip','back','right here','index','continue','read more','learn more','view more','see more','logo','shortlink','go to'])

startswithset = set(['prev ','previous ','next ','more ','go to '])

anywhereset = set(['navigation','click ','add to favorite','skip','toggle','x close','close x','top of page','visit website','back to','jump to'])




def BadAnchor(anc):
    # single number is not a big problem
    anc = anc.lower()
    anc = re.sub('\s+',' ',anc)
    anc = re.sub('[%s]'%string.punctuation, '', anc).strip('\r\t\n ')
    if not anc: return True
    if anc in exactmatchset: return True
    if re.findall('^(%s)'%('|'.join(startswithset)),anc): return True
    #if re.findall('(%s)$'%('|'.join(endswithset)),anc): return True
    if re.findall('(%s)'%('|'.join(anywhereset)),anc): return True
    
    return False

def BadTitle(title):
    tmp = title.strip('%s\r\t\n '%string.punctuation)
    return not tmp or len(tmp) > 36

v1features = ['titlelength','topanchorlength','topanchorweight','anchorweightentropy','titlebars']

v2features = ['titlewordcnt','topanchorwordcnt','topanchorwtratio','top2ndwtratio']

v3features = ['urltitleoverlap','urltopanchoroverlap','topanchortitleoverlap']

def printheaders():
    print '\t'.join(['clicks','domain','url','bingtitle','pagetitle','newpagetitle','topIntAnc','label'] + v1features + v2features + v3features+ 
            ['newintanc','newextanc','intanc','extanc'])

def UtfFix(s):
    try:
        ret = str(s)
    except:
        try:
            ret = str(s.decode('utf8','ignore')) 
        except:
            ret = to_bytes(s)
   
    
    return re.sub('[\t\n]',' ',ret)

def RemovePlural(word):
    if not word or not word.endswith('s') or len(word) == 1: return word
    elif not word[-2] in ['f','j','s','x','z']: return word[:-1]
    else: return word


stopwords = set(['a','an','and','are','is','at','be','by','for','from','has','he','in',
            'is','it','its','of','on','that','the','to','was','were','will','with'])

def GetFeatures(clicks,domain,url,bt,title,intanc,extanc, newtitle, newintanc, newextanc):
    #clicks, domain, ql, bingtitle, pagetitle, IntAnc, ExtAnc, newpagetitle, NewIntAnc, NewExtAnc

    urlroot = re.sub('^https?://','',url.lower()).split('/')[0]
    urlrootset = set(urlroot.split('.'))
    urldomsuffix = re.sub('^www[0-9]?\.','',re.sub('^https?://','',domain.lower()).split('/')[0])
    urldomsuffixset = set(urldomsuffix.split('.'))
    subdomain = urlroot[:- ( len(urldomsuffix) + 1)] if urldomsuffix in urlroot else ''
    
    
    #rawIntAnc = [t for t in intanc if not BadAnchor(t[0])]
    rawIntAncNew  = [t for t in newintanc if not BadAnchor(t[0])]

    #rawExtAnc = [t for t in extanc if not BadAnchor(t[0])]
    rawExtAncNew  = [t for t in newextanc if not BadAnchor(t[0])]


    title2 = re.sub('\s+',' ',re.sub('<.*?>','',newtitle.lower()))
    titlewords = re.split('[^a-zA-Z0-9]+',title2)
    titleacronym = ''.join(t[0] for t in titlewords if len(t) > 0)
    if not titleacronym: titleacronym = None
    nurl = normalize(url)
    urltip = re.sub('\..*$','',nurl.split('/')[-1]).lower() if '/' in nurl else nurl.split('.')[0] 
    
    urlset = set(map(RemovePlural,re.split('(?:%[0-9][0-9]|[^a-zA-Z0-9]+)',urltip)))
    
    titleset = set(map(RemovePlural,titlewords))
    topanchorwords =None if not rawIntAncNew else re.split('[^a-zA-Z0-9]+',rawIntAncNew[0][0].lower())

    topanchoracronym = None if not ( rawIntAncNew and topanchorwords ) else ''.join(t[0] for t in topanchorwords if len(t) > 0)
    if not topanchoracronym: topanchoracronym = None

    IntAnc = [set(map(RemovePlural,re.split('[^a-zA-Z0-9]+',s[0].lower()))) for s in rawIntAncNew] 

    ExtAnc = [set(map(RemovePlural,re.split('[^a-zA-Z0-9]+',s[0].lower()))) for s in rawExtAncNew] 

    if not bt == None:   # signal train or test mode

        bingtitle = set(map(RemovePlural,re.split('[^a-zA-Z0-9]+',re.sub('<.*?>','',bt.lower()))))

        intitle = int( bingtitle.issubset(titleset.union(urldomsuffixset)))
        inurl = int(bingtitle.issubset(urlset.union(urldomsuffixset)))
      
        # stop words takes care of Terms & Conditions versus Terms and Conditions, however it may be dangerous
        intvec = [int(bingtitle.issubset(t.union(urldomsuffixset).union(stopwords))) for t in IntAnc]
        
        extvec = [int(bingtitle.issubset(t.union(urldomsuffixset).union(stopwords))) for t in ExtAnc]

        #target
        if intitle:
            if intvec and intvec[0]: target = 0
            else: target = 1
        elif intvec and intvec[0]:
            target = -1
        else: target = -2

    else:   # test mode
        target = -3


    # features
    titlelength = len(title2)
    titlewordcnt = len(titleset)
    topanchorwordcnt = -1 if not IntAnc else len(IntAnc[0])
    topanchorlength = -1 if not rawIntAncNew else len(rawIntAncNew[0][0])
    totalwt = sum(s[1] for s in rawIntAncNew)
    topanchorweight = -1 if not rawIntAncNew else rawIntAncNew[0][1]
    topanchorwtratio = -1 if not rawIntAncNew else topanchorweight * 1.0 / totalwt
    top2ndwtratio  = -1 if len(rawIntAncNew) < 2 else rawIntAncNew[0][1] * 1.0 / rawIntAncNew[1][1]
    urltitleoverlap = len([t for t in titleset if t in urltip]) * 1.0 / len(titleset)

    urltopanchoroverlap = -1 if not IntAnc else len([t for t in IntAnc[0] if t in urltip]) * 1.0 / len(IntAnc[0])
    
    topanchortitleoverlap = -1 if not IntAnc else len(IntAnc[0].intersection(titleset)) * 1.0 / len(IntAnc[0])

    anchorweightentropy = entropy([t[1] for t in rawIntAncNew])
    titlebars = title2.count('|') 

    return '\t'.join(map(UtfFix,[clicks,domain, url, bt, title, newtitle, '' if not rawIntAncNew else rawIntAncNew[0][0],target]
        + map(eval, v1features + v2features + v3features ))  + [json.dumps(rawIntAncNew),json.dumps(rawExtAncNew), json.dumps(intanc),json.dumps(extanc)] )


"""
for i,line in enumerate(sys.stdin):
    clicks,domain,url,bt,title,intanc,extanc, newtitle, newintanc, newextanc = line.strip('\n').split('\t')

    
    print GetFeatures(clicks,domain,url,bt,title,intanc,extanc, newtitle, newintanc, newextanc)
"""

if __name__ == '__main__':
    fn = sys.argv[1]
    args = ''
    if len(sys.argv) > 2:
        args = ','.join(['"%s"'%t for t in sys.argv[2].strip('\r\t\n ').split(',')])
    ret = eval('%s(%s)'%(fn,args))
    if ret: print ret
