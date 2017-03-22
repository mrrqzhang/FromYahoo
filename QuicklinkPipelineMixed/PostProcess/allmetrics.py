#!/usr/bin/env python
import sys,re,math, random,os
try: import simplejson as json
except ImportError: import json
from genLibs import normalize as normalizelite, normalize4rbo
#from genLibs import normalize as url_normalize, normalize4rbo 
try:
    from collections import Counter as mset 
except:
    pass
mylibdir=os.path.expanduser('~/mylib')
random.seed(0)

normlite = 1

def url_normalize(url):
    if normlite: 
        #print normlite
        return normalizelite(url)
    else:
        #print normlite
        return normalize4rbo(url)

def roc(predlab):   # autodetect -1 or 0
    predlab.sort(key=lambda t:t[0],reverse=True)
    
    use01=1
    for p,l in predlab:
        if l in [0,-1]:
            use01 = l + 1
            break

    tmp=[]
    subtotal = 0

    for i,(p,l) in enumerate(predlab):
        subtotal += l if use01 else (l+1)/2
        tmp.append((i+1,subtotal))
    pn = float(tmp[-1][1])
    n = len(predlab)
    nn = n - pn
    if 0 in [pn,nn]: return None
    return [(t/pn, (i-t)/nn) for i,t in tmp]


def auc(tpfp):
    if not tpfp: return None
    return sum([(x2-x1) * (y2 + y1) / 2 for (y1,x1),(y2,x2) in zip(tpfp[:-1],tpfp[1:])])


def rkmap(ctrs): # typically the inputs are ctrs; returns a mapping from ctr to rank
    ctrs.sort()
    return dict((c,i+1) for i,c in enumerate(ctrs))

def compare_with_ties(a, b):
    diff = cmp(a, b)
    return diff if diff else random.choice([-1, 1])

def dcg(predlab, useLog=False,normalize=False,ctr2rk=False,useWorst=False,skipDupPred=False):
    # formula: \sum_i l_i / log_2 (i+1) or \sum_i log_2 (l_i + 1) / log_2 (i+1)
    hasDupPred = (len(set([t[0] for t in predlab])) < len(predlab))
    if skipDupPred and hasDupPred: return None
    
    if ctr2rk:  
        ctr2rkmap = rkmap([t[1] for t in predlab])
        predlab = [(t[0],ctr2rkmap[t[1]]) for t in predlab]
    # takes care of dup tie randomization
    predlab.sort(key = lambda t:t[0], reverse=True, cmp=compare_with_ties if hasDupPred else cmp)
    
    if useWorst in [1,-1]:
        rk2label = dict((i,c) for i,c in enumerate(sorted([t[1] for t in predlab])))
        predlab2 = [(t[0], rk2label[i]) for i,t in enumerate(predlab)]
        if useWorst == 1:
            predlab = predlab2

    if useLog:
        nf = 1. if not normalize else sum(math.log(l+1,2) / math.log(i+2,2) for i,(_,l) in enumerate(sorted(predlab, key=lambda t:t[1], reverse=True)))
        shift = 0. if useWorst != -1 else sum(math.log(l+1,2) / math.log(i+2,2) for i,(_,l) in enumerate(predlab2)) 

        return (sum(math.log(l+1,2) / math.log(i+2,2) for i,(_,l) in enumerate(predlab)) - shift) / (nf - shift) if nf-shift != 0 else None
    else:
        nf = 1. if not normalize else sum(l/math.log(i+2,2) for i, (_,l) in enumerate(sorted(predlab, key=lambda t:t[1], reverse=True)))
        shift = 0. if useWorst != -1 else sum(l/math.log(i+2,2) for i, (_,l) in enumerate(predlab2))
        return (sum(l/math.log(i+2,2) for i, (_,l) in enumerate(predlab)) - shift) / ( nf - shift) if not nf - shift == 0 else None
     

