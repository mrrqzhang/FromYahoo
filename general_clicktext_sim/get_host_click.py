import sys,os

while True:
        line = sys.stdin.readline()
        if not line: break
        split = line[:-1].split('\t')
        _url = split[0]
        click = split[1]
        url = _url.replace('https://','')
        host = url.split('/')[0]
        print url+'\t'+click+'\t'+host
