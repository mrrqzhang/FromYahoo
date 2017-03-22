#!/usr/bin/env python
# adapted by Jiang Chen <jiangc@yahoo-inc.com> from Zhaohui's computeDCG.py

import os, sys, StringIO, optparse, re, copy, random
from math import *


# needed for python 2.3
def itemgetter(i):
    return lambda seq: seq[i]    

class DCG:
    score = {}
    score['p'] = 10
    score['e'] = 7
    score['g'] = 3
    score['f'] = 0.5
    score['b'] = 0
    score['n'] = 0
    
    def __init__(self, N):        
        self.discounts = [log(2)/log(i+2) for i in range(N)]
        
    def dcg(self, l, n = None):
        if n == None:
            n = len(l)
        assert(len(self.discounts) >= n)
        return sum([DCG.score[l[i]]*self.discounts[i] for i,a in enumerate(l[0:min(len(l), n)])])

class SDCG:
    score = {}
    score['p'] = 15
    score['e'] = 7
    score['g'] = 3
    score['f'] = 1
    score['b'] = 0
    score['n'] = 0


class DCR:
    score = {}
    score['0'] = 5
    score['1'] = 2
    score['2'] = 0
    score['g'] = 5
    score['f'] = 2
    score['b'] = 0
    
    def __init__(self, N):        
        self.discounts = [log(2)/log(i+2) for i in range(N)]

class ERR:
    p = {}
    p['b'] = 0
    p['f'] = 1.0/16
    p['g'] = 3.0/16
    p['e'] = 7.0/16
    p['p'] = 15.0/16

class stat:
    def __init__(self, name):
        self.SUM = 0
        self.SUM2 = 0
        self.WEIGHT = 0
        self.MIN = None
        self.MAX = None
        self.name = name
        
    def add(self, x, w = 1, minmax = False):
        self.SUM += x*w
        self.SUM2 += x*x*w
        self.WEIGHT += w
        
        if minmax:
            if self.MIN == None:
                self.MIN = x
            if self.MAX == None:
                self.MAX =x
            self.MIN = min(self.MIN, x)
            self.MAX = max(self.MAX, x)
        
    def average(self):
        if self.WEIGHT == 0:
            return None
        return float(self.SUM) / self.WEIGHT

    def variance(self):
        if self.WEIGHT == 0:
            return None
        return max((self.SUM2 -  (self.SUM*self.SUM) /self.WEIGHT),0) / self.WEIGHT
    def deviation(self):
        var = self.variance()
        if var == None:
            return None
        return sqrt(var)
    
    def __str__(self):
        bufmin = str(self.MIN)
        bufmax = str(self.MAX)
        if self.MIN != None:
            bufmin = "%.2f" % self.MIN
        if self.MAX != None:
            bufmax = "%.2f" % self.MAX

        if self.average() != None:
            average = "%.4f" % self.average()
        else:
            average = str(self.average())
            
        if self.deviation() != None:
            deviation = "%.4f" % self.deviation()
        else:
            deviation = str(self.deviation())
            
            
        #return "%s has range [%s, %s], average %s (+-%s )."%(self.name, bufmin, bufmax, average, deviation)
        return "%s has range [%s, %s], average %s (+-%s )."%(self.name, self.MIN, self.MAX, self.average(), self.deviation())

def err(judges):
    # olivier's err metric
    s = 0
    p = 1
    for r,j in enumerate(judges):
        q = ERR.p[j]
        s += 1.0/(r+1) * p * q
        p *= (1-q)
    return s
        

def average_position(judges):
    sum_pos = {}
    for j in 'pegfb':
        sum_pos[j] = ([0,0])
        
    for i,j in enumerate(judges):        
        sum_pos[j][0] += (i+1)
        sum_pos[j][1] += 1
    return sum_pos


def bdcg(judges):
    # find the position of the best url
    if not judges:
        return 0
    
    best = judges[0]
    best_pos = 0
    
    for i,j in enumerate(judges):
        if DCG.score[j] > DCG.score[best]:
            best_pos = i
            best = j

    return log(2)/log(best_pos+2)*DCG.score[best]
    

