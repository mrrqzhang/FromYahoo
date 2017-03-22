import sys,os

def normalize_vector(vector):
        split = vector.split('|')
        sum = 0
        for item in split:
                _split = item.split(':')
                cat = ':'.join(_split[:-1])
                val = _split[-1]
                sum = sum+float(val)*float(val)
        norm = float(sum**0.5)
        tmp = []
        for item in split:
                _split = item.split(':')
                cat = ':'.join(_split[:-1])
                val = _split[-1]
                tmp.append(cat+':'+str(float(val)/norm))
        return '|'.join(tmp)

def print_vector(key,dict,sum,top_k):
        tmp = []
        for cat in dict.keys():
		tmp.append([cat,dict[cat]/float(sum)])
	tmp.sort(lambda x, y: -cmp(x[1],y[1]))
	tmp_ = []
	for item in tmp:
		if len(tmp_)==top_k: break
		tmp_.append(item[0]+':'+str(item[1]))
	print key+'\t'+normalize_vector('|'.join(tmp_))

previous_key = None
top_k = int(sys.argv[1])
dict = {}
sum = 0
while True:
        line = sys.stdin.readline()
        if not line: break
	_split = line[:-1].split('\t')
	if len(_split)==3:
	        [key,vector,weight] = line[:-1].split('\t')
	else:
		[key,vector] = line[:-1].split('\t')
		weight = '1'
        if previous_key!=key:
                if previous_key!=None:
                        print_vector(previous_key,dict,sum,top_k)
                        dict = {}
                        sum = 0
        if vector!='':
                split = vector.split('|')
                for item in split:
                        split_ = item.split(':')
                        cat = ':'.join(split_[:-1])
                        if cat=='': continue
                        cat_w = float(split_[-1])*float(weight)
                        if dict.has_key(cat):
                                dict[cat] = dict[cat]+cat_w
                        else:
                                dict[cat] = cat_w
                sum = sum+1
        previous_key = key
if previous_key!=None:
        print_vector(previous_key,dict,sum,top_k)
