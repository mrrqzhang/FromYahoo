import sys,os

top_k = int(sys.argv[1])

while True:
        line = sys.stdin.readline()
        if not line: break
	[q,vec] = line[:-1].split('\t')
	split = vec.split('|')
	list = []
	for item in split:
		[term,_count] = item.split(':')
		if term=='': continue
		list.append([term,int(_count)])
	list.sort(lambda x, y: -cmp(x[1],y[1]))
	tmp = []
	for i in range(top_k):
		if i==len(list): break
		tmp.append(list[i][0]+':'+str(list[i][1]))
	if len(tmp)>0:
		print q+'\t'+'|'.join(tmp)
	
