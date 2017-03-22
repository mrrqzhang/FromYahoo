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

def get_doc_vec_from_url(url,stopwords):
	doc_vec = ''
	tmp1 = parseURL(url,stopwords)
        if tmp1!='':
        	tmp2 = term_counts(tmp1)
                if tmp2!='':
                	doc_vec = norm(tmp2)
	return doc_vec

def get_doc_vec_from_qry(qry):
	doc_vec = ''
	tmp1 = qry.replace(' ','|')
	tmp2 = term_counts(tmp1)
        if tmp2!='':
        	doc_vec = norm(tmp2)
	return doc_vec

def sim(v1,v2):
        v1_sum = 0
        for item in v1.keys():
                v1_sum = v1_sum+v1[item]**2
        v2_sum = 0
        for item in v2.keys():
                v2_sum = v2_sum+v2[item]**2
        dot_p = 0
        for item in v1.keys():
                if v2.has_key(item):
                        dot_p = dot_p+v1[item]*v2[item]
        if v1_sum**0.5+v2_sum**0.5==0:
                return 0
        else:
                return float(dot_p)/((v1_sum**0.5)*(v2_sum**0.5))

#def get_vector(v):
#        _v = {}
#        split = v.split('|')
#        for item in split:
#                _split = item.split(':')
#                term = ':'.join(_split[:-1])
#                weight = _split[-1]
#                _v[term] = float(weight)
#        return _v

def get_vector(v):
        _v = {}
        split = v.split('|')
	tmp = []
        for item in split:
                _split = item.split(':')
                term = ':'.join(_split[:-1])
                weight = _split[-1]
		tmp.append([term,float(weight)])
	tmp.sort(lambda x, y: -cmp(x[1],y[1]))
	i = 0
	for item in tmp:
		if i==20: break
		_v[item[0]] = item[1]
		i = i+1
        return _v

while True:
        line = sys.stdin.readline()
        if not line: break
        [q,u1,u2,host,qv,dv,hv] = line[:-1].split('\t')
	f_str = q+'\t'+u1 
	if qv=='':
		f_str = f_str+'\t0\t-1\t-1'
	else:
		if dv=='':
			sim_doc = -1
		else:
			sim_doc = sim(get_vector(qv),get_vector(dv))
		if hv=='':
			sim_host = -1
		else:
			sim_host = sim(get_vector(qv),get_vector(hv))
		f_str = f_str+'\t1\t'+str(sim_doc)+'\t'+str(sim_host)
	qv = get_doc_vec_from_qry(q)
	if dv=='':
        	sim_doc = -1
        else:
                sim_doc = sim(get_vector(qv),get_vector(dv))
        if hv=='':
                sim_host = -1
        else:
                sim_host = sim(get_vector(qv),get_vector(hv))
        f_str = f_str+'\t'+str(sim_doc)+'\t'+str(sim_host)
	print f_str
