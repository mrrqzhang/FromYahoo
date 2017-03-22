import sys,os

if len(sys.argv)>1:
	threshold = float(sys.argv[1])
	top_k = int(sys.argv[2])
else:
	threshold = 1.0e-05
	top_k = 10000
while True:
        line = sys.stdin.readline()
        if not line: break
	#[id,vector] = line[:-1].split('\t')
	line_split = line[:-1].split('\t')
	id = line_split[0]
	vector = line_split[1]
	if vector=='': continue
	split = vector.split('|')

	sum = 0
	for item in split:
                _split = item.split(':')
                cat = ':'.join(_split[:-1])
                if cat=='': continue
		val = _split[-1]
		sum = sum+float(val)*float(val)
	norm = float(sum**0.5)

	# sort and choose top k with threshold
	cat_val = []
        for item in split:
                _split = item.split(':')
                cat = ':'.join(_split[:-1])
                if cat=='': continue
                val = float(_split[-1])
		if float(val)/norm>threshold:
	                cat_val.append([cat,val])
        cat_val.sort(lambda x, y: -cmp(x[1],y[1]))
	i = 0
	sum = 0
	for item in cat_val:
		if i>=top_k: break
		cat = item[0]
		val = item[1]
		sum = sum+float(val)*float(val)
		i = i+1	
	norm = float(sum**0.5)
	if norm==0: continue

	i = 0
        sum = 0
	tmp = []
	for item in cat_val:
                if i>=top_k: break
                cat = item[0]
                val = item[1]
                sum = sum+float(val)*float(val)
		tmp.append(cat+':'+str(float(val)/norm))
                i = i+1

	if len(tmp)>0:
		print id+'\t'+'|'.join(tmp)+'\t'+str(norm)
	
