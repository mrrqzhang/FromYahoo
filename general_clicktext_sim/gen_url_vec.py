import sys,os,re

def norm(vector):
        split = vector.split('|')
        sum = 0
        for item in split:
                _split = item.split(':')
                cat = ':'.join(_split[:-1])
                val = _split[-1]
                sum = sum+float(val)*float(val)
        norm = float(sum**0.5)
        if norm==0: return ''
        tmp = []
        for item in split:
                _split = item.split(':')
                cat = ':'.join(_split[:-1])
		if cat=='': continue
                val = _split[-1]
                tmp.append(cat+':'+str(float(val)/norm))
	if len(tmp)>0:
	        return'|'.join(tmp)
	else:
		return ''

def parseURL(url,stopwords):
	delimiters = ['/','-','%20','%3A','%2C','_','?','=','.','html',',',':']
	split = url.split('/')
	if len(split)<2: return ''
	if split[1]=='': return ''
	tmpurl = '/'.join(split[1:])
	tmpurl = re.sub('[0-9]+','\t',tmpurl)
	for delim in delimiters:
		tmpurl = tmpurl.replace(delim,'\t')
	tmp = []
	split = tmpurl.split('\t')
	for item in split:
		if item!='' and (not stopwords.has_key(item)) and len(item)>1:
			tmp.append(item.lower())
	if len(tmp)>0:
		return '|'.join(tmp)
	else:
		return ''

def term_counts(s):
	counts = {}
	for term in s.split('|'):
		if term=='': continue
		if counts.has_key(term):
			counts[term] = counts[term]+1
		else:
			counts[term] = 1
	tmp = []
	for term in counts.keys():
		if term!='':
			tmp.append(term+':'+str(counts[term]))
	if len(tmp)>0:
		return '|'.join(tmp)
	else:
		return ''

stopwords = {}
file = open(sys.argv[1],'r')
for line in file:
	stopwords[line[:-1]] = 1

while True:
        line = sys.stdin.readline()
        if not line: break
        [qry,url,clicks,vec] = line[:-1].split('\t')
	if vec!='':
		print qry+'\t'+clicks+'\t'+vec
	else:
		tmp1 = parseURL(url,stopwords)
		if tmp1!='':
			tmp2 = term_counts(tmp1)
			if tmp2!='':
				tmp3 = norm(tmp2)
				if tmp3!='':
					print qry+'\t'+clicks+'\t'+tmp3
