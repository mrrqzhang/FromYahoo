import sys,os,random

def gen_avg(key,bag):
	term_weight = {}
        for vector in bag:
		v_split = vector.split('|')
		for item in v_split:
			split = item.split(':')
	                term = ':'.join(split[:-1])
        	        weight = float(split[-1])
			if term_weight.has_key(term):
				term_weight[term] = term_weight[term]+weight
			else:
				term_weight[term] = weight
	tmp = []
	for term in term_weight.keys():
	        tmp.append(term+':'+str(term_weight[term]/len(bag)))
        print key+'\t'+normalize_vector_truncate_20('|'.join(tmp))

def normalize_vector_truncate_20(vector):
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
                if len(tmp)==20: break
        return '|'.join(tmp)

previous_key = None
k = int(sys.argv[1]) 
list = []
count = 0
while True:
        line = sys.stdin.readline()
        if not line: break
        [id,vec] = line[:-1].split('\t')
	count = count+1
        if previous_key!=id:
                if previous_key!=None:
                        gen_avg(previous_key,list)
                        list = []
			count = 0
	if len(list) < k:
		list.append(vec)
        else:
                if random.random()<float(k)/float(count):
                        i = int(random.random()*k)
			list[i] = vec 
        previous_key = id
if previous_key!=None:
        gen_avg(previous_key,list)

