import sys,re,math,unicodedata,logging
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
try: import simplejson as json
except ImportError: import json
from genLibs import normalize,GbdtModelJson,TestModel,TestFV,stopwords
badwordset = stopwords.union(['visit','site','website']) 
headers = ['clicks','domain','ql','bingtitle','pagetitle','intanc','extanc','newpagetitle','newintancs','newextancs']

v1features = ['titlelength','topanchorlength','topanchorweight','anchorweightentropy','titlebars']

v2features = ['titlewordcnt','topanchorwordcnt','topanchorwtratio','top2ndwtratio']

v3features = ['urltitleoverlap','urltopanchoroverlap','topanchortitleoverlap']

basicinfo = ['clicks','domain','url','bingtitle','pagetitle','newpagetitle','newTopIntAnc','label'] 

lastfour = ['newintanc','newextanc','intanc','extanc']

titlelength = 40    # changed from 30

titlecutoff = 25



def StandardCap(word):
    if '/' in word or '.' in word: return word
    elif not word.isupper(): return word[0].upper() + word[1:].lower()
    else: return word

def TitleBeautify(title):
    # remove beginning and trailing non alphanumeric symbols
    title = re.sub('((?:^[^a-zA-Z0-9\!\?]*|[^a-zA-Z0-9\!\?]*$))','',title)
    if not re.findall('[a-zA-Z0-9]',title) or not title: return ''
    ret = re.sub('_',' ',title)
    ret = re.sub(r' -([a-zA-Z0-9])',r' - \1',ret)  
    # http://www.google.com/  http://answers.google.com/answers/threadview/id/785639.html     785639
    ret = ' '.join([StandardCap(t) for t in re.split('\s+',ret) if t])
    if len(ret) <= titlecutoff: return ret

    while len(ret) > titlecutoff:
        ret = ' '.join(ret.split(' ')[:-1])   
    if '(' in ret and not ')' in ret: ret = ret + ')'
    if not ret: return ''
    
    return ret + ' ...'

def BadAnchor(anchor,url=None, tl = titlelength,debug=False):
    anchor = anchor.strip('\r\t\n ')
    anchor_alnum = re.sub('[^a-zA-Z0-9]','',anchor)
    spamwords = bool(set([t for t in anchor.lower().split(' ') if t]).difference(badwordset) == set())
    repeaturl = bool(normalize(anchor).lower() == normalize(url).lower()) if url else False
    urlchars= '[a-zA-Z0-9\-_\?\=\@]'
    isurl = bool(not re.findall('%s+\.%s+/%s+'%(urlchars,urlchars,urlchars),anchor) == [])
    number = bool(anchor_alnum.isdigit() and not ( anchor_alnum[:2] in ['19','20'] and len(anchor_alnum) == 4 ) )
    containsLongNumbers = not re.findall('[0-9]{5,6}',anchor_alnum) == [] # at least 5 digits 
    badchar = not ( re.findall('((?:^[^a-zA-Z0-9]|[^a-zA-Z0-9\.\!\?]$))', anchor) == [] )
    ret = badchar or isurl or number or containsLongNumbers or spamwords or repeaturl or len(anchor) > tl \
            or not anchor or re.findall('\?[a-zA-Z0-9]',anchor) or not re.findall('[a-zA-Z0-9]',anchor) \
            or re.findall('[a-zA-Z0-9]+/[a-zA-Z0-9]+\.[a-z]+',anchor) or re.findall(' (the|a)$(?i)',anchor)
    
    if debug:
        logging.warning('\t'.join(['url','anchor','badchar','isurl','number','containsLongNumbers', \
                'spamwords','repeaturl','anclength','anchor','qmark string', 'no alphanum','url string', \
                'end with articles']))
        logging.warning('\t'.join(map(str,[url, anchor, badchar, isurl, number, \
            containsLongNumbers, spamwords, repeaturl, len(anchor), anchor, \
            re.findall('\?[a-zA-Z0-9]',anchor), not re.findall('[a-zA-Z0-9]',anchor), \
            re.findall('[a-zA-Z0-9]+/[a-zA-Z0-9]+\.[a-z]+',anchor), re.findall(' (the|a)$(?i)',anchor)])))

    return ret

def BadPageTitle(newpagetitle, url=None, tl=titlelength):
    return BadAnchor(newpagetitle, url, tl=tl) #len(newpagetitle) > tl or not newpagetitle 


