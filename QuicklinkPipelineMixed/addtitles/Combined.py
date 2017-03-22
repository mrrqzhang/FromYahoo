#!/usr/bin/env python

import sys,re,math,string,logging,heapq,time
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
import simplejson as json
from GenTrainToken import GetFeatures
import unidecode    # approximate conversion to ascii
from genLibs import ConservativeNormalize as normalize
from stemming.porter2 import stem
from kitchen.text.converters import getwriter, to_bytes, to_unicode
import xml.etree.ElementTree as et
#import regex
def stdgen(lastline):
    for line in sys.stdin:
        yield line
    yield lastline


"""
anchor cleaning
"""

stopwords = set(['a','an','and','are','is','at','be','by','for','from','has','he','in',
            'is','it','its','of','on','that','the','to','was','were','will','with'])
mode = 'train'
if len(sys.argv) > 1:
    jsfile = sys.argv[1]
    with open(jsfile) as f:
        clickdict = json.loads(f.readline())
else:
    clickdict = {}
    mode = 'test'


def ud(s):
    if s == None: return s
    s = re.sub('\n','\\n',re.sub('\t','\\t',s))
    try:
        return unidecode.unidecode(s.decode('utf-8','ignore'))
    except:
        return unidecode.unidecode(s)

def extractCompanyName(domain):
    try:
        domain = re.sub('https?://','',domain)
        domain = domain.split('/')[0] 
        numParts = domain.count('.')+1
        candidate1 = re.findall('([^.]*)\.(go.com|com|co\.[^.]*$|ca$|org$|edu$|..\.gov$|net$|info$|k12[.$]|state[.$]|mu[$.])', domain)
        # espn.go.com, abc.go.com
        # remaining issues: txdps, N.J. Transit 
        candidate2 = re.findall('([^.]+)\.[^.]*\.[^.]*$', domain)
        candidate3 = re.findall('([^.]*)\.[^.]*$', domain)

        if candidate1:
            ret = candidate1[0][0]
        elif candidate2 and numParts > 3:
            ret=  candidate2[0]
        else:
            ret = candidate3[0]
        return re.sub('\W','',ret)   
    except:
        raise ValueError(domain)
    

def maxMatchIdx(word1,word2):
    # assume both words lowercase, find the maximal overlapping init segment length
    i = 0 
    minlen = min(len(word1),len(word2))
    while i < minlen and word1[i].lower() == word2[i].lower():
        i += 1
    return i


def maxInitMatch(tokens, companyName):
    rem = companyName
    ret = []
    for t in tokens:
        i = maxMatchIdx(t,rem)
        ret.append(re.escape(t))
        if i ==0: return False
        else:
            rem = rem[i:]
            if rem == '':
                return ret

def fuzzyMatch(title, companyName):
    # companyName:nyphil versus title:New York Philharmonic
    # companyName:newyorkmedcenter versus title: New York Medical Center
    titletokens = re.split('[\s\-.]+',title)
    nt = len(titletokens)
    for i in xrange(nt):
        res = maxInitMatch(titletokens[i:], companyName)
        if res:
            return res
    return [companyName]

def acronymMatch(title, companyName):
    # returns acronym-matched company name and companyAliasTokens
    j = len(companyName)
    if j > 1:
        titletokens = re.split('[\s\-]+',title)
        nt = len(titletokens)
        for i in xrange(0, nt - j + 1, 1):
            if min([int(re.match('\W',t) == None) for t in titletokens[i:i+j]]) == 1:
                if ''.join([t[0] for t in titletokens[i:i+j] if len(t) > 0]).lower() == companyName:
                    tmp = [re.escape(t) for t in titletokens[i:i+j]]
                    if len(tmp) == j:
                        return tmp
    return fuzzyMatch(title,companyName)    # if acronym match fails, do fuzzy
   

