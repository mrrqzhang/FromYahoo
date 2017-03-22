import sys,os

while True:
        line = sys.stdin.readline()
        if not line: break
	split = line[:-1].split('\t')
	q = split[0]
	_url = split[1]
	click = split[2]
	url = _url.replace('https://','')
        host = url.split('/')[0]+'/'
	print q+'\t'+host+'\t'+click
