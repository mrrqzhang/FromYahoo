#!/usr/bin/env python

import sys,re,math,string
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
import simplejson as json
import unidecode    # approximate conversion to ascii
from genLibs import ConservativeNormalize as normalize
from stemming.porter2 import stem
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


def ud(s):
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
            if noSpecialChar and len(match) > 1 and not match in companyAliasTokens:
                companyAliasTokens.append(match)
    else:
        # split Match
        noSpecialChar = (None == re.match('\W', ''.join(match)))
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
        for title,weight in titleweight:
            title = ud(title)
            ptitle,companyAliasTokens = processTitle(title,domain, ql_url, maxLength,companyAliasTokens,useAlias =False) 
            intanc.append((ptitle,weight))
        #ret2.append((ql_url, json.dumps(intanc)))
        ret2.append((ql_url, intanc))
        if (not companyAliasTokens == []):
            ret2,intanc = [],[]
            for ql_url, titleweight in quicklinks:
                for title,weight in titleweight:
                    title = ud(title)
                    ptitle,companyAliasTokens = processTitle(title,domain, ql_url, maxLength, companyAliasTokens, useAlias =True) 
                    intanc.append((ptitle, weight))
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
if len(sys.argv) > 1:
    printheaders = int(sys.argv[1])

if printheaders:
    print '\t'.join(['clicks','domain','ql','bingtitle','pagetitle','intanc','extanc','newpagetitle','newintancs','newextancs'])


for line in stdgen('0.0\tdomain\t' + '\t'.join(['None'] * 5)):
    clicks, domain, ql, bingtitle, pagetitle, intanc, extanc = line.strip('\n').split('\t')
    bingtitle = ud(bingtitle)
    pagetitle = ud(pagetitle)

    if not pd == domain:
        if not pd == None:
            newpagetitles = RemoveRepeatedPhrase(pagetitles)
            newpagetitles = RemoveCompanyNamePhrase(pd,newpagetitles)
            newanchors = getTitlesUnderDomain(pd, quicklinks, 100)
            assert len(othercolumns) == len(newpagetitles) and len(othercolumns) == len(newanchors) and len(othercolumns) == len(ancsizes)
            for oc,np,na,az in zip(othercolumns, newpagetitles,newanchors,ancsizes):
                na = na[1] 
                nia = na[:az]
                nea = na[az:]
                print '\t'.join(oc + [np, json.dumps(nia),json.dumps(nea)])
        othercolumns = []
        ancsizes = []
        quicklinks = []
        pagetitles = []
        pd = domain
    if domain == 'domain': continue
            
    IntAnc = json.loads(intanc)
    ExtAnc = json.loads(extanc)
    quicklinks.append((ql,IntAnc + ExtAnc))
    ancsizes.append(len(IntAnc))    # to distinguish between internal and external anchors after cleaning
    othercolumns.append([clicks,domain,ql,bingtitle,pagetitle,intanc,extanc])
    pagetitles.append(pagetitle)