url_delimiter = ['/','?','&','=','$','@',';',':','+',',']

def remove_control_characters(s):
    #return "".join(ch for ch in s if unicodedata.category(ch)[0]!="C")
    #mpa = dict.fromkeys(range(32))
    #return s.translate(mpa)
    return "".join([i for i in s if ord(i) > 31])

def UrlTip(url):
    nurl = normalize(url)
    if not '/' in nurl: return nurl.split('.')[0]
    else: return nurl.split('/')[-1].split('.')[0]

def RemoveTrailingPreposition(anc):
    return re.sub(' (for|from|by|with|at|of)$(?i)','',anc)

def BackUpTitle(domain,url,newpagetitle,newintanc,newextanc,score,returnBadTip=False):
    # old page title
    urltip = UrlTip(url) 
    goodtip = True  # not a javascript query url
    # 0.0     http://www.google.com/  http://images.google.com/m      None    Google                  -3      0       -1      -1      -1.0    0       1       -1      -1      -1      1.0     -1      -1      []      [["images/m", 1.0, "en"], ["Images", 1.0, "en"], ["visit", 1.0, "en"]]  []      [["google images/m", 1.0, "en"], ["Google", 1.0, "en"], ["Google Images", 1.0, "en"], ["visit", 1.0, "en"]]
    # http://www.google.com/  http://images.google.com/m      M
    if re.findall('[\?=][a-zA-Z0-9]', urltip) or len(urltip) < 2: goodtip = False
    if not goodtip:
        if not BadPageTitle(newpagetitle): return newpagetitle
        else:
            newintanc =json.loads(newintanc)
            newextanc = json.loads(newextanc)
            for anc, wt,lang in newintanc + newextanc:
                anc = RemoveTrailingPreposition(anc) 
                if not BadAnchor(anc,url): return anc
    if goodtip or returnBadTip:

        #urltip2 = BreakByCap(urltip)
        urltip2 = SplitTip(urltip)
        if BadAnchor(urltip2, url): return ''
        #http://www.google.com/  http://productforums.google.com/d/topic/youtube/LWleKEX9Qto     L Wle K E X9 Qto
        if max([int(len(t) == 1 and t.isalpha() and not t.lower() in ['a','i'] ) for t in urltip2.split(' ')]) == 1: return ''
        elif not re.findall('[^a-zA-Z0-9\-_\.]',urltip): return re.sub('[^a-zA-Z0-9]+',' ',urltip2)
        else: return re.sub('\s+',' ',urltip2)
    else: return ''
    
def AnchorInTitle(newpagetitle,newintanc,newextanc,equal=False):
    ptlower = newpagetitle.lower()
    for js in [newintanc,newextanc]:
        newancs = json.loads(js)
        for anc, wt, lang in newancs:
            anc = RemoveTrailingPreposition(anc)
            if BadAnchor(anc): continue
            #if not re.sub('[^a-zA-Z]','',anc) or re.findall('?[a-zA-Z0-9]',anc): continue # anc must contain some letters
            if ( anc.lower() == ptlower ) or (not equal and anc.lower() in ptlower): return anc
    return None

def BreakByCap(urltip):
    if urltip.isupper() or not urltip or not urltip[0].isupper(): return urltip
    caps = [i for i,x in enumerate(urltip) if x.isupper()]
    return ' '.join(urltip[i:j] for i,j in zip(caps,caps[1:] + [len(urltip)]))

def SplitTip(tip):
    if '.' in tip or '/' in tip: return tip # keep url intact
    indices = [i for i,t in enumerate(tip) if i == 0 or  ( ( not t == ' ' )  and ( (t.isalpha() and t.upper() == t and not (tip[i-1].isalpha() and tip[i-1].upper() == tip[i-1]))  or ( t.isalpha() and not tip[i-1].isalpha()) or (t.isdigit() and not tip[i-1].isdigit()) ) ) ]
    indices.append(len(tip))
    ret = ' '.join(tip[indices[i]:indices[i+1]] for i in xrange(len(indices) -1))
    ret = re.sub('\s+',' ',ret)
    return ' '.join([t for t in ret.split(' ') if t ])



