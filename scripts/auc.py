import sys,re,math

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

def dcg(predlab, useLog=False,normalize=False,ctr2rk=False,useWorst=False):
    # formula: \sum_i l_i / log_2 (i+1) or \sum_i log_2 (l_i + 1) / log_2 (i+1)
    if ctr2rk:  
        ctr2rkmap = rkmap([t[1] for t in predlab])
        predlab = [(t[0],ctr2rkmap[t[1]]) for t in predlab]
    
    predlab.sort(key = lambda t:t[0], reverse = True)
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
     

def metric(inputlines,per_session =0, skipNa = 1, useLog =0, normalize= 0, ctr2rk = 0, useWorst =0):
    
    predlab=[]
    stringInput = True
    if per_session == 0:
        for i,line in enumerate(inputlines):
            if i == 0 and isinstance(line,list):
                predlab = inputlines
                break 
            p,l = re.split('\s+',line.strip('\r\t\n '))
            predlab.append((float(p),float(l)))

        return auc(roc(predlab))
    elif per_session in [1,-1]:
        
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
                    score = auc(roc(predlab)) if per_session == 1 else dcg(predlab,useLog,normalize,ctr2rk,useWorst)
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

if __name__ == "__main__":
    per_session, skipNa, useLog, normalize, ctr2rk, useWorst = 0,0,0,0,0,0

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

    print metric(sys.stdin, per_session, skipNa, useLog, normalize, ctr2rk, useWorst)

    """
    if per_session == 0:
        for line in sys.stdin:
            p,l = re.split('\s+',line.strip('\r\t\n '))
            predlab.append((float(p),float(l)))

        print auc(roc(predlab))
    elif per_session in [1,-1]:
        
        ps = None
        total=0.
        num = 0
        for i,line in enumerate(list(sys.stdin) + ['lastsession 0 0']): # to capture the last session
            s,p,l = re.split('\s+',line.strip('\r\t\n '))
            if not ps == s:
                if not ps == None:
                    numincr = 1
                    score = auc(roc(predlab)) if per_session == 1 else dcg(predlab,useLog,normalize,ctr2rk,useWorst)
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

        print total/num
    elif per_session == 2:
        ret = {}
        for line in sys.stdin:
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
        print total/num
    """
