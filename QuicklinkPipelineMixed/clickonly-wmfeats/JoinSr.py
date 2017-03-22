import sys,re,math
try: import simplejson as json
except ImportError: import json
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import ConservativeNormalize as normalize

mobiles = ['','m.','mobile.','touch.']

def FilterSr(nurl, srdict):
    """
    examples:
    1. nurl = m.facebook.com/help, then sr can be m.facebook.com, facebook.com, mobile.facebook.com, touch.facebook.com
    2. nurl = login.facebook.com/help, then sr can be m.facebook.com, mobile.facebook.com, touch.facebook.com, facebook.com, login.facebook.com
    output should be a small set of sr's
    3. nurl = fr.news.yahoo.com, parent = fr.yahoo.com
    srdict[domain] keys are assumed to be stripped of https?://, www., final slash, (index|default|home).[a-z]+  but not m., mobile., or touch. 
    """
    ret = set()
    # what if all sr are of the form abc.xyz.com/uvw? 
    # subdomain case: only trunks are considered, sports.yahoo.com/abc/uv can be under m.yahoo.com, mobile.yahoo.com, sports.yahoo.com, sports.yahoo.com/abc
    trunk2 = nurl.split('/')[0]
    trunk = trunk2 
    while '.' in trunk:
        for m in mobiles:
            tmp2 = srdict.get(m+trunk,None)
            if tmp2: ret.add(tmp2)
        trunk = re.sub('^[^\.]*?\.','',trunk)

    # subdomain-free case: www.yahoo.com/abc/uv can be under m.yahoo.com/abc, mobile.yahoo.com/abc
    nurl2 = re.sub('^(m|mobile|touch)\.','',nurl)
    while '/' in nurl2:
        nurl2 = re.sub('/[^/]*?$','',nurl2)
        for m in mobiles:
            tmp2 = srdict.get(m+nurl2,None)
            if tmp2: ret.add(tmp2)
    
    # takes care of fr.news.yahoo.com/abc/uv as a sublink of fr.yahoo.com
    trunk = trunk2
    while trunk.count('.') > 2: # so at least three dots
        tmp = trunk.split('.')
        trunk = '.'.join([ tmp[0] ] + tmp[2:])
        for m in mobiles:
            tmp2 = srdict.get(m+trunk,None)
            if tmp2: ret.add(tmp2)
    return ret
    # us.m.yahoo.com as parent, or as child: unsolvable for now
    # hk.news.yahoo.com as parent: hk.news.yahoo.com/abc, as child: hk.yahoo.com
    # worry: would ar-ar.facebook.com become a popular quicklink for facebook.com? 
    # need to do foreign language removal in post-processing

def FindSrsFromUrl(nurl):
    # caveat: for craiglist.org, sfbay.craigslist.org/aaa might not be appropriate; fortunately, we are not expecting craigslist.org to be top search result
    url0 = nurl.split('/')[0]
    ret = {}
    url1 = url0
    while ( not ret ) and '.' in url0: 
        ret = rdict.get(url0,{})
        url1 = url0
        url0 = re.sub('^.*?\.','',url0)
    return ret, url1

if __name__ == '__main__':

    #domain:chararray, url:chararray, selfclicks:float, totalclicks:float, ourl:chararray
    # rootdict.norm.onejson
    rootdictfile = sys.argv[1]
    with open(rootdictfile) as f:
        rdict = json.loads(f.readline())
    mode = 'JoinSr' 
    if len(sys.argv) > 2:
        mode = sys.argv[2]
    if mode == 'JoinSr':
        for line in sys.stdin:
            domain, nurl, selfclicks, totalclicks, ourl,c1,c2,n1,n2,l0,l1,l2,la,na,selfviews,totalviews,v1,v2,depth,potential,selfctr,totalctr,ctr1,ctr2 = line.strip('\r\t\n ').split('\t')
            srdict, root = FindSrsFromUrl(nurl)
            #srdict = rdict.get(root,{})
            assert domain == root
            if not srdict: continue
            SrCandidates = FilterSr(nurl, srdict) 
            for sr in SrCandidates:
                try:
                    print '\t'.join([sr,nurl,selfclicks,totalclicks,ourl,c1,c2,n1,n2,l0,l1,l2,la,na,selfviews,totalviews,v1,v2,depth,potential,selfctr,totalctr,ctr1,ctr2])
                except: pass

    elif mode == 'FindDomain': # streaming in WebmapAllUrls-views.pig
        for line in sys.stdin:
            tmp = line.strip('\n').split('\t')
            url = tmp[0]
            nurl = normalize(url) 
            srdict, root = FindSrsFromUrl(nurl)
            if not srdict: continue
            print '\t'.join(tmp + [root])

    else:
        raise ValueError('Unknown mode in JoinSr.py!')

