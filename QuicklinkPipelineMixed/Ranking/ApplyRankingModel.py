import sys,re,math,json,heapq,logging
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import TestFV,TestModel,xml2dict,GbdtModelJson,stdgen,mildsigmoid

"""
Secondary model appliers
"""

# default gbdt model
def defaultModel(featsdict, models):
    return TestModel(featsdict, models[0])

def combinedCtrEditGbdtModel(featsdict, models, coeffs= [0.9,0.1]):
    # first model is trained by ctr, second by editorial judgment
    coeffs = map(float, coeffs)
    return TestModel(featsdict, models[0]) * coeffs[0] + TestModel(featsdict, models[1]) * coeffs[1]

"""
End model appliers
"""


mapping={'true':1,'false':0,'fal':0,'parent':1,'mirror':0}
def FeatConvert(s,default=-1):
    # ruiqiang's original mapping
    #sed "s/true/1/g" | sed "s/false/0/g" | sed "s/fal/0/g" | sed "s/parent/1/g" | sed "s/mirror/0/g"
    try:
        return float(s)
    except:
        return mapping.get(s,default)

def ExpandDefault(g, nf, default=-1):
    if len(g) == nf: return g
    else: return [default] * nf

if __name__ == '__main__':
    gbdtxml=sys.argv[1].split(',')
    featgps = sys.argv[2].upper()
    topk=1000
    if len(sys.argv)> 3:
        topk= int(sys.argv[3])
    showsublinkscore = False
    if len(sys.argv) > 4:
        showsublinkscore = eval(str(sys.argv[4]))
    modelfunc = defaultModel
    if len(sys.argv) > 5:
        # other choice is combinedCtrEditGbdtModel
        exec("modelfunc = %s"%sys.argv[5])

    featgps=[t.split(',') for t in featgps.split('+')]

    logging.warning('featgps = %s'%(str(featgps)))

    featnames =[t for g in featgps for t in g]
    models = [GbdtModelJson(f) for f in gbdtxml]
    
    
    if len(sys.argv) > 6:
        nfeats = map(int, sys.argv[6].split(','))


    pd = None
    
    for line in stdgen('\t'.join(['domain','ql','title','-1.0'] + ['[]' for i,c in enumerate(featgps)])):
        tmp = line.strip('\n\t').split('\t')    # for hadoop streaming, stripping trailing tab is almost always a good idea
        domain,ql,title,sublinkscore = tmp[:4]
        try:
            sublinkscore = float(sublinkscore) 
        except:
            logging.warning('float cast error: '+ str(sublinkscore))
        if not pd == domain or domain=='domain':
            if not pd == None:

                ret2 = sorted([t[1:4] + [ 
                                mildsigmoid(
                                        modelfunc(
                                                dict(
                                                    zip(
                                            featnames,map( \
                                                    # fill in empty json with nf number of -1's 
                                            FeatConvert,[s for i,( g, nf ) in enumerate(zip(t[4:],nfeats)) for s in ExpandDefault(json.loads(g),nf)]
                                                        )
                                                    )
                                                    ),
                                            models) 
                                            )        
                                        ] + ([sublinkscore] if showsublinkscore else []) for t in ret],key = lambda t: t[3], reverse=True)
                print '\n'.join('\t'.join(map(str,t)) for t in ret2)
            ret =[] 
            heapq.heapify(ret)
            pd = domain
        if len(ret) < topk:
            heapq.heappush(ret,[sublinkscore, domain, ql, title] + tmp[4:])
        else:
            tmp2 = heapq.heappushpop(ret,[sublinkscore, domain, ql, title] + tmp[4:])