def splitMatch(title, companyName):
    # try to detect "verizons" in "verizons login" for verizonwireless
    # return a list of unicode escape consecutive tokens
    ret = fuzzyMatch(title,companyName)
    if not ret == [companyName]: return ret
    titletokens = re.split('[\s\-.]+',title)
    alphanumtokens = [re.sub('\W+$','',t) for t in titletokens] 
    stemmedtokens = [stem(t) for t in alphanumtokens]
    nt = len(titletokens)
    for j in xrange(nt, 0, -1):
        for i in xrange(0, nt - j + 1, 1):
            for tokens in [titletokens, alphanumtokens, stemmedtokens]:
                if min([int(len(t) > 2) for t in tokens[i:i+j]]) == 1 or j > 1 or ''.join(tokens[i:i+j]).lower() == companyName.lower():
                    # make sure every token has length at least 3
                    # also no special characters to confound the regex below
                    combined = ''.join(tokens[i:i+j])
                    regex = re.compile(re.escape(re.sub('\W','',combined)), re.I)

                    if regex.findall(companyName):
                        tmp = [re.escape(t.lower()) for t in titletokens[i:i+j]]
                        if len(tmp) == j:
                            return tmp
    # default returns a single-word AliasTokenList
    return [companyName]

def aliasMatch(title, companyName, companyAliasTokens):
    for t in companyAliasTokens:
        combine = re.compile(''.join(t), re.I) 
        match = combine.match(title)
        if match:
            return match.group(0)
        try:
            acronym = re.compile(re.sub('\W','',''.join([s[0] for s in t])), re.I)
            match = acronym.match(title)
            if match:
                return match.group(0)
        except:
            continue
    return companyName


def processTitle(title, domain, ql_url, maxLength, companyAliasTokens = [], useAlias = False):
    # remove all urls containing companyName?
    companyName = extractCompanyName(domain)
    match = splitMatch(title,companyName)
    companyName2 = '[\s\-.]+'.join(match)
    if companyName2 == companyName:
        match= acronymMatch(title, companyName)
        companyName = '[\s\-.]+'.join(match)
        
        if companyName == companyName2 and useAlias:
            companyName = aliasMatch(title, companyName, companyAliasTokens)    # a single alias

        else:
            # acronym Match
            noSpecialChar = (None == re.match('\W', ''.join(match)))
            match = [t for t in match if re.sub('[^a-zA-Z]','',t)]
            if noSpecialChar and len(match) > 1 and not match in companyAliasTokens:
                companyAliasTokens.append(match)
    else:
        # split Match
        noSpecialChar = (None == re.match('\W', ''.join(match)))
        match = [t for t in match if re.sub('[^a-zA-Z]','',t)]
        if noSpecialChar and len(match) > 1 and not match in companyAliasTokens:
            companyAliasTokens.append(match)
        companyName = companyName2
    title = re.sub('\s+',' ',title)
    if max([int(t in title.lower()) for t in ['log in','log on','sign in','sign on']]) == 0:
        try:
            regex = re.compile('((my|on|to|from|in) )?(https?://)?[^\s/]*%s[^\s/]*/?'%companyName, re.I)
            title = regex.sub('', title)
        except Exception, e:
            #logging.error(traceback.format_exc() + '; companyName = %s'%companyName)
            title = title
        

    #regex = re.compile('(https?://)?[^\s/]*%s[^\s/]*/?'%companyName, re.I)
    #title = regex.sub('',title)
    title = re.sub('\s+',' ',title)
    title = re.sub(' \W$','',title).strip('\r\t\n ')

    n =len(title)
    spaces = [i for i,c in enumerate(title) if c == ' ' and i < maxLength-2]
    if n > maxLength-2:
        if spaces: lastSpace = spaces[-1]
        else:   lastSpace = maxLength-2
        title = title[:lastSpace].strip('\r\t\n\.\/\+\_;><\-\| ') + '..'
    else: title = title.strip('\r\t\n\/\.\+\_;><\-\| ')

    if not set(title.lower().split(' ')).difference(stopwords): title = ''  # if only stop words, remove the title candidate

    return title, companyAliasTokens


