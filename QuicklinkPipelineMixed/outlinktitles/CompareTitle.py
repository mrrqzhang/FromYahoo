#!/usr/bin/env python
import sys,re,math,string
from genLibs import normalize
# we compare title candidate against golden set. If match, we use store the title

def NormalizeTitle(t,strong=True):
    ret = re.sub('</?b>','',t)

    if strong: ret = re.sub(r'[%s]'%string.punctuation,' ',ret)
    ret = re.sub('\s+',' ',ret)
    return ret.lower()

def EqualTitle(t1,t2,strong=True):
    return NormalizeTitle(t1,strong) == NormalizeTitle(t2,strong) 

if __name__ == "__main__":
     
    goldenIdx = 6 if len(sys.argv) < 2 else int(sys.argv[1])
    candidateIndices = [11,3] if len(sys.argv) < 3 else map(int,sys.argv[2].split(',')) # candidates in decreasing order of trustworthiness
    outputIndices= [0,1,4,5] if len(sys.argv) < 4 else map(int, sys.argv[3].split(',')) # non-overlapping with goldenIdx and candidateIndices
    dedup = True if len(sys.argv ) < 5 else eval(str(sys.argv[4])) # dedupping domain, ql
    if dedup: domqlset = set() 
    matchOnly = True if len(sys.argv ) < 6 else eval(str(sys.argv[5]))
    if not matchOnly:
        preferredCandidateIdx = 3 if len(sys.argv) < 7 else int(sys.argv[6])
    # incoming schema: ndom, nql, ql, newtitle,	ctr, nclicks, oldtitle,dom:chararray, ndom:chararray, ol:chararray, nol:chararray, anchor:chararray 
    # so goldIdx = 6, candidateIndices = 3,11, outputIndices = 7,9,4,5
    headers = ['ndom','nql','nclicks','ctr'] + ['golden title'] + ['match candidate' if matchOnly else 'preferred candidate']
    print '\t'.join(headers)
    
    for line in sys.stdin:
        tmp = line.strip('\n').split('\t')
        if dedup:
            if tuple(tmp[:2]) in domqlset: continue
            domqlset.add(tuple(tmp[:2]))
        candidates = [tmp[i] for i in candidateIndices]
        golden = tmp[goldenIdx]
        matchset = [i for i in candidateIndices if int(EqualTitle(tmp[i],golden,True)) ]
        if matchset:
            print '\t'.join(tmp[i] for i in outputIndices + [goldenIdx, matchset[0]])
        elif not matchOnly:
            print '\t'.join(tmp[i] for i in outputIndices + [goldenIdx, preferredCandidateIdx])

