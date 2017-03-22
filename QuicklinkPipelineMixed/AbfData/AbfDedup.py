#!/usr/bin/env python
# goal is to clean up the quicklinks scraped from ABF
# caveat: for www.facebook.com/login.php and mobile.facebook.com/login.php, we do not combine the two quicklinks, because their titles may be different
import sys,re,math,logging
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
sys.path.append('../addtitles')
from genLibs import normalize, stdgen, fixstr
from DecideTitle import BadAnchor

goodsuffixes = 'ognc|aspx|html|htm|jsp|gsp|tmpl|php'.split('|')
url_delimiter = ['/','\?','&','=','\$','@',';',':',',','\+']
urldelim  = '|'.join(url_delimiter)
word_delimiter = '|'.join(['\+','-','_'])

def hasManyTokenNode(url):
    return max(int(len(re.split(word_delimiter, n) ) > 5) for n in url.strip('/').split('/')) == 1

tlds = ['com','gov','net','org','edu','co.uk','uk','ca','jp','us','mil','nl']

prepositions = set(['in','for','of','with','to','from','on','at','by'])

def is_ascii(s):
    try: 
        s.decode('ascii')
        return True
    except UnicodeDecodeError: 
        return False



def TitleBeautify(title,ndomroot):
    # test re.sub('&(amp;)+','&', 'a &amp;amp; b') => a & b
    return re.sub('&(amp;)+','&',re.sub('_', ' ', RemoveCompanyName(title,ndomroot)))

def SkipBadTitle(title):
    if not title.strip('[^a-zA-Z0-9]'): return True 
    elif not title.is_ascii(): return True
    elif max(int(t in titletokens) for t in ['invalid','click','next','back','index', 'default', 'page', '404']) == 1:
        return True
    elif 'not found' in title:
        return True
    elif title.isdigit() and not len(title) == 4: return True

     

def RemoveCompanyName(title,ndomroot):
    # does a simple extraction; no complicated cases like pof = plenty of fish
    companyname = None
    for end in tlds:
        if ndomroot.endswith(end):
            companyname = ndomroot[:-(len(end)+1)].split('.')[-1].lower()
            break
    if not companyname: return title
    tsplit = re.split('\s+',title)
    tlower = [t.lower() for t in tsplit]
    if not companyname in tlower: return title
    idx = tlower.index(companyname)
    if idx > 0 and tlower[idx-1] == 'my': return title
    if len(tlower) > idx+1 and ( not tlower[idx+1].isalnum() or tlower[idx+1] in prepositions ): tsplit.pop(idx+1)
    tsplit.pop(idx)
    if not idx == 0 and ( not tlower[idx-1].isalnum() or tlower[idx-1] in prepositions ): tsplit.pop(idx-1)
    return ' '.join(tsplit)


def QlPostProcess(ndom,inputbag,strong=True,nitems=10,sortby=3, dedup=True, beautify=True):
    # default sortby is ctr
    # inputbag has the same format as output schema
    # processes: 
    # 1. title dedupping 
    # 2. remove long urls
    # 3. remove .xyz where xyz not in ognc|aspx|html|htm|jsp|gsp|tmpl
    # 4. only show one mail, login, locator, menu
    ret = []
    strong = eval(str(strong))
    if not inputbag: return ret
    
    inputbag = sorted(inputbag, key = lambda t:float(t[sortby]), reverse=True)
    titleset = set()
    keydict = {}
    parentdict = {}
    urlset = set()
    #mail, login, locator, menu = False, False, False, False
    domain = inputbag[0][0].lower()
    domain2 = re.sub('[^a-zA-Z0-9]','',domain)
    #ndom = normalize(domain)
    ndomroot = ndom.split('/')[0]
    backups = []
    for i,rec in enumerate(inputbag):

        if not rec[2] and dedup: continue
        if beautify: 
            rec[2] = TitleBeautify(rec[2],ndomroot)
        if not dedup:
            ret.append(rec)
            continue


        title = rec[2].lower().strip('\t\r\n ')
        if BadAnchor(title, rec[1],debug=True): continue
        
        tmptitle = ''.join([t for t in re.split('[^a-zA-Z0-9]+',re.sub('</?b>','',title)) if t])
        if tmptitle in titleset:
            continue
        


        titletokens = re.split('\s+',title)
        if max(int(t in titletokens) for t in ['invalid','click','next','back','index', 'default', 'page']) == 1: continue
        cont = False
        for suffix in ['htm','jpg','jpeg','pdf','xml','doc','mp3'] + tlds:
            if '.' + suffix in title: 
                backups.append(rec)
                titleset.add(tmptitle)
                titleset.add(tmptitle.strip('s'))
                cont = True
        if cont: continue
        if title.startswith('?'): continue
        if title.isalnum() and not title.isalpha(): 
            backups.append(rec)
            titleset.add(tmptitle)
            titleset.add(tmptitle.strip('s'))
            continue
        if strong: title = ''.join([t for t in re.split('[^a-zA-Z0-9]+',re.sub('</?b>','',title)) if t])
        #if max([ int(title in t or t in title) for t in titleset ] + [0] ) == 1: continue
        #if max([ int(title == t) for t in titleset ] + [0] ) == 1: continue

        ql = rec[1].lower()
        nql = normalize(ql)
        if nql in urlset: continue
        if '/' in nql:
            qltip = nql.split('/')[-1]
            #if not '?' in qltip and '.' in qltip and not qltip.split('.')[-1] in goodsuffixes: continue
        if hasManyTokenNode(ql): 
            backups.append(rec)
            titleset.add(tmptitle)
            titleset.add(tmptitle.strip('s'))
            continue
        title2 =re.sub('[^a-zA-Z0-9]','',title)
        if len(title2) < 2: 
            backups.append(rec)
            titleset.add(tmptitle)
            titleset.add(tmptitle.strip('s'))
            continue

        cont = False
        for k in ['mail','(login|logon|signin|signon)','signup','menu','about','contact','(map|direction|locator|location)']:
            if not re.findall(k,domain2) and re.findall(k,title2):
                if k in keydict: cont = True
                keydict[k] = nql
        if cont: continue
        #if re.findall('(login|logon|signin|signon)',title2): rec[2] = 'Log In'
        parent = re.sub('/[^\/]*$','',nql)

        if parentdict.setdefault(parent, 0) > 2 and not parent == ndom: 
            backups.append(rec)
            titleset.add(tmptitle)
            titleset.add(tmptitle.strip('s'))
            continue
        parentdict[parent] += 1
        ret.append(rec)
        if not nitems == -1 and len(ret) >= nitems: break
        titleset.add(tmptitle)
        titleset.add(tmptitle.strip('s'))
        urlset.add(nql)

    if nitems == -1: return ret
    return ret + backups[:nitems - len(ret)]