def getTitlesUnderDomain(domain, quicklinks, maxLength):
    # quicklinks = [(url1,[(wt1,t1),(wt2,t2),..]), (url2: [(wt1,t1),..])]
    # output = ((ql_url1, [[anc1,wt1],[anc2,wt2],..]),..)
    ret2 = []
    companyAliasTokens  =[]
    for ql_url, titleweight in quicklinks:
        intanc = []
        for title,weight,lang in titleweight:
            title = ud(title)
            ptitle,companyAliasTokens = processTitle(title,domain, ql_url, maxLength,companyAliasTokens,useAlias =False) 
            intanc.append((ptitle,weight,lang))
        #ret2.append((ql_url, json.dumps(intanc)))
        ret2.append((ql_url, intanc))
    if (not companyAliasTokens == []):

        ret2= []

        for ql_url, titleweight in quicklinks:
            intanc=[]
            for title,weight,lang in titleweight:
                title = ud(title)
                ptitle,companyAliasTokens = processTitle(title,domain, ql_url, maxLength, companyAliasTokens, useAlias =True) 
                intanc.append((ptitle, weight,lang))
            #ret2.append((ql_url, json.dumps(intanc)))
            ret2.append((ql_url,intanc))
    return ret2


"""
pagetitle cleaning
"""


def RemoveRepeatedPhrase(pagetitles):
    phrasecnt = {}
    ptlist = []
    for pt in pagetitles:
        # keep the separators along with separated items
        pt2 = [t for t in re.split('((?: - |\||[^a-zA-Z0-9 %s]|[a-zA-Z0-9]*(?:<<|>>)[a-zA-Z0-9]*|:|,|>|[a-zA-Z0-9]*\*[a-zA-Z0-9]*))'%string.punctuation,pt)]
        pt3 = [pt2[2*i+1] for i in xrange(len(pt2) / 2)] + ['']
        pt2 = [pt2[2*i] for i in xrange(len(pt2) / 2 + 1)]
        pt3 = [t for t,s in zip(pt3,pt2) if s.strip('\r\t\n ')]
        pt2 = [s for s in pt2 if s.strip('\r\t\n ')]
        ptlist.append((pt2,pt3))
        for phrase in pt2:
            if not phrase in phrasecnt: phrasecnt[phrase] = 0
            phrasecnt[phrase] += 1
    repeated = set([k for k,v in phrasecnt.items() if v > 1])
    ret = []
    for pt2,pt3 in ptlist:
        tmp = [(p2,p3) for (p2,p3) in zip(pt2,pt3) if not p2 in repeated]
        tmplen = len(tmp)
        ret.append(''.join((p2 if i == tmplen -1 else '%s%s'%(p2,p3)) for i,(p2,p3) in enumerate(tmp)))
    return ret

def PhraseMatchDomain(domain, phrase):
    tmp = re.split('[^a-zA-Z0-9]+',phrase.lower())
    domvec = [int(t in domain) for t in tmp if t.strip('\r\t\n ')]
    if min([1] + domvec): return True
    return False

def RemoveCompanyNamePhrase(domain,pagetitles):
    ret = []
    for pt in pagetitles:
        pt2 = [t for t in re.split('((?: - |\||[^a-zA-Z0-9 %s]|[a-zA-Z0-9]*(?:<<|>>)[a-zA-Z0-9]*|:|,|>|[a-zA-Z0-9]*\*[a-zA-Z0-9]*))'%string.punctuation,pt)]
        pt3 = [pt2[2*i+1] for i in xrange(len(pt2) / 2)] + ['']
        pt2 = [pt2[2*i] for i in xrange(len(pt2) / 2 + 1)]
        pt3 = [t for t,s in zip(pt3,pt2) if s.strip('\r\t\n ')]
        pt2 = [s for s in pt2 if s.strip('\r\t\n ')]
        tmp = [(p2,p3) for (p2,p3) in zip(pt2,pt3) if not PhraseMatchDomain(domain, p2)]
        tmplen = len(tmp)
        ret.append(''.join((p2 if i == tmplen -1 else '%s%s'%(p2,p3)) for i,(p2,p3) in enumerate(tmp)))
    return ret

pd = None


