#!/usr/bin/env python
import sys,logging,datetime
url_delimiter = ['/','?','&','=','$','@',';',':','+',',']
parents = []

for line in sys.stdin:
    assert len(parents) < 1000
    try:
        url,domain,clicks,views,ourl,linkflux = line.strip('\n\t\r ').split('\t')
    except:
        continue
    clicks = float(clicks)
    views = float(views)
    linkflux = float(linkflux)
    if clicks == 0: clicks = 0.001
    if views == 0: views = 0.001
    aclicks = clicks 
    aviews = views
    while parents:
        p,c,ac,op,c1,c2,n1,n2,l0,l1,l2,la,na,v,av,v1,v2,depth,potential,dom = parents[-1]
        
        if url.startswith(p) and ( url == p or (url[len(p)] in url_delimiter) or (p[-1] in url_delimiter) ): 
            for i in xrange(len(parents)):
                parents[i][2] += clicks 
                parents[i][11] += linkflux
                parents[i][12] += 1
                parents[i][14] += views
                parents[i][18] = max(parents[i][18],len(parents)-parents[i][17])
            parents[-1][4] += clicks
            parents[-1][6] += 1
            parents[-1][9] += linkflux
            parents[-1][15] += views
            if len(parents) > 1:
                parents[-2][5] += clicks
                parents[-2][7] += 1 
                parents[-2][10] += linkflux
                parents[-2][16] += views
                #parents[-1]=[p,c,float(ac)+float(clicks)]
#            print url, p, clicks,c,ac,parents[-1]
            break
        else: 
            print '\t'.join(map(str,[dom,p,c,ac,op,c1,c2,n1,n2,l0,l1,l2,la,na,v,av,v1,v2,depth, potential, c/v, ac/av, (c+c1)/(v+v1), (c+c1+c2)/(v+v1+v2)]))
            parents.pop() 
 
    if not (parents and url == p):
#        if not parents:
#            logging.warning('currently working on domain: %s; timestamp: %s\n'%(domain,str(datetime.datetime.now())))
        parents.append([url,clicks,aclicks,ourl,0.,0.,0.,0.,linkflux,0.,0.,linkflux,1.,views,aviews,0.,0.,len(parents),0.,domain])
        
while parents:
    p,c,ac,op,c1,c2,n1,n2,l0,l1,l2,la,na,v,av,v1,v2,depth, potential, dom = parents.pop()
    print '\t'.join(map(str,[dom,p,c,ac,op,c1,c2,n1,n2,l0,l1,l2,la,na,v,av,v1,v2,depth, potential, c/v, ac/av, (c+c1)/(v+v1), (c+c1+c2)/(v+v1+v2)]))





