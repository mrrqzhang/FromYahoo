#!/usr/bin/env python
import sys
url_delimiter = ['/','?','&','=','$','@',';',':','+',',']
parents = []
for line in sys.stdin:
    assert len(parents) < 1000
    try:
     url,domain,clicks,ourl = line.strip('\n\t\r ').split('\t')
    except:
         continue
    clicks = float(clicks)
    if clicks == 0: clicks = 0.1
    aclicks = clicks
    
    while parents:
        p,c,ac,op = parents[-1]
        
        if url.startswith(p) and ( url == p or (url[len(p)] in url_delimiter) or (p[-1] in url_delimiter) ): 
            parents[-1][2] += clicks
            
            break
        else: 
            print '\t'.join(map(str,[domain,p,c,ac,op]))
            parents.pop()
    if not (parents and url == p):
        parents.append([url,clicks,aclicks,ourl])
while parents:
    print '\t'.join([domain] + map(str,parents.pop()))






