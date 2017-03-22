import sys,re,math

reftsv = sys.argv[1]
pd=None
def stdgen(lastline):
    for line in sys.stdin: yield line
    yield lastline
domdict = {}
with open(reftsv) as f:
    for line in f.readlines() + ['None']:
        tmp = line.strip('\n').split('\t')
        domain = tmp[0]
        if not pd == domain:
            if not pd == None:
                domdict[pd] = ret
            ret = []
            pd = domain
        ret.append(line)
pd = None
for line in sys.stdin:
    if not pd == domain:
        if pd in domdict:
            domdict.pop(pd)
        pd = domain
    domain, ql, title, score  =line.strip('\n').split('\t')
    if not domain in domdict: continue

    sys.stdout.write(line)
    
for k,v in domdict.items():
    for line in v:
        sys.stdout.write(line)

