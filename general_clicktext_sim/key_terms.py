import sys,os

def edit_distance(word1,word2):
        len_1=len(word1)
        len_2=len(word2)
        x =[[0]*(len_2+1) for _ in range(len_1+1)]
        for i in range(0,len_1+1):
                x[i][0]=i
        for j in range(0,len_2+1):
                x[0][j]=j
        for i in range (1,len_1+1):
                for j in range(1,len_2+1):
                        if word1[i-1]==word2[j-1]:
                                x[i][j] = x[i-1][j-1]
                        else :
                                x[i][j]= min(x[i][j-1],x[i-1][j],x[i-1][j-1])+1
        return x[i][j]

alpha = 0.05
top_k = 3

def normalize_vector(vector):
        split = vector.split('|')
        sum = 0
        for item in split:
                _split = item.split(':')
                cat = ':'.join(_split[:-1])
                val = _split[-1]
		if val!='':
	                sum = sum+float(val)*float(val)
        norm = float(sum**0.5)
        tmp = []
        for item in split:
                _split = item.split(':')
                cat = ':'.join(_split[:-1])
                val = _split[-1]
		if val!='':
	                tmp.append(cat+':'+str(float(val)/norm))
        #return ['|'.join(tmp),norm]
        return '|'.join(tmp)

while True:
        line = sys.stdin.readline()
        if not line: break
        [q,vec,norm] = line[:-1].split('\t')
	# remove terms almost identical to the query
	tmp = q.split(' ')
	q_terms = []
	for item in tmp:
		if item=='': continue
		q_terms.append(item)
		if item[-1]!='s':
			q_terms.append(item+'s')
	q_terms.append(''.join(tmp))
	split = vec.split('|')
        tmp = []
        for item in split:
                _split = item.split(':')
		if _split[-1]=='': continue
                val = float(_split[-1])
                term = ':'.join(_split[:-1])
                new_val = str(val*float(norm))
		if not ((term in q_terms) or (term+'s' in q_terms)):
			if not (len(q)>=5 and edit_distance(q,term)<=2): # not similar
		                tmp.append(term+':'+new_val)
	# select top terms after normalization
        new_vec = normalize_vector('|'.join(tmp))
	split = new_vec.split('|')
        tmp = []
        for item in split:
                _split = item.split(':')
		if _split[-1]=='': continue
                val = float(_split[-1])
                term = ':'.join(_split[:-1])
		if val>alpha:
			tmp.append([term,val])
	tmp.sort(lambda x, y: -cmp(x[1],y[1]))
	keyterms = []
	for i in range(top_k):
		if i<len(tmp):
			keyterms.append(tmp[i][0])
	if len(keyterms)>=1:
		print q+'\t'+'|'.join(keyterms)
