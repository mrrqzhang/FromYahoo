import sys,os

rate = 0.5
pos_ctr = [1.0,0.26,0.15,0.11,0.09]

while True:
        line = sys.stdin.readline()
        if not line: break
        [q,u,pos,_maxclicks] = line[:-1].split('\t')
	if _maxclicks=='': _maxclicks = '0'
	if float(_maxclicks)<100:
		maxclicks = 100.0
	else:
		maxclicks = float(_maxclicks)
	print q+'\t'+u+'\t'+str(pos_ctr[int(pos)]*maxclicks*rate)
