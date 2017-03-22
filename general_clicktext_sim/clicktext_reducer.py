import sys,os,random

def output_vector(previous_key,vector):
	_v = {}
	for _term in vector:
		split = _term.split(':')
		count = int(float(split[-1]))
		term = ':'.join(split[:-1])
		if _v.has_key(term):
			_v[term] = _v[term]+count
		else:
			_v[term] = count
	all_keys = _v.keys()
        if len(all_keys)==0: return
        sys.stdout.write(previous_key+'\t')
        for i in range(len(all_keys)-1):
                sys.stdout.write(str(all_keys[i])+':'+str(_v[all_keys[i]])+'|')
        sys.stdout.write(str(all_keys[-1])+':'+str(_v[all_keys[-1]])+'\n')

def update_vector(vector,words,M,N):
	_words = words.split('|')
	for word in _words:
		if word=='': continue
		N = N+1
		if len(vector)<M:
			vector.append(word)
		else:
			if random.random()<float(M)/float(N):
				i = int(random.random()*M)
				vector[i] = word

previous_key = None
#M = 100000
M = 1000000
vector = []
N = 0
while True:
	line = sys.stdin.readline()
	if not line: break
	[key,words] = line[:-1].split('\t')
	if previous_key!=key:
		if previous_key!=None:
			output_vector(previous_key,vector)
			vector = []
			N = 0
	update_vector(vector,words,M,N)
	previous_key = key
if previous_key!=None:
	output_vector(previous_key,vector)

