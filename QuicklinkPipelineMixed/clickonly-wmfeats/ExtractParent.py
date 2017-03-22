#!/usr/bin/env python
import sys
url_delimiter = ['/','?','&','=','$','@',';',':','+',',']
parents = []

# output is simply: url, ourl, parent, oparent, number of clicks of url, number of self + imm-children clicks of url
for line in sys.stdin:
    assert len(parents) < 1000
    try:
        url,domain,clicks,views,ourl,linkflux = line.strip('\n\t\r ').split('\t')
    except:
        continue
    clicks = float(clicks)
    while parents:
        p,op,c,c1 = parents[-1]
        if url.startswith(p) and ( url == p or (url[len(p)] in url_delimiter) or (p[-1] in url_delimiter) ): 
            parents[-1][3] += clicks
            break
        else:
            parents.pop()

            gparents = ['None','None'] if not parents else parents[-1][:2]
            #print '\t'.join(map(str, [p, op, gparents[0], gparents[1], c, c + c1]))
            print '\t'.join(map(str, [gparents[1],op, c + c1]))
    if not (parents and url == p):
        parents.append([url,ourl, clicks, 0.0])

while parents:
    p,op,c,c1 = parents.pop()
    gparents = ['None','None'] if not parents else parents[-1][:2]
    #print '\t'.join(map(str, [p, op, gparents[0], gparents[1], c, c + c1]))
    print '\t'.join(map(str, [gparents[1],op, c + c1]))