def swapped_pairs(judges, values):
    count = {}
    count['p'] = 0
    count['e'] = 0
    count['g'] = 0
    count['f'] = 0
    count['b'] = 0
    swapped = {}
    
    num_swapped_pairs = 0
    s = 'pegfb'
    for i in range(5):
        for j in range(i+1,5):
            values['swapped_'+s[i]+s[j]] = 0
            
    for j in judges:
        if j == 'p':
            for k in 'egfb':
                num_swapped_pairs += count[k]
                values['swapped_'+j+k] += count[k]
        if j == 'e':
            for k in 'gfb':
                num_swapped_pairs += count[k]
                values['swapped_'+j+k] += count[k]
        if j == 'g':
            for k in 'fb':
                num_swapped_pairs += count[k]
                values['swapped_'+j+k] += count[k]
        if j == 'f':
            for k in 'b':
                num_swapped_pairs += count[k]
                values['swapped_'+j+k] += count[k]
        count[j] += 1

    possible_swapped = {}
    
    for i in range(5):
        for j in range(i+1,5):
            possible_swapped[s[i]+s[j]] = count[s[i]]*count[s[j]]
            if possible_swapped[s[i]+s[j]] == 0:
                values['swapped_'+s[i]+s[j]] = None
            else:
                values['swapped_'+s[i]+s[j]] = float(values['swapped_'+s[i]+s[j]])/possible_swapped[s[i]+s[j]]
            
    total_possible_swapped = sum(possible_swapped.values())

    if total_possible_swapped > 0:
        values['swapped_pairs'] = float(num_swapped_pairs)/total_possible_swapped

def csvIter(f):
    IN = open(f)

    for line in IN:
        line = line.strip('\n')
        yield [a.strip() for a in line.split('\t')]

def readQu(quFile):
    IN = open(quFile)
    heads = [a.strip().lower() for a in IN.readline().strip('\n').split('\t')]
    if 'query' not in heads:
        # backward compatibility
        heads = ['query', 'url','grade']
        IN.close()

    IN = csvIter(quFile)
    qIdx=''
    uIdx=''
    nKeys = 1
    qIdx = heads.index('query')
    if 'url' in heads:
        nKeys = 2
        uIdx = heads.index('url')

        
    try:
        gIdx = heads.index('group')
    except:
        gIdx = None


    lQu = []
    lJ = []
    
    for fields in IN:
        q = fields[qIdx]
        u = fields[uIdx]
        g = None
        if gIdx != None:
            g = fields[gIdx]
        lQu.append((q,u,g))
        lJ.append(dict(zip(heads, fields)))
    IN.close()
    return lQu, lJ
        

def readscore(scorefile):
    querydict = {}
    IN = open(scorefile, 'r')
    lQ = []
    lQu = []
    lScore = []
    for line in IN:
        tokens = line.strip().split('\t')
        q = tokens[0].strip()
        url = tokens[1].strip()
        score = float(tokens[2].strip())
        
        lQu.append((q,url))
        lScore.append(score)        

        if q not in querydict:
            lQ.append(q)
            querydict[q] = 1                    
    IN.close()

    return lQ, lQu, lScore

def readrawscore(scorefile):
    lScore = [float(a) for a in open(scorefile).read().split('\n') if a != ""]
    return lScore

def readJdgFiles(jdgFiles):
    return [readJdgFile(f) for f in jdgFiles]