def metric(inputlines,per_session =0, skipNa = 1, useLog =0, normalize= 0, ctr2rk = 0, useWorst =0, skipDupPred = False):
    # for per_session = 3, skipNa = 1 or 0 are both valid
    predlab=[]
    stringInput = True
    if per_session == 0:
        for i,line in enumerate(inputlines):
            if i == 0 and not isinstance(line,str):
                predlab = inputlines
                break 
            p,l = re.split('\s+',line.strip('\r\t\n '))
            predlab.append((float(p),float(l)))

        return auc(roc(predlab))
    elif per_session in [1,-1,3,4,5]:
        
        ps = None   # previous session
        total=0.
        num = 0
        inputlines = list(inputlines)
        if not isinstance(inputlines[0],str): stringInput = False # could be list or tuple!
        else:   inputlines = inputlines + ['lastsession 0 0']
        for i,line in enumerate(inputlines): # to capture the last session
            s,p,l = line if not stringInput else re.split('\s+',line.strip('\r\t\n ')) 
            if not ps == s:
                if not ps == None:
                    numincr = 1
                    if per_session == 1:
                        score = auc(roc(predlab))
                    elif per_session == -1:    
                        score = dcg(predlab,useLog,normalize,ctr2rk,useWorst,skipDupPred)
                    elif per_session == 3:  # whether top ranked element has the highest score
                        if skipNa and len(set([t[1] for t in predlab])) == 1:  score = None
                        else:
                            label4maxscore = sorted(predlab)[-1][1]
                            maxlabel = max([t[1] for t in predlab])
                            score = int(label4maxscore == maxlabel)
                    elif per_session == 4:
                        score = max([t[1] for t in predlab])
                    elif per_session == 5:
                        score = max([t[0] for t in predlab])
                    if score == None:
                        if skipNa:
                            score = 0
                            numincr = 0
                        else:
                            score = 0.5
                    total += score
                    num += numincr
                ps = s
                predlab = []
            predlab.append((float(p),float(l)))
        return total/num

    elif per_session == 2:
        ret = {}
        for line in inputlines:
            s,p,l = re.split('\s+',line.strip('\r\t\n '))
            if not s in ret: ret[s] = []
            ret[s].append((float(p),float(l)))
        total = 0.
        num = 0
        for _,v in ret.items():
            score = auc(roc(v))
            numincr = 1
            if score == None:
                if skipNa:
                    score = 0
                    numincr = 0
                else:
                    score = 0.5
            total += score
            num += numincr
        return total/num

def rbo(ysess,gsess,topk,RankByG=False,multi=False):
    wt = 0.8
    # newly added to make sure the best score is 1
    topk = min(topk,len(gsess)-1)
    gsess = [url_normalize(t['l']) for t in gsess]
    if RankByG: ysess = [t for t in gsess if t in ysess]    # don't care about the non-overlapping qls
    ret = 0.
    for i in xrange(topk+1):
        if multi:
            try:
                capsize = len(sum((mset(ysess[:i+1]) & mset(gsess[:i+1])).values()))
            except:
                gstub = gsess[:i+1]
                ystub = ysess[:i+1]
                capsize = sum(ystub.count(g) for g in gstub)
        else:
            capsize = len(set(ysess[:i+1]).intersection(set(gsess[:i+1])))
        ret += capsize * math.pow(wt,i) / (i+1)
    nf = (1 - math.pow(wt,topk+1))/(1-wt)
    return ret/nf

def chooseG(gsessions, ysess, qlonly, maxg,RankByG):
    gs = gsessions['quicklinks'] if qlonly else gsessions['quicklinks'] + gsessions['sitelinks'] +gsessions['mixlinks']
    if RankByG:
        gs =[s for s in gs if set([url_normalize(t['l']) for t in s]).intersection(set(ysess))]
    if not maxg or gs == []: return gs
    else:
        maxqls = max([len(sess) for sess in gs])
        return [sess for sess in gs if len(sess) == maxqls]

def GenLastLine(source,lastline):
    for line in source:
        yield line
    yield lastline

# SortByPred: default is to take yqls assuming ordered, if True, sort by score, randomly break ties
def AvgRBO(inputlines, gjson,topk,randomPredict=False,qlonly=True, maxg=False,RankByG=False,SortByPred=False,bestg=True,multi=False,printTopMissing=False,onejson=True,debug=False):
    # printTopMissing: if yahoo doesn't have the top google ql, print it
    with open(gjson,'r') as f: 
        if not onejson:
            gdict = {}
            for line in f.readlines():
                tmp = json.loads(line.strip('\r\t\n '))
                for k,v in tmp.items():
                    gdict[k] = v
        else:
            gdict = json.loads(f.readline())
        """
        {"epixhd.com": {"quicklinks": [[{"parent": "http://www.epixhd.com/", "l": "http://www.epixhd.com/freetrial", "l_title": "Free 14 Day Trial!", "parent_title": "Epix", "date": "2014-02-01", "query": "epix", "type": "ql"}, {"parent": "http://www.epixhd.com/", "l": "http://www.epixhd.com/all-movies/", "l_title": "All Movies", "parent_title": "Epix", "date": "2014-02-01", "query": "epix", "type": "ql"}, {"parent": "http://www.epixhd.com/", "l": "http://co
        """
        total = 0.
        cnt = 0
        pd = None # previous domain
        print 'loaded goldset json file!!'
        for i,line in enumerate(GenLastLine(inputlines, 'lastdomain\tlastql_url\t0.0')):
            # assume input of the form domain, ql_url, score, sorted by domain then by score in descending order
            tmp = line.strip('\r\t\n ').split('\t')
            if len(tmp) < 3: tmp = re.split('\s+',line.strip('\r\t\n '))
            domain, ql_url, score = tmp
            domain = url_normalize(domain)
            ql_url = url_normalize(ql_url)  # yahoo quicklink normalized
            if not pd == domain:
                if not pd == None:
                    gsessions = gdict.get(pd,{})
                    if gsessions:
                        if SortByPred:
                            ysess = sorted(ysess, key = lambda t:t[1],reverse=True, cmp=compare_with_ties)
                        ysess = [t[0] for t in ysess]
                        gsessions = chooseG(gsessions, ysess, qlonly, maxg,RankByG)
                        if gsessions:
                            if printTopMissing:
                                PrintTopMissing(ysess,gsessions,pd)
                            else:
                                cnt += 1
                                if bestg:
                                    session_rbo = max(rbo(ysess,gsess,topk,RankByG) for gsess in gsessions)
                                else:
                                    gsess = random.choice(gsessions)
                                    if randomPredict: random.shuffle(ysess)
                                    session_rbo = rbo(ysess, gsess,topk,RankByG)
                                total += session_rbo
                                if debug:
                                    print pd, session_rbo
                pd = domain
                ysess = []
            ysess.append((ql_url,float(score)))
        """
        gsessions = gdict.get(pd,{})
        if gsessions:
            if SortByPred:
                ysess = sorted(ysess, key = lambda t:t[1], cmp = compare_with_ties, reverse=True)
            ysess=[t[0] for t in ysess]
            
            gsessions = chooseG(gsessions,ysess, qlonly, maxg,RankByG)
            if gsessions:
                if printTopMissing:
                    PrintTopMissing(ysess,gsessions,pd)
                else:
                    cnt += 1
                    if bestg:
                        total += max(rbo(ysess,gsess,topk,RankByG) for gsess in gsessions)
                    else:
                        gsess = random.choice(gsessions)
                        if randomPredict: random.shuffle(ysess)
                        total += rbo(ysess, gsess, topk, RankByG)
        """
        if not printTopMissing:
            return total / cnt, cnt

