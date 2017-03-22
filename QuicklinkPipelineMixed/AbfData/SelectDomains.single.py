import sys,re,math
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import stdgen
# nviews_dom is not accurate, because it should only aggregate once, instead of 6 times; further, some domains have multiple ql versions
# we recalculate nviews_dom and nclicks_dom by aggregating the top 6 quicklinks
def DomainFilter(tmp,params=(100,11.0,0.11)):
    nviews_dom, nclicks_dom, ctr_dom = tmp
    nv,nc,c = params
    if nclicks_dom == 0: return False
    if nviews_dom < nv: return True
    if nclicks_dom > nc: return True
    if ctr_dom > c: return True
    return False

if __name__ == "__main__":
    pd = None
        
    for line in stdgen('\t'.join(['last']* 11)):
        # input schema: parent_url	url	ql_txt	bucid	nviews	nviews_cond	nclicks	nviews_dom	nclicks_dom	ctr	ctr_cond
        
        parent_url,url,ql_txt,bucid,nviews,nviews_cond,nclicks,_,_,ctr,ctr_cond = line.strip('\r\t\n ').split('\t')
        if parent_url == 'last': break
        if not pd == parent_url:
            if not pd == None and len(ret) >= 6:
                ret = sorted(ret,key = lambda t:t[-1], reverse=True)[:6]
                nviews_dom = sum(t[1] for t in ret) / 6.0
                nclicks_dom = sum(t[2] for t in ret)
                ctr_dom = nclicks_dom / nviews_dom
                if DomainFilter([nviews_dom, nclicks_dom, ctr_dom], params=(100,11,0.11)):
                    print '\t'.join(map(str, [pd, nclicks_dom, nviews_dom, ctr_dom ] )) 

            pd = parent_url
            ret= []
        ret.append([parent_url, float(nviews), float(nclicks)])