def readJdgFile(f):
    IN = open(f)
    heads = [a.strip().lower() for a in IN.readline().strip('\n').split('\t')]
    if 'query' not in heads:
        # backward compatibility
        heads = ['query', 'url', 'grade']
        IN.close()
        IN = open(f)
        
    jdgDict = {}

    nKeys = 1
    queryIdx = heads.index('query')
    if 'url' in heads:
        nKeys = 2
        urlIdx = heads.index('url')
    
    for line in IN:
        tokens = [a.strip() for a in line.strip('\n').split('\t')[0:3]]
        if nKeys == 1:
            key = tokens[queryIdx]
            jdgDict[key] = dict([(heads[i], tokens[i]) for i,v in enumerate(tokens) if i != queryIdx])
        elif nKeys == 2:            
            key = (tokens[queryIdx], tokens[urlIdx])        
            jdgDict[key] = dict([(heads[i], tokens[i]) for i,v in enumerate(tokens) if i != queryIdx and i != urlIdx])

    IN.close()
    return jdgDict
    

domains = ['ac','ad','ae','aero','af','ag','ai','al','am','an','ao','aq','ar','arpa','as','at','au','aw','az','ba','bb','bd','be','bf','bg','bh','bi','biz','bj','bm','bn','bo','br','bs','bt','bv','bw','by','bz','ca','cc','cf','cg','ch','ci','ck','cl','cm','cn','co','com','coop','cr','cs','cu','cv','cx','cy','cz','de','dj','dk','dm','do','dz','ec','edu','ee','eg','eh','er','es','et','eu','fi','firm','fj','fk','fm','fo','fr','fx','ga','gb','gd','ge','gf','gh','gi','gl','gm','gn','gov','gp','gq','gr','gs','gt','gu','gw','gy','hk','hm','hn','hr','ht','hu','id','ie','il','in','info','int','io','iq','ir','is','it','jm','jo','jobs','jp','ke','kg','kh','ki','km','kn','kp','kr','kw','ky','kz','la','lb','lc','li','lk','lr','ls','lt','lu','lv','ly','ma','mc','md','mg','mh','mil','mk','ml','mm','mn','mo','mp','mq','mr','ms','mt','mu','museum','mv','mw','mx','my','mz','na','name','nato','nc','ne','net','nf','ng','ni','nl','no','nom','np','nr','nt','nu','nz','om','org','pa','pe','pf','pg','ph','pk','pl','pm','pn','pr','pro','pt','pw','py','qa','re','ro','ru','rw','sa','sb','sc','sd','se','sg','sh','si','sj','sk','sl','sm','sn','so','sr','st','store','su','sv','sy','sz','tc','td','tf','tg','th','tj','tk','tm','tn','to','tp','tr','travel','tt','tv','tw','tz','ua','ug','uk','um','us','uy','va','vc','ve','vg','vi','vn','vu','web','wf','ws','ye','yt','yu','za','zm','zr','zw']

def isDomain(q):
    q = q.lower()    

    # i am not sure what this part is for
    p = re.compile('^\d+(_\d+)?\-\-\d+\-\-(.*)')
    m = p.match(q)
    
    if m and m.groups()[0]:
        q = m.groups()[0].strip()

    if not q:
        return False

    # check domain queries
    parts = q.split('.')

    if len(parts) < 2:
        return False

    if parts[0][0:len('www')] == 'www' or parts[-1] in domains:
        return True

    return False

def uniqing_url(url):
    # remove http://
    url = url.lower()
    strip_list = ['http://', 'www.']
    for s in strip_list:
        if url[0:len(s)] == s:
            url = url[len(s):]
            
    url = url.rstrip('/')

    return url
    
def host(url):
    # remove everything trailing '/'
    i = url.find('/')
    if i >= 0:
        return url[0:i]
    return url
        

uniq_url_dict = {}
uniq_host_dict = {}

def uniqing(lSOJU):
    url_dict = {}
    host_dict = {}
    _lSOJU = []
            
    for s,i,j,u in lSOJU:        
        uniq_url = uniq_url_dict.get(u)
        if uniq_url == None:
            uniq_url = uniqing_url(u)
            uniq_url_dict[u] = uniq_url
                
        uniq_host = uniq_host_dict.get(uniq_url)
        if uniq_host == None:
            uniq_host = host(uniq_url)
            uniq_host_dict[uniq_url] = uniq_host
                

        url_dict.setdefault(uniq_url,0)
        host_dict.setdefault(uniq_host,0)

        if url_dict[uniq_url] > 0 or host_dict[uniq_host] >= 2:
            continue
                        
        _lSOJU.append((s,i,j,u))
                        
        url_dict[uniq_url] += 1
        host_dict[uniq_host] += 1

    return _lSOJU

    