def PrintTopMissing(ysess,gsessions,domain):  # a flag in AvgRBO; when set, print not return
    for gsess in gsessions:
        topUrl = url_normalize(gsess[0]['l'])
        if not topUrl in ysess: print '%s\t%s\t%s'%(domain,topUrl,'\t'.join(ysess))

def PValue(nclicks,nviews,controlCTR):
    from scipy.stats import norm
    testCTR = nclicks*1.0/nviews
    testVar = nviews * testCTR * (1.-testCTR)
    return min(1. - norm.cdf(nviews * (testCTR - controlCTR)/math.sqrt(testVar)),norm.cdf(nviews * (testCTR - controlCTR)/math.sqrt(testVar)))

def getArgs(defaultVals,startid=1):
    i = startid
    n = len(defaultVals)
    ret = []
    for j,k in enumerate(xrange(startid, startid + n)):
        vtype = re.findall("'([^']*)'", str(type(defaultVals[j])))[0]
        if len(sys.argv) > k:
            if vtype == 'str': ret.append(sys.argv[k])
            else:
                s = eval('%s(%s)'%(vtype,sys.argv[k]))
                ret.append(s)
        else: ret.append(defaultVals[j])
    return ret

if __name__ == "__main__":
    
    if len(sys.argv) > 1 and  sys.argv[1] in ['rbo', 'topMissing']: 

        topk, randomPredict, qlonly, maxg, RankByG,SortByPred,bestg,multi,norm_lite, gfile,onejson,debug = getArgs([5,False,False,False,False,True,False,False,True,'%s/ql.google.desktop.all.json'%mylibdir,True,False],2)
        normlite = norm_lite
        if sys.argv[1] == 'topMissing':
            AvgRBO(sys.stdin,gjson=gfile, topk=topk, qlonly=qlonly, maxg=maxg, printTopMissing = True)
        elif sys.argv[1] == 'rbo':
            print ', '.join('%s=%s'%(k,str(eval(k))) for k in ['topk','randomPredict','qlonly',' maxg',' RankByG','SortByPred','bestg','multi','normlite','gfile','onejson','debug'])
            print AvgRBO(sys.stdin,gjson=gfile,topk=topk,randomPredict=randomPredict,qlonly=qlonly, maxg=maxg,RankByG=RankByG,SortByPred=SortByPred,bestg=bestg,multi=multi,onejson=onejson,debug=debug)
    
    elif sys.argv[1] == 'pval':
        nclicks,nviews,controlCTR = getArgs([0.,0.,0.],2)
        print PValue(nclicks,nviews,controlCTR)
    else:
        per_session, skipNa, useLog, normalize, ctr2rk, useWorst,skipDupPred = 0,0,0,0,0,0,0
        if len(sys.argv) > 1:
            per_session = int(sys.argv[1])
        skipNa = 1
        if len(sys.argv) > 2:
            skipNa = int(sys.argv[2])
        if per_session in [-1,-2]:  # dcg persession or perdomain
            if len(sys.argv) > 3:
                useLog = int(sys.argv[3])
            if len(sys.argv) > 4:
                normalize = int(sys.argv[4])
            if len(sys.argv)  >5:
                ctr2rk = int(sys.argv[5])
            if len(sys.argv) > 6:
                useWorst = int(sys.argv[6]) # 1,0,or -1
            if len(sys.argv) > 7:
                skipDupPred = int(sys.argv[7]) 

        print metric(sys.stdin, per_session, skipNa, useLog, normalize, ctr2rk, useWorst, skipDupPred)