printheaders = 0


if printheaders:
    print '\t'.join(['clicks','domain','ql','bingtitle','pagetitle','intanc','extanc','newpagetitle','newintancs','newextancs'])

pts = None
for line in stdgen('domain\tql\tredt\tpagetitle\twmdata\tbingtitle'):

    
    line = line.strip('\n')
    if line.count('\t') > 5: line = line.strip('\t')
    tmp = line.split('\t')
    domain, ql, redt, pagetitle, wmdata = tmp[:5]
    if len(tmp) > 5:
        bingtitle = tmp[5]
    else:
        bingtitle = None
    nurl = normalize(ql)
    clicks  = str(clickdict.get(nurl,0.0))
    bingtitle = ud(bingtitle)
    pagetitle = ud(pagetitle)

    if not pd == domain:
        if not pd == None:
            ts = float(time.time())
            if not pts == None:
                deltaT = ts - pts
                if deltaT > 1000:
                    logging.warning('long duration domain: %s; duration = %f'%(pd,deltaT))
            pts = ts     

            newpagetitles = RemoveRepeatedPhrase(pagetitles)
            newpagetitles = RemoveCompanyNamePhrase(pd,newpagetitles)


            newanchors = getTitlesUnderDomain(pd, quicklinks, 100)

            for oc,np,na,az in zip(othercolumns, newpagetitles,newanchors,ancsizes):
                na = na[1] 
                nia = na[:az]
                nea = na[az:]
                # input = clicks, domain, ql, bingtitle, pagetitle, IntAnc, ExtAnc, newpagetitle, NewIntAnc, NewExtAnc
                print GetFeatures(* ( oc + [np, nia, nea]))
        othercolumns = []
        ancsizes = []
        quicklinks = []
        pagetitles = []
        nurls =[]
        pd = domain
    if domain == 'domain': continue
    if nurl in nurls: continue
    nurls.append(nurl)
    linkdict = {'int':[],'ext':[]}

    wmdlen = len(wmdata)
    if wmdlen > 1000000:
        try:
            logging.warning('long wmdata for %s'%ql) 
        except:
            logging.warning('long wmdata, ql cannot be displayed!')
        # use regex to get some of the anchor texts
        """
        <LINKS type="int"><AT weight="3.00" lang="en">Burst</AT><AT weight="1.00" lang="en">Burst.net</AT></LINKS><LINKS type="ext"><AT weight="0.50" lang="en">BurstNET Fraudsters</AT><AT weight="0.50" lang="en">BurstNET Scammers</AT></LINKS>
        """
        for linktype in ['int','ext']:
            loc = wmdata.find('<LINKS type="%s">'%linktype)
            if not loc == -1:
                ancdata = ud(wmdata[loc:loc+10000])
                for weight, lang, anchortext in re.findall('<AT weight="([^"]*)" lang="([^"]*)">(.*?)</AT>',ancdata):
                    linkdict[linktype].append((anchortext, float(weight), lang))
        
    else:
        root = et.fromstring(wmdata)
        for link in root.iter("LINKS"):
            for anchor in link.iter("AT"):
                linkdict[link.get('type')].append((ud(anchor.text), float(anchor.get('weight')),ud(anchor.get('lang','en'))))
    
    IntAnc = heapq.nlargest(20, linkdict['int'],key = lambda t:t[1])
    #IntAnc = sorted(linkdict['int'],key =lambda t:t[1], reverse=True)
    ExtAnc = heapq.nlargest(20, linkdict['ext'],key = lambda t:t[1])
    #ExtAnc = sorted(linkdict['ext'],key =lambda t:t[1], reverse=True)


    #IntAnc = [set(re.split('[^a-zA-Z0-9]+',s[0])) for s in rawIntAnc]

    quicklinks.append((ql,IntAnc + ExtAnc))
    ancsizes.append(len(IntAnc))    # to distinguish between internal and external anchors after cleaning
    othercolumns.append([clicks,domain,ql,bingtitle,pagetitle,IntAnc,ExtAnc])
    pagetitles.append(pagetitle)

