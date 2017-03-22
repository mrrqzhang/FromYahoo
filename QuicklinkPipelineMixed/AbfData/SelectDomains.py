import sys,re,math
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import stdgen
# nviews_dom is not accurate, because it should only aggregate once, instead of 6 times; further, some domains have multiple ql versions
# we recalculate nviews_dom and nclicks_dom by aggregating the top 6 quicklinks
def DomainFilter(tmp,params=(100,11.0,0.11)):
    nviews_dom, nclicks_dom, ctr_dom = tmp
    nv,nc,c = params
    if nclicks_dom == 0: return False
    #if nviews_dom < nv: return True
    if nviews_dom < nv: return False
    if nclicks_dom > nc: return True
    if ctr_dom > c: return True
    return False

if __name__ == "__main__":
    mode = 'map' if len(sys.argv) < 2 else sys.argv[1]
    ncs = [100,200,300,500,1000,2000,3000,5000,10000,20000,30000,100000,1000000000]
    #nvs = [1,10,20,40,100, 250, 500,1000,10000,100000000000]
    nvs = [1,5,10,20,30,40,60,80,100,150,200,300,400,500,1000]
    cts = [0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1, 0.11, 0.12, 0.13,0.14,0.15,0.2,0.3,0.5,1.0,100]

    thresholds = [ (nv, nc, ct) for nv in nvs for nc in ncs for ct in cts]
    nths = len(thresholds)
    if mode == 'map':
        pd = None
        
        for line in stdgen('\t'.join(['last']* 11)):
            # input schema: parent_url	url	ql_txt	bucid	nviews	nviews_cond	nclicks	nviews_dom	nclicks_dom	ctr	ctr_cond
            
            parent_url,url,ql_txt,bucid,nviews,nviews_cond,nclicks,_,_,ctr,ctr_cond = line.strip('\r\t\n ').split('\t')
            if parent_url == 'last': break
            if not pd == parent_url:
                if not pd == None and len(ret) >= 6:
                    ret = sorted(ret,key = lambda t:t[-1], reverse=True)[:6]
                    nviews_dom = sum(t[1] for t in ret)/6.0
                    nclicks_dom = sum(t[2] for t in ret)

                    ctr_dom = nclicks_dom / nviews_dom
                    binaries = map(int,map(lambda t: DomainFilter([nviews_dom, nclicks_dom, ctr_dom],t), thresholds))

                    print '\t'.join(map(str, [pd, nclicks_dom, nviews_dom, ctr_dom ] + binaries ) ) 

                pd = parent_url
                ret= []
            ret.append([parent_url, float(nviews), float(nclicks)])
    elif mode == 'reduce':
        totalnvs = []
        totalncs = []
        totalcnt = []
        for line in sys.stdin:
            tmp = line.strip('\r\t\n ').split('\t')
            nclicks_dom, nviews_dom = map(float,tmp[1:3])
            currentnvs = [nviews_dom if int(t) == 1 else 0.0 for t in tmp[4:]]
            currentncs = [nclicks_dom if int(t) == 1 else 0.0 for t in tmp[4:]]
            currentcnt = [int(t) for t in tmp[4:]]
            if not totalnvs or not totalncs:
                totalnvs = currentnvs
                totalncs = currentncs
                totalcnt = currentcnt
            else:
                totalnvs = [t + s for t,s in zip(totalnvs, currentnvs)]
                totalncs = [t + s for t,s in zip(totalncs, currentncs)]
                totalcnt = [t + s for t,s in zip(totalcnt, currentcnt)]
        print '\t'.join(map(str,totalnvs + totalncs + totalcnt))
    elif mode == 'params':
        print '\n'.join('\t'.join(map(str,t)) for t in thresholds)

