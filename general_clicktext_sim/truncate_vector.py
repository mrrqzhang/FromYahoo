import sys,os

def truncate(v,cut):
        split = v.split('|')
        tmp = []
        for item in split:
                _split = item.split(':')
                term = ':'.join(_split[:-1])
                weight = _split[-1]
                tmp.append([term,float(weight)])
        tmp.sort(lambda x, y: -cmp(x[1],y[1]))
	new_vec = []
        i = 0
        for item in tmp:
                if i==cut: break
		new_vec.append(item[0]+':'+str(item[1]))
                i = i+1
        return '|'.join(new_vec)

cut = int(sys.argv[1])
while True:
        line = sys.stdin.readline()
        if not line: break
        [q,v,norm] = line[:-1].split('\t')
	print q+'\t'+truncate(v,cut)+'\t'+norm