def FindTipAnchor(urltip, newintanc,newextanc):
    urltip = re.sub('[^a-zA-Z0-9]+',' ',urltip.lower())
    urltip2 = BreakByCap(urltip)
    uts = [urltip ] if urltip == urltip2 else [urltip, urltip2]
    for ut in uts:
        
        if max(len(k) for k in re.split('\s+',ut)) < 3: continue  # ex. ar-ar.facebook.com
        for js in [newintanc,newextanc]:
            newancs = json.loads(js)
            for anc, wt, lang in newancs:

                anc2 = re.sub('[^a-zA-Z0-9]+', ' ', RemoveTrailingPreposition(anc))
                if anc2.strip('s') == ut.strip('s'): return anc
    
    return None

def TopWtAnchor(js):
    newancs = json.loads(js)
    if not newancs: return None
    return max(newancs, key = lambda t:float(t[1]))


def FinalTitle(tmp,gbdtmodel,debug=False):    # post-processing module 
    feats = map(float,tmp[len(basicinfo):-len(lastfour)])
    _,domain,url,bingtitle,pagetitle,newpagetitle,newTopIntAnc,label = tmp[:len(basicinfo)]
    
    if pagetitle == 'None': pagetitle = ''
    if newTopIntAnc == 'None': newTopIntAnc = ''

    newintanc,newextanc = tmp[-len(lastfour):-2]
    topextanc = TopWtAnchor(newextanc)
    topintanc = TopWtAnchor(newintanc)
    if topextanc and not BadAnchor(topextanc[0],url) and (not topintanc or ( float(topextanc[1]) > 2 * float(topintanc[1]) and float(topextanc[1]) > 100)): newTopIntAnc = topextanc[0]
    newpagetitle = RemoveTrailingPreposition(newpagetitle)
    newTopIntAnc = RemoveTrailingPreposition(newTopIntAnc)
    #assert int(label) == -3 # test mode
    finaltitle = None
    tipAnc = FindTipAnchor( UrlTip(url), newintanc,newextanc)
    score = TestModel(dict(zip(featnames, feats)), gbdtmodel)
    if tipAnc: finaltitle = tipAnc
    else:
        anc = AnchorInTitle(newpagetitle,newintanc,newextanc,equal=True)
        if anc: finaltitle = anc
        elif score > 0:   # title wins
            #if set(re.split('\s+',newTopIntAnc.lower())).issubset(re.split('\s+',newpagetitle.lower())) and not BadAnchor(newTopIntAnc): finaltitle = newTopIntAnc
            anc = AnchorInTitle(newpagetitle,newintanc,newextanc,equal=False)
            if anc: finaltitle = anc
            elif not BadPageTitle(newpagetitle,url): finaltitle = newpagetitle
            elif not BadAnchor(newTopIntAnc,url) and not newTopIntAnc =='None': finaltitle = newTopIntAnc
            else: finaltitle = BackUpTitle(domain, url, newpagetitle, newintanc, newextanc,score)

        elif score <= 0: 

            if not BadAnchor(newTopIntAnc,url): finaltitle = newTopIntAnc
            elif not BadPageTitle(newpagetitle,url) and not newpagetitle == 'None': finaltitle = newpagetitle
            else: finaltitle = BackUpTitle(domain,url, newpagetitle, newintanc, newextanc,score)
    finaltitle = TitleBeautify(remove_control_characters(finaltitle))
    if finaltitle in ['',None]: return None
    ret = [domain, url, finaltitle ]
    if not int(label)== -3:
        ret.append(bingtitle) 
    if debug: ret.append(str(score))
    return ret

if __name__ == '__main__':
    if len(sys.argv ) > 1 and sys.argv[1] == 'test':
        fn = sys.argv[2]
        args = ''
        sep = ','    
        if len(sys.argv) > 4:
            sep = sys.argv[4]
        if len(sys.argv) > 3:
            args = sep.join(['"%s"'%t.replace('"','\\"') for t in sys.argv[3].strip('\r\t\n ').split(',')])
        ret = eval('%s(%s)'%(fn,args))
        if not ret in [None,'']:
            print ret
    else:
        modelxmlfile = sys.argv[1]

        debug = eval(str(sys.argv[2])) if len(sys.argv ) > 2 else False

        gbdtmodel = GbdtModelJson(modelxmlfile)

        featnames = [t.upper() for t in v1features + v2features + v3features]
        for line in sys.stdin:

            tmp = line.strip('\n').split('\t')
            ret = FinalTitle(tmp,gbdtmodel,debug)
            if ret:
                if not BadAnchor(ret[2]):
                    print '\t'.join(ret)