def makelQuJ(lQu, lJ, jdgDicts):
    def merge(dict1, dict2):
        for k in dict2:
            dict1[k] = dict2[k]
    
    lQuJ = [(q,u,g,lJ[i]) for i,(q,u,g) in enumerate(lQu)]

    for i,d in enumerate(jdgDicts):
        if not d:
            continue
        
        # query dictionary or query url dictionary
        nKeys = 2
        
        if type(d.keys()[0]) is str:
            nKeys = 1
        else:
            nKeys = len(d.keys())
        
        for (q,u,g,jDict) in lQuJ:
            
            v = None
            if nKeys == 1:                
                v = d.get((q))
            elif nKeys == 2:
                v = d.get((q,u))
            else:
                v = d.get((q,u,g))
            if v:
                merge(jDict, v)                
                
    return lQuJ

def groupSameQ(lQuJ, isRandom = True, isSortbyJdg = False):
    random.seed(103424205) # fix random seed
    qDict = {}
    
    order = []
    for i,(q,u,g,j) in enumerate(lQuJ):
        if (q,g) not in qDict:
            qDict[(q,g)] = len(qDict)
        # add random permutation
        v = qDict[(q,g)]
        if isRandom and not isSortbyJdg:
            
            v += random.random()
        if isSortbyJdg:
            v += 1e-4*DCG.score[j['grade'].lower()[G0]]
            
        order.append((v, i))
    order.sort()
    return map(itemgetter(1), order)

def iterbyQ(lQuJ, order, lScore):
    prevQ = None
    prevG = None
    lSOJU = []
    for ii,i in enumerate(order):
        q,u,g,j = lQuJ[i]
        if j == None:
            print "Missing judgement for (%s, %s)" %(q,u)
            continue
        
        s = lScore[i]
        if prevQ != None and (q,g) != (prevQ, prevG):
            yield prevQ, lSOJU
            lSOJU = []
        
        lSOJU.append((s,ii,j,u))        
        prevQ = q
        prevG = g

    if lSOJU:
        yield prevQ, lSOJU        

