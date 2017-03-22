import sys,os

while True:
        line = sys.stdin.readline()
        if not line: break
        split = line[:-1].split('\t')
        _url = split[0]
        url = _url.replace('https://','')
        host = url.split('/')[0]
        print split[0]+'\t'+split[1]+'\t'+host
