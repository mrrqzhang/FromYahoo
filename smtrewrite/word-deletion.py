import sys



def insert_dict(d,w,x):
    if w in d:
       d[w][0] += x[0]
       d[w][1] += x[1]
    else:
       d.setdefault(w,x)


wdict=dict()
for line in sys.stdin:
    adgid,query,rewrite = line.strip('\r\n ').split('\t')
    vquery = query.split()
    vrewrite = rewrite.split()
    for word in vquery:
        if word in vrewrite:          
          insert_dict(wdict,word,[1,1])
        else:
          insert_dict(wdict,word, [1,0])

for key in wdict:
    sys.stdout.write('%s\t%d\t%d\n' % (key,wdict[key][0],wdict[key][1]))