def evalRanking(lQuJ, order, lScore, test_uniqing = False, debug = False, querySet = [], verbose = 3, reverse = False, keep_domain = False):
        
    OUT = StringIO.StringIO()
    DEBUGOUT = StringIO.StringIO()
    
    dcg = DCG(20)    
    dcr = DCR(20)
    nperfects = 0
    nperfects_top1 = 0
    nperfects_top5 = 0
    nNavQs = 0

    displaylist = ["dcg1", "dcg3", "dcg5", "dcg10", "sdcg1", "sdcg3", "sdcg5", "sdcg10", "cdcg", "err", "mean_rank_p", "mean_rank_e", "mean_rank_pe", "mean_rank_g", "mean_rank_f", "mean_rank_b", "ndcg1", "ndcg3", "ndcg5", "ndcg10", "nsdcg1", "nsdcg3", "nsdcg5", "nsdcg10", "bdcg", "swapped_pairs", "p5", "e5", "g5", "f5", "b5", "p1", "e1", "g1", "f1", "b1", "dcr1", "dcr5", "dcr10"]

    statlist = ["dcg1", "dcg3", "dcg5", "dcg10",  "sdcg1", "sdcg3", "sdcg5", "sdcg10", "cdcg", "err", "mean_rank_p", "mean_rank_e", "mean_rank_pe", "mean_rank_g", "mean_rank_f", "mean_rank_b", "ideal_dcg1", "ideal_dcg3", "ideal_dcg5", "ideal_dcg10", "ideal_sdcg1", "ideal_sdcg3", "ideal_sdcg5", "ideal_sdcg10", "ideal_err", "ndcg1", "ndcg3", "ndcg5", "ndcg10", "nsdcg1", "nsdcg3", "nsdcg5", "nsdcg10", "nerr", "swapped_pairs", "swapped_pe", "swapped_pg", "swapped_pf", "swapped_pb", "swapped_eg", "swapped_ef", "swapped_eb", "swapped_gf", "swapped_gb", "swapped_fb", "num_urls", "bdcg", "ideal_bdcg", "nbdcg", "p5", "e5", "g5", "f5", "b5", "p1", "e1", "g1", "f1", "b1", 'mean_p', 'mean_e', 'mean_g', 'mean_f', 'mean_b', 'std_p', 'std_e', 'std_g', 'std_f', 'std_b', "score_diff_pe", "score_diff_pg", "score_diff_pf", "score_diff_pb", "score_diff_eg", "score_diff_ef", "score_diff_eb", "score_diff_gf", "score_diff_gb", "score_diff_fb", "dcr1", "dcr5", "dcr10", "mse"]

    stats = dict([(s, stat(s)) for s in statlist])    

    
    # PRINT HEADER
    if verbose >= 3:
        print >>OUT, "\t".join(["query"]+[s for s in displaylist])        

    nQ = 0
    isCompRecency = True    
    c = 0
    
    for q, lSOJU in iterbyQ(lQuJ, order, lScore):
        if (not keep_domain) and isDomain(q):
            continue        
        nQ += 1        
        values = {}
        
        # stable sort by score
        lSOJU.sort()
        if not reverse:
            lSOJU.reverse()
            
        if test_uniqing:
            lSOJU = uniqing(lSOJU)
            
        # compute mean score and score diff
        score_stat = {}
        for j in 'pegfb':
            score_stat[j] = stat(j)
            
        judges = []
        recencies = []
        
        hasPerfect = False
        isNav = -1

        values["mse"] = 0.0
        
        for k,(s,i,jDict,u) in enumerate(lSOJU):
            try:
                j = jDict['grade'][0].lower() # first letter of the judgement
            except:
                print >> sys.stderr, "[ERROR] No judgement for\n%s\t%s" % (q,u)
                sys.exit()
                
            if j == 'n':
                j = 'b'
                
            try:
                score_stat[j].add(s)
            except:
                print >> sys.stderr, '[ERROR] %s is not a valid judgment.'%j
                sys.exit()
                
            judges.append(j)

            if j == 'p':
                if not hasPerfect:
                    hasPerfect = True
                    nperfects += 1

            if isCompRecency:
                r = jDict.get('recency')
                if r == None:
                    isCompRecency = False
                else:
                    recencies.append(r[0].lower())

            # query-leve judgement
            if k == 0:
                try:
                    isNav = int(jDict.get('navigational', -1))
                except:
                    isNav = -1

            # compute mse
            dcg_score = DCG.score[j]
            values["mse"] += (dcg_score - s) * (dcg_score - s)
            
        if len(lSOJU) != 0:
            values["mse"] /= len(lSOJU)
                    
        # No navigational classification infomation
        if isNav == -1:
            isNav = hasPerfect

        for j in 'pegfb':
            values['mean_'+j] = score_stat[j].average()
            values['std_'+j] = score_stat[j].deviation()

        scale = 'pegfb'                
        for a in range(5):
            j1 = scale[a]
            if values.get('mean_'+j1) == None:
                continue
            for b in range(a+1,5):
                j2 = scale[b]
                if values.get('mean_'+j2) == None:
                    continue                
                values["score_diff_"+j1+j2] = values['mean_'+j1] - values['mean_'+j2]
                
        ideal_judges = [(-1*DCG.score[j],j,p) for p,j in enumerate(judges)]
        ideal_judges.sort()
        
        sumDCG = 0
        sumSDCG = 0
        for i,(s,j,p) in enumerate(ideal_judges[:10]):
            sumDCG += DCG.score[j] * dcg.discounts[i]
            sumSDCG += SDCG.score[j] * dcg.discounts[i]
            if i == 0:
                values["ideal_dcg1"] = sumDCG
                values['ideal_sdcg1'] = sumSDCG
                values["bdcg"] = DCG.score[j] * log(2)/log(p+2)
                values["ideal_bdcg"] = DCG.score[j]
                values["nbdcg"] = log(2)/log(p+2)                
            elif i == 2:
                values["ideal_dcg3"] = sumDCG
                values['ideal_sdcg3'] = sumSDCG
            elif i == 4:
                values["ideal_dcg5"] = sumDCG
                values['ideal_sdcg5'] = sumSDCG
            elif i == 9:
                values["ideal_dcg10"] = sumDCG
                values['ideal_sdcg10'] = sumSDCG

        for i in [1,3,5,10]:
            key = 'ideal_dcg'+str(i)
            values.setdefault(key, sumDCG)
            key = 'ideal_sdcg'+str(i)
            values.setdefault(key, sumSDCG)

        
        sumDCG = 0
        sumSDCG = 0
        for i,j in enumerate(judges[:10]):
            sumDCG += DCG.score[j] * dcg.discounts[i]
            sumSDCG += SDCG.score[j] * dcg.discounts[i]
            if i == 0:
                values["dcg1"] = sumDCG
                values["sdcg1"] = sumSDCG
            if i == 2:
                values["dcg3"] = sumDCG
                values["sdcg3"] = sumSDCG
            elif i == 4:
                values["dcg5"] = sumDCG
                values["sdcg5"] = sumSDCG
            elif i == 9:
                values["dcg10"] = sumDCG
                values["sdcg10"] = sumSDCG
                
        for i in [1,3,5,10]:
            key = 'dcg'+str(i)
            values.setdefault(key, sumDCG)
            key = 'sdcg'+str(i)
            values.setdefault(key, sumSDCG)

        if isCompRecency:
            sumDCR = 0
            for i,j in enumerate(recencies[:10]):                        
                sumDCR += DCR.score[j] * dcr.discounts[i]
                if i == 0:
                    values["dcr1"] = sumDCR
                elif i == 4:
                    values["dcr5"] = sumDCR
                elif i == 9:
                    values["dcr10"] = sumDCR
                
            for n in ['dcr1', 'dcr5', 'dcr10']:
                if values.get(n) == None:
                    values[n] = sumDCR
                    
        
        sum_pos = average_position(judges)        
        for j in scale:
            if sum_pos.get(j) and sum_pos[j][1] > 0:
                values["mean_rank_%s"%j] = float(sum_pos[j][0])/sum_pos[j][1]-1
        if sum_pos['p'][1]+sum_pos['e'][1] > 0:
            values["mean_rank_pe"] = float(sum_pos['p'][0]+sum_pos['e'][0])/(sum_pos['p'][1]+sum_pos['e'][1]) - 1
                
        swapped_pairs(judges, values)
        
        values["num_urls"] = len(judges)        

        count = {}
        for j in scale:
            count[j] = 0
        for j in judges[0:5]:
            count[j] += 1
            
        for j in scale:
            values["%s5"%j] = count[j] / 5.0
            if judges and judges[0] == j:
                values["%s1"%j] = 1.0
            else:
                values["%s1"%j] = 0.0

        if values['p1'] > 0:
            nperfects_top1 += 1
        if values['p5'] >0:
            nperfects_top5 += 1
            
        if isNav:
            values['cdcg'] = values['bdcg']
            nNavQs += 1
        else:
            values['cdcg'] = values['dcg5']
                        
        # normalized dcg
        for i in [1,3,5,10]:
            suffix = str(i)
            if values["ideal_dcg"+suffix] == 0:
                values["ndcg"+suffix] = 1
            else:
                values["ndcg"+suffix] = values["dcg"+suffix]/values["ideal_dcg"+suffix]
            if values["ideal_sdcg"+suffix] == 0:
                values["nsdcg"+suffix] = 1
            else:
                values["nsdcg"+suffix] = values["sdcg"+suffix]/values["ideal_sdcg"+suffix]

        # olivier's err metric
        values["err"] = err(judges)
        ideal_judges = [b for a,b,c in ideal_judges]
        values['ideal_err'] = err(ideal_judges)
        if values['ideal_err'] == 0:
            values['nerr'] = 1.0
        else:
            values['nerr'] = values['err'] / values['ideal_err']
        
        # DEBUG INFO
        if debug:
            if values["ndcg5"] < 0.5:
                #average_debug_query_len += len(q.split())
                print >>DEBUGOUT, q, judges
                #print >>DEBUGOUT, ' '.join([j+str(s) for s,j in zip(scores, judges)])

        # Print stats for query q
        if verbose >= 3:
            print >>OUT, "\t".join([q]+[str(values.get(s)) for s in displaylist])            

        for s in stats:
            if values.get(s) != None:
                if verbose == 0:
                    # no minmax computation, faster
                    stats[s].add(values[s])
                else:
                    stats[s].add(values[s], minmax = True)
                    
    if verbose > 0:
        print >>OUT, ''
        print >>OUT, "There are %d total number of queries." % (nQ)
    
        for s in statlist:
            print >>OUT, stats[s]

    
        print >>OUT, "Out of %d queries that have perfect url, %d are ranked at top 5, and %d are ranked at top 1." %(nperfects, nperfects_top5, nperfects_top1)
        print >>OUT, "There are %d navigational queries." % nNavQs

    if debug:
        return stats, DEBUGOUT.getvalue()
    
    return stats, OUT.getvalue()

