import os,sys,string

def query_normalize(query):
        q = query.lower()
        for char in set(string.punctuation):
                if char=="'": continue
                q = q.replace(char,' ')
        split = q.split(' ')
        tmp = []
        for _term in split:
                term = _term.strip()
                if term!='':
                        tmp.append(term)
        return ' '.join(tmp)

def is_ascii(s):
	blnAscii = True
	for char in s:
		if ord(char) >= 128:
			blnAscii = False
	return blnAscii

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

#click_threshold = 4
stop = {}

stop_file = open(sys.argv[1],'r')
for line in stop_file:
	stop[line[:-1]] = 1

while True:
        line = sys.stdin.readline()
        if not line: break
        [_q,_url,click] = line[:-1].split('\t')
        #[_q,_url,click,view,qfreq] = line[:-1].split('\t')
	if click=='': continue
	if not is_ascii(_q): continue
	url = _url.replace('https://','')
	host = url.split('/')[0]
	#site = host.split('.')[-2]
	q = query_normalize(_q)
	terms = q.split(' ')
	terms_w = []
	for term in terms:
		#if term=='' or '.' in term or stop.has_key(term) or ':' in term or ('google' in site and 'goo' in term): continue
		if term=='' or '.' in term or stop.has_key(term) or ':' in term: continue
		#terms_w.append(term+':'+click)
		terms_w.append(term+':1')
	if len(terms_w)>0:
		print host+'/\t'+'|'.join(terms_w)
