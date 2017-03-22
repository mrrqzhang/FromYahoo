import sys,os

while True:
        line = sys.stdin.readline()
        if not line: break
        [_qry,url,click] = line[:-1].split('\t')
	qry = _qry.strip()
	if qry!='':
		print qry+'\t'+url+'\t'+click