def initDCG(files, options = None):
    files = files.split(',')
    quFile = files[0]

    lQu, lJ = readQu(quFile)
    jdgDicts = readJdgFiles([f.strip() for f in files[1:]])
        
    lQuJ = makelQuJ(lQu, lJ, jdgDicts)

    if options == None:
        order = groupSameQ(lQuJ)
    else:
        order = groupSameQ(lQuJ, isSortbyJdg = options.sortbyjdg)

    return lQuJ, order
    
    
# -- Main -- #
def main():
    usage ="""
%prog <quj> <score>"""
    version = "%prog 0.2"
    oparser = optparse.OptionParser(usage=usage, version=version)
    oparser.add_option('--debug', dest = 'debug', default = False, action = 'store_true', help = 'Debug mode.')
    oparser.add_option('--reverse', dest = 'reverse', default = False, action = 'store_true', help = 'Reverse order.')
    oparser.add_option('--queries', dest = 'queryfile', default = "",  help = 'Auxilary query file.')
    oparser.add_option('--uniqing', dest = 'test_uniqing', default = False, action = 'store_true', help = 'Test Uniqing.')
    oparser.add_option('--verbose', dest = 'verbose', default = 3, type='int', help = 'Verbose mode.')
    oparser.add_option('--sortbyjdg', dest = 'sortbyjdg', default = False, action = 'store_true', help = 'Sort by judgment on ties.')
    oparser.add_option('--keep_domain', dest = 'keep_domain', default = False, action = 'store_true', help = 'Keep domain queries.')
    
        
    (options, args) = oparser.parse_args(sys.argv)

    if len(args) != 2:
        oparser.parse_args([sys.argv[0], "--help"])

        
    
    lQuJ, order = initDCG(args[1], options)
    lScore = [float(a.strip().split('\t')[-1]) for a in open(args[1]).readlines() if a.strip()]
    stats, sDCG = evalRanking(lQuJ, order, lScore,  debug = options.debug, test_uniqing = options.test_uniqing, querySet = [], verbose = options.verbose, reverse = options.reverse, keep_domain = options.keep_domain)
    sys.stdout.write(sDCG)

if (__name__ == "__main__"):
   main()