def reverseDict(swapdict):
    return dict([(b,a) for a,b in swapdict.items()])

def colSwap(data,swapdict,reverse=False):
    # {0:2,2:0} with reverse True or False means swap column 0 and 2
    if reverse: swapdict = reverseDict(swapdict)
    return [data[swapdict.get(i,i)] for i in xrange(len(data))]

if __name__ == "__main__":

    # input cols
    """parent_url   url ql_txt  bucid   nviews  nviews_cond nclicks nviews_dom  nclicks_dom ctr ctr_cond"""
    # QlPostProcess required cols
    """domain   ql  title   score"""
    nitems = -1
    if len(sys.argv) > 1:
        nitems = int(sys.argv[1])
    dedup = True
    if len(sys.argv) > 2:
        dedup = eval(str(dedup))
    beautify = True
    if len(sys.argv ) > 3:
        beautify = eval(str(beautify))
    scoreidx = 6
    if len(sys.argv )> 4:
        scoreidx = int(sys.argv[4])

    if len(sys.argv) > 5:   # for debugging purpose
        mode = sys.argv[5]

    swapDict = {scoreidx:3,3:scoreidx}
    revSwapDict = reverseDict(swapDict)
    
    if mode == 'debug':
        pd = None
        for line in stdgen('None2\tNone2\tNone2\t0.0'):
            # domain ql title score
            tmp = line.strip('\n').split('\t')
            domain, ql, title = tmp[:3]
            score = float(tmp[3])
            ndom = normalize(domain)
            if not pd == ndom:
                if not pd == None:
                    print '\n'.join('\t'.join(map(str,t)) for t in QlPostProcess(ndom,inputbag,strong=True,nitems=10,sortby=3, dedup=True, beautify=True))
                inputbag = []
                pd = ndom
            inputbag.append([domain, ql, title, score])

    else:
        pd = None
        for line in stdgen(('None\t' * 11)[:-1]):

            tmp = line.strip('\n').split('\t')
            domain = tmp[0]
            if domain == 'unknown': continue
            if not pd == domain:
                if not pd == None:
                    ndom = normalize(pd)
                    printbag = [colSwap(t,revSwapDict) for t in QlPostProcess(ndom,inputbag,strong=True,nitems=nitems,sortby=3, dedup= dedup, beautify = beautify)]
                    if printbag:
                        # recalc nclicks_dom and nviews_dom 
                        nclicks_dom = str(sum(float(t[6]) for t in printbag))
                        nviews_dom = str(sum(float(t[4]) for t in printbag))
                        for i in xrange(len(printbag)):
                            printbag[i][8] = nclicks_dom
                            printbag[i][7] = nviews_dom

                        print '\n'.join(['\t'.join(t) for t in printbag])

                inputbag = []
                pd = domain
            if domain in ['None']: break
            inputbag.append(colSwap(tmp,swapDict))
