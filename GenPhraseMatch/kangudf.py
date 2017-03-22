# encoding=utf8

import sys,os,hashlib,bisect,math,random,operator,string

@outputSchema("y:bag{t:tuple(newq:chararray)}")
def gen_all_bigrams(query):
	set = []
	qry = query.split(' ')
	n = len(qry)
	for i in range(n-1):
                set.append(qry[i]+'_'+qry[i+1])
	return set

@outputSchema("feature_vector:chararray")
def gen_features_class_sim(features,s1,s2):
	diff = 2/(1+math.exp(-300*(s1-s2)))-1
	if '|b ' in features:
		return features+' #sim:'+str(diff)
	else:
		return features+'|b #sim:'+str(diff)

@outputSchema("feature_vector:chararray")
def gen_features_class_sim_test(features,s1,s2):
        diff = 2/(1+math.exp(-300*(s1-s2)))-1
        if '|b ' in features:
                return features+' #sim:'+str(diff+1.0)
        else:
                return features+'|b #sim:'+str(diff)

@outputSchema("feature_vector:chararray")
def gen_features(orig_qry,label,weight):
        features = []
        _qry = orig_qry.replace(':', '$COLON$')
        _qry = _qry.replace('|', '$PIPE$')
        _qry = _qry.replace('"', ' ')
        _qry = _qry.replace('-', ' ')
        _qry = _qry.replace(',', ' ')
        qry = []
        for item in _qry.split(' '):
                if item!='': qry.append(item)
        n = len(qry)
        # generate unigrams
        for i in range(n):
                features.append(qry[i])
        # bigrams
        for i in range(n-1):
                features.append(qry[i]+'_'+qry[i+1])
        if n==1:
                features.append('<s>'+_qry+'</s>'.replace(' ','_'))
	else:
		features.append('<s>'+qry[0])
		features.append(qry[-1]+'</s>')
        return label+' '+weight+' '+orig_qry.replace(' ','#_SPACE_#').replace('|','#_PIPE_#')+'|a '+' '.join(features)

@outputSchema("feature_vector:chararray")
def gen_features_locattr_conditional_unigram(orig_qry,label,weight,vector):
        reload(sys)
        sys.setdefaultencoding('utf8')
        locattr_terms = ['store','stores','location','locations','shop','shops','near']
        matched = []
        if vector!=None:
                for t in vector.split('|'):
                        _split = t.split(':')
                        _t = ':'.join(_split[:-1])
                        if _t in locattr_terms:
                                matched.append(_t)
        features = []
        _qry = orig_qry.replace(':', '$COLON$')
        _qry = _qry.replace('|', '$PIPE$')
        _qry = _qry.replace('"', ' ')
        _qry = _qry.replace('-', ' ')
        _qry = _qry.replace(',', ' ')
        qry = []
        for item in _qry.split(' '):
                if item!='': qry.append(item)
        n = len(qry)
        # generate unigrams
        for i in range(n):
                features.append(qry[i])
        if n==1:
                features.append('<s>'+_qry+'</s>'.replace(' ','_'))
        #elif n>1:
        #        features.append('<s>'+qry[0])
        #        features.append(qry[-1]+'</s>')
        nonlocal_terms = ['online','website','websites','coupon','coupons','com','.com']
        blnDomain = False
        for term in qry:
                if '.' in term and term!='.':
                        blnDomain = True
        blnNonLocalTerm = False
        for term in qry:
                if term in nonlocal_terms:
                        blnNonLocalTerm = True
        if n>0:
                if len(matched)==0 or blnDomain or blnNonLocalTerm:
                        return label+' '+weight+' '+orig_qry.replace(' ','#_SPACE_#').replace('|','#_PIPE_#').encode('utf-8')+'|a '+' '.join(features)
                else:
                        return label+' '+weight+' '+orig_qry.replace(' ','#_SPACE_#').replace('|','#_PIPE_#').encode('utf-8')+'|a '+' '.join(features)+'|b '+' '.join(matched)

@outputSchema("feature_vector:chararray")
def gen_features_locattr_conditional_grid(orig_qry,vector):
	label = '1'
	weight = '1'
        if orig_qry==None:
                return
        reload(sys)
        sys.setdefaultencoding('utf8')
        locattr_terms = ['store','stores','location','locations','shop','shops','near']
        matched = []
        if vector!=None:
                for t in vector.split('|'):
                        _split = t.split(':')
                        _t = ':'.join(_split[:-1])
                        if _t in locattr_terms:
                                matched.append(_t)
        features = []
        _qry = orig_qry.replace(':', '$COLON$')
        _qry = _qry.replace('|', '$PIPE$')
        _qry = _qry.replace('"', ' ')
        _qry = _qry.replace('-', ' ')
        _qry = _qry.replace(',', ' ')
        qry = []
        for item in _qry.split(' '):
                if item!='': qry.append(item)
        n = len(qry)
        # generate unigrams
        for i in range(n):
                features.append(qry[i])
        # bigrams
        for i in range(n-1):
                features.append(qry[i]+'_'+qry[i+1])
        if n==1:
                features.append('<s>'+_qry+'</s>'.replace(' ','_'))
        nonlocal_terms = ['online','website','websites','coupon','coupons','com','.com']
        blnDomain = False
        for term in qry:
                if '.' in term and term!='.':
                        blnDomain = True
        blnNonLocalTerm = False
        for term in qry:
                if term in nonlocal_terms:
                        blnNonLocalTerm = True
        if n>0:
                if len(matched)==0 or blnDomain or blnNonLocalTerm:
                        return label+' '+weight+' '+orig_qry.replace(' ','#_SPACE_#').replace('|','#_PIPE_#').encode('utf-8')+'|a '+' '.join(features)
                else:
                        return label+' '+weight+' '+orig_qry.replace(' ','#_SPACE_#').replace('|','#_PIPE_#').encode('utf-8')+'|a '+' '.join(features)+'|b '+' '.join(matched)

@outputSchema("feature_vector:chararray")
def gen_features_locattr_conditional(orig_qry,label,weight,vector):
	if orig_qry==None:
		return
        reload(sys)
        sys.setdefaultencoding('utf8')
        locattr_terms = ['store','stores','location','locations','shop','shops','near']
        matched = []
        if vector!=None:
                for t in vector.split('|'):
                        _split = t.split(':')
                        _t = ':'.join(_split[:-1])
                        if _t in locattr_terms:
                                matched.append(_t)
        features = []
        _qry = orig_qry.replace(':', '$COLON$')
        _qry = _qry.replace('|', '$PIPE$')
        _qry = _qry.replace('"', ' ')
        _qry = _qry.replace('-', ' ')
        _qry = _qry.replace(',', ' ')
        qry = []
        for item in _qry.split(' '):
                if item!='': qry.append(item)
        n = len(qry)
        # generate unigrams
        for i in range(n):
                features.append(qry[i])
        # bigrams
        for i in range(n-1):
                features.append(qry[i]+'_'+qry[i+1])
        if n==1:
                features.append('<s>'+_qry+'</s>'.replace(' ','_'))
        #elif n>1:
        #        features.append('<s>'+qry[0])
        #        features.append(qry[-1]+'</s>')
	nonlocal_terms = ['online','website','websites','coupon','coupons','com','.com']
	blnDomain = False
	for term in qry:
		if '.' in term and term!='.':
			blnDomain = True
	blnNonLocalTerm = False
	for term in qry:
		if term in nonlocal_terms:
			blnNonLocalTerm = True
        if n>0:
                if len(matched)==0 or blnDomain or blnNonLocalTerm:
                        return label+' '+weight+' '+orig_qry.replace(' ','#_SPACE_#').replace('|','#_PIPE_#').encode('utf-8')+'|a '+' '.join(features)
                else:
                        return label+' '+weight+' '+orig_qry.replace(' ','#_SPACE_#').replace('|','#_PIPE_#').encode('utf-8')+'|a '+' '.join(features)+'|b '+' '.join(matched)

@outputSchema("feature_vector:chararray")
def gen_features_locattr(orig_qry,label,weight,vector):
	reload(sys)  
	sys.setdefaultencoding('utf8')
	locattr_terms = ['store','stores','location','locations','shop','shops','near']
	matched = []
	if vector!=None:
		for t in vector.split('|'):
			_split = t.split(':')
			_t = ':'.join(_split[:-1])
			if _t in locattr_terms:
				matched.append(_t)
        features = []
        _qry = orig_qry.replace(':', '$COLON$')
        _qry = _qry.replace('|', '$PIPE$')
        _qry = _qry.replace('"', ' ')
        _qry = _qry.replace('-', ' ')
        _qry = _qry.replace(',', ' ')
        qry = []
        for item in _qry.split(' '):
                if item!='': qry.append(item)
        n = len(qry)
        # generate unigrams
        for i in range(n):
                features.append(qry[i])
        # bigrams
        for i in range(n-1):
                features.append(qry[i]+'_'+qry[i+1])
        if n==1:
                features.append('<s>'+_qry+'</s>'.replace(' ','_'))
        #elif n>1:
        #        features.append('<s>'+qry[0])
        #        features.append(qry[-1]+'</s>')
	if n>0:
		if len(matched)==0:
		        return label+' '+weight+' '+orig_qry.replace(' ','#_SPACE_#').replace('|','#_PIPE_#').encode('utf-8')+'|a '+' '.join(features)
		else:
		        return label+' '+weight+' '+orig_qry.replace(' ','#_SPACE_#').replace('|','#_PIPE_#').encode('utf-8')+'|a '+' '.join(features)+'|b '+' '.join(matched)

@outputSchema("entropy:chararray")
def entropy(vector):
	sum = 0
	split = vector.split('|')
	p_list = []
        for item in split:
                _split = item.split(':')
                val = float(_split[-1])
		sum = sum+val
		p_list.append(val)
		if len(p_list)==5: break
	new_sum = 0
	for i in range(len(p_list)):
		p = p_list[i]/float(sum)
		new_sum = new_sum+p*math.log(p)
	if len(p_list)==1:
		return 0
	else:
		return -1*(new_sum/math.log(len(p_list)))

@outputSchema("y:bag{t:tuple(newq:chararray)}")
def top_related_qry(vector,k):
	candidate_set = []
	split = vector.split('|')
	for item in split:
		_split = item.split(':')
		nq = ':'.join(_split[:-1])
		candidate_set.append(nq)
		if len(candidate_set)==k: break
        return candidate_set

@outputSchema("y:bag{t:tuple(newq:chararray)}")
def gen_normalized_candidates(query):
        candidate_set = []
	split = query.split(' ')
	if len(split)>=5:
		query = query.replace(' in ',' ')
	split = query.split(' ')
	orig_split = query.split(' ')
	for i in range(len(split)):
		for j in range(len(split)):
			split[j] = orig_split[j]
		term = split[i]
		if len(term)>=3 and term[-1]=='s':
			split[i] = term[:-1]
			candidate_set.append(' '.join(split))
	return candidate_set

@outputSchema("loc:chararray")
def add_more_loc(loc,vector):
	list = []
	list.append(loc.replace('_',' '))
	split = vector.split('|')
	for item in split:
		_split = item.split(':')
		_loc = ':'.join(_split[:-1])
		val = float(_split[-1])
		if val>0.3 and _loc.replace('_',' ')!=loc:
			list.append(_loc.replace('_',' '))
	return '|'.join(list)

@outputSchema("loc:chararray")
def remove_underscore(loc):
	return loc.replace('_',' ')
	
@outputSchema("loc:chararray")
def explicit_local(query,vector):
        q_terms = query.split(' ')
	final_loc = ''
        if vector!=None:
                first = vector.split('|')[0]
                split = first.split(':')
                loc = ':'.join(split[:-1])
                first_loc = loc
                score = float(split[-1])
                city_name = ' '.join(loc.split('_')[:-1])
                city_name_joined = ''.join(loc.split('_')[:-1])
		state = loc.split('_')[-1]
                if score>0.85 and (city_name in query or city_name_joined in query) and not ((query in city_name) or (query in city_name_joined)):
			if (q_terms[0] in city_name) or (q_terms[0] in city_name_joined) or (q_terms[-1] in city_name) or (q_terms[-1]==state):
				final_loc = loc
		if len(vector.split('|'))>1:
			second = vector.split('|')[1]
			split = second.split(':')
        	        loc = ':'.join(split[:-1])
	                score = float(split[-1])
        	        city_name = ' '.join(loc.split('_')[:-1])
                	city_name_joined = ''.join(loc.split('_')[:-1])
	                state = loc.split('_')[-1]
        	        if score>0.25 and (first_loc in loc) and (city_name in query or city_name_joined in query) and not ((query in city_name) or (query in city_name_joined)):
                	        if (q_terms[0] in city_name) or (q_terms[0] in city_name_joined) or (q_terms[-1] in city_name) or (q_terms[-1]==state):
                        	        final_loc = loc
		if final_loc!='':
			return final_loc

@outputSchema("loc:chararray")
def uniq_local(query,vector):
        q_terms = query.split(' ')
        final_loc = ''
        if vector!=None:
                first = vector.split('|')[0]
                split = first.split(':')
                first_loc = ':'.join(split[:-1])
                first_score = float(split[-1])
		if first_score>0.99:
			final_loc = first_loc
                if len(vector.split('|'))>1:
                        second = vector.split('|')[1]
                        split = second.split(':')
                        second_loc = ':'.join(split[:-1])
                        second_score = float(split[-1])
			if first_score>0.9 and second_score<0.4:
				final_loc = first_loc
	if final_loc!='':
		return final_loc
		
@outputSchema("loc:chararray")
def not_explicit_local(vector):
        if vector!=None:
                first = vector.split('|')[0]
                split = first.split(':')
                loc = ':'.join(split[:-1])
                score = float(split[-1])
                #if score<0.7:
                if score<0.75:
                        return loc

@outputSchema("v:chararray")
def non_international_vector(vector):
	blnInternational = False
        if vector!=None:
		split = vector.split('|')
		for i in range(len(split)):
			if i==7: break
			_split = split[i].split(':')
			term = ':'.join(_split[:-1])
			if term=='canada' or term=='uk':
				blnInternational = True
	if not blnInternational:
		return vector

@outputSchema("y:bag{t:tuple(newq:chararray)}")
def parsing_candidates_old(query,loc_):
	loc = loc_.replace('_',' ')
	candidate_set = []
	split = query.split(' ')
	for i in range(len(split)-1):
		candidate = ' '.join(split[:i+1])
		if not (candidate in candidate_set):
			if not (candidate in loc):
				candidate_set.append(candidate)
	for i in range(len(split)-1):
                candidate = ' '.join(split[(-i-1):])
                if not (candidate in candidate_set):
                        if not (candidate in loc):
	                        candidate_set.append(candidate)
	return candidate_set

@outputSchema("y:bag{t:tuple(newq:chararray)}")
def parsing_candidates(query,loc_):
        loc = loc_.replace('_',' ')
	city_name = ' '.join(loc.split(' ')[:-1])
        city_name_joined = ''.join(loc.split(' ')[:-1])
	state = loc.split(' ')[-1]
        candidate_set = []
        split = query.split(' ')
	k = len(split)
        for i in range(k-1):
                candidate = ' '.join(split[:k-i-1])
		last_part = ' '.join(split[-(i+1):])
		if (city_name in last_part) or (city_name_joined in last_part):
                        if not (candidate in loc):
				candidate_split = candidate.split(' ')
				if candidate_split[-1]=='in' or candidate_split[-1]=='near' or candidate_split[-1]=='at' or candidate_split[-1]=='for':
					candidate_set.append(' '.join(candidate_split[:-1]))
				else:
	                                candidate_set.append(candidate)
				break
        for i in range(k-1):
                candidate = ' '.join(split[i+1:])
		first_part = ' '.join(split[:i+1])
		if (city_name in first_part) or (city_name_joined in first_part):
	                if not (candidate in candidate_set):
        	                if not (candidate in loc):
					candidate_split = candidate.split(' ')
					if candidate_split[0]==state:
						candidate_set.append(' '.join(candidate_split[1:]))
					else:
	                	                candidate_set.append(candidate)
				break
	candidate_set.append(query)
        return candidate_set

@outputSchema("y:bag{t:tuple(q:chararray,newq:chararray,loc:chararray)}")
def select_parsed_q(bag):
        candidate_set = []
        for [q,newq,loc,sim] in bag:
                candidate_set.append([q,newq,loc,float(sim)])
        candidate_set_sorted = sorted(candidate_set, key=operator.itemgetter(3), reverse=True)
	# the first one is the same as the original query
	# the second one is the one without location
	if len(candidate_set_sorted)==1:
	        return [(candidate_set_sorted[0][0],candidate_set_sorted[0][1],candidate_set_sorted[0][2])]
	else:
		return [(candidate_set_sorted[1][0],candidate_set_sorted[1][1],candidate_set_sorted[1][2])]

@outputSchema("y:bag{t:tuple(q:chararray,newq:chararray,p1:chararray,p2:chararray,sim:chararray)}")
def select_newq(bag):
	candidate_set = []
	for [q,newq,p1,p2,sim] in bag:
		candidate_set.append([q,newq,int(p1),int(p2),float(sim[:4])])
	candidate_set_sorted = sorted(candidate_set, key=operator.itemgetter(4,3), reverse=True)
	return [(candidate_set_sorted[0][0],candidate_set_sorted[0][1],candidate_set_sorted[0][2],candidate_set_sorted[0][3],candidate_set_sorted[0][4])]

@outputSchema("y:bag{t:tuple(q:chararray,newq:chararray,p1:chararray,p2:chararray,sim:chararray)}")
def select_newq_params(bag,p_sim,p_pop_ratio):
        candidate_set = []
        for [q,newq,p1,p2,sim] in bag:
                candidate_set.append([q,newq,int(p1),int(p2),float(sim[:4])])
        candidate_set_sorted = sorted(candidate_set, key=operator.itemgetter(4,3), reverse=True)
	if candidate_set_sorted[0][4]>=float(p_sim) and candidate_set_sorted[0][3]>float(p_pop_ratio)*candidate_set_sorted[0][2]:
	        return [(candidate_set_sorted[0][0],candidate_set_sorted[0][1],candidate_set_sorted[0][2],candidate_set_sorted[0][3],candidate_set_sorted[0][4])]

@outputSchema("query:chararray")
def norm_query(query):
	if len(query)>=5:
		if (query[:4]=='www.' or query[:4]=='www ') and (query[-3:]=="com"):
			return query[4:].replace(' ','.')
		else:
			return query
	else:
		return query

def permutations(iterable, r=None):
    # permutations('ABCD', 2) --> AB AC AD BA BC BD CA CB CD DA DB DC
    # permutations(range(3)) --> 012 021 102 120 201 210
    pool = tuple(iterable)
    n = len(pool)
    r = n if r is None else r
    if r > n:
        return
    indices = range(n)
    cycles = range(n, n-r, -1)
    yield tuple(pool[i] for i in indices[:r])
    while n:
        for i in reversed(range(r)):
            cycles[i] -= 1
            if cycles[i] == 0:
                indices[i:] = indices[i+1:] + indices[i:i+1]
                cycles[i] = n - i
            else:
                j = cycles[i]
                indices[i], indices[-j] = indices[-j], indices[i]
                yield tuple(pool[i] for i in indices[:r])
                break
        else:
            return

def product(*args, **kwds):
    # product('ABCD', 'xy') --> Ax Ay Bx By Cx Cy Dx Dy
    # product(range(2), repeat=3) --> 000 001 010 011 100 101 110 111
    pools = map(tuple, args) * kwds.get('repeat', 1)
    result = [[]]
    for pool in pools:
        result = [x+[y] for x in result for y in pool]
    for prod in result:
        yield tuple(prod)

def find_closest(term,list_terms):
	min_score = 100000
	closest_term = ''
	for e in list_terms:
		common = 0
		for ch in e:
			if ch in term:
				common = common+1
		score = stredit(term,e)+1.0/(1.0+common)
		if score < min_score:
			min_score = score
			closest_term = e
	return closest_term

@outputSchema("y:bag{t:tuple(q:chararray,newq:chararray,qv:chararray)}")
def gen_newq_qvbased(query,vector):
        # split, replace, drop
        threshold = 0.1
        max_num_vt = 10
        max_num_vt_per_qt = 3
        vt = [] # vector terms
        qt = query.split(' ') # query terms
        qt_2_vt = []
        if vector==None:
                return [(query,query,'')]
        for item in vector.split('|'):
                split = item.split(':')
                weight = float(split[-1])
                term = ':'.join(split[:-1])
                if weight>threshold and len(vt)<max_num_vt:
                        vt.append(term)
        qt_2_vt_ = {}
        blnPerfectMatch = {}
        for _qt in qt:
                blnPerfectMatch[_qt] = False
        for _vt in vt:
                _qt = find_closest(_vt,qt)
                #print _vt, _qt
                if qt_2_vt_.has_key(_qt):
                        if len(qt_2_vt_[_qt])<max_num_vt_per_qt and not blnPerfectMatch[_qt]:
                                qt_2_vt_[_qt].append(_vt)
                else:
                        qt_2_vt_[_qt] = [_vt]
                if stredit(_qt,_vt)<=1:
                        blnPerfectMatch[_qt] = True
        for _qt in qt:
                if qt_2_vt_.has_key(_qt):
                        if len(qt_2_vt_[_qt])==1:
                                qt_2_vt.append(qt_2_vt_[_qt])
                        else:
                                tmp = []
                                for i in range(len(qt_2_vt_[_qt])):
                                        for item in list(permutations(qt_2_vt_[_qt],i+1)):
                                                tmp.append(' '.join(item))
                                qt_2_vt.append(tmp)
                else:
                        qt_2_vt.append([''])
	sum = 0
        for i in range(len(qt_2_vt)):
                sum = sum+len(qt_2_vt[i])
	if sum>30:
		return [(query,query,vector)]
	try:
	        _product = list(product(*qt_2_vt))
	except:
		print >> sys.stderr, query, vector
        new_query_set = []
        for item in _product:
                tmp = []
                for e in item:
                        if e!='':
                                tmp.append(e)
                new_query_set.append(' '.join(tmp))
        #print qt_2_vt
        #print new_query_set
        output = []
        for e in new_query_set:
                output.append((query,e,vector))

        # join
        if len(qt)>1:
                for i in range(len(qt)-1):
                        tmp = []
                        for j in range(len(qt)):
                                if j==i:
                                        tmp.append(qt[j]+qt[j+1])
                                elif j>i+1 or j<i:
                                        tmp.append(qt[j])
                        output.append((query,' '.join(tmp),vector))

	# combinations of top vector terms
	#for i in range(len(vt)):
	#	if i<=3:
	#		new_q = ' '.join(vt[:i+1])
	#		if new_q!=query:
	#			output.append((query,new_q,vector))

        return output

def combinations(iterable, r):
    # combinations('ABCD', 2) --> AB AC AD BC BD CD
    # combinations(range(4), 3) --> 012 013 023 123
    pool = tuple(iterable)
    n = len(pool)
    if r > n:
        return
    indices = range(r)
    yield tuple(pool[i] for i in indices)
    while True:
        for i in reversed(range(r)):
            if indices[i] != i + n - r:
                break
        else:
            return
        indices[i] += 1
        for j in range(i+1, r):
            indices[j] = indices[j-1] + 1
        yield tuple(pool[i] for i in indices)

def argmin (*a):
    """Return two arguments: first the smallest value, second its offset"""
    min = sys.maxint; arg = -1; i = 0
    for x in a:
        if (x < min):
            min = x; arg = i
        i += 1
    return (min,arg)

def stredit (s1,s2, showtable=False):
    "String edit distance, keeping trace of best alignment"
    len1 = len(s1) # vertically
    len2 = len(s2) # horizontally
    # Allocate tables
    table = [None]*(len2+1)
    for i in range(len2+1): table[i] = [0]*(len1+1)
    trace = [None]*(len2+1)
    for i in range(len2+1): trace[i] = [None]*(len1+1)
    # initialize table
    for i in range(1, len2+1): table[i][0] = i
    for i in range(1, len1+1): table[0][i] = i
    # in the trace table, 0=subst, 1=insert, 2=delete
    for i in range(1,len2+1): trace[i][0] = 1
    for j in range(1,len1+1): trace[0][j] = 2
    # Do dynamic programming
    for i in range(1,len2+1):
        for j in range(1,len1+1):
            if s1[j-1] == s2[i-1]:
                d = 0
            else:
                d = 1
            # if true, the integer value of the first clause in the "or" is 1
            table[i][j],trace[i][j] = argmin(table[i-1][j-1] + d,
                                             table[i-1][j]+1,
                                             table[i][j-1]+1)
    if showtable:
        # If you are implementing Smith-Waterman, then instead of initializing
        # i=len2 and j=len1, you must initialize i and j to the indices
        # of the table entry that has the miminum value (it will be negative)
        i = len2
        j = len1
        while i != 0 or j != 0:
            if trace[i][j] == 0:
                nexti = i-1
                nextj = j-1
            elif trace[i][j] == 1:
                nexti = i-1
                nextj = j
            elif trace[i][j] == 2:
                nexti = i
                nextj = j-1
            else:
                nexti = 0
                nextj = 0
            trace[i][j] = "*"
            i = nexti
            j = nextj
            print "ij", i, j
        print_table(s1, s2, table, trace)
    return table[len2][len1]
	
@outputSchema("score:chararray")
def get_sports_intent(vector):
	split = vector.split('|')
	score = '0'
	for item in split:
		[type,_score] = item.split(':')
		if type=='s':
			score = _score
	return score

@outputSchema("y:bag{t:tuple(qpop:chararray,dpop:chararray,hpop:chararray,dpop_rate:chararray,hpop_rate:chararray)}")
def pop_features(q,u,qpop,dpop,hpop):
	if qpop==None:
		qpop = -1
	else:
		qpop = int(qpop)
	if dpop==None:
		dpop = -1
	else:
		dpop = int(dpop)
	if hpop==None:
                hpop = -1
        else:
                hpop = int(hpop)	
	if qpop==-1 or dpop==-1:
		dpop_rate = -1
	else:
		dpop_rate = float(dpop)/float(qpop)
	if qpop==-1 or hpop==-1:
                hpop_rate = -1
        else:
                hpop_rate = float(hpop)/float(qpop)
	return [(q,u,str(qpop),str(dpop),str(hpop),str(dpop_rate),str(hpop_rate))]

@outputSchema("n_query:chararray")
def gen_normalized_query(query):
	new_q = query
	try:
		if len(query)>2:
			if query[0]=='"':
				new_q = query[1:]
			if new_q[-1]=='"':
				new_q = new_q[:-1]
			new_q = new_q.replace(',',' ')
			new_q = new_q.replace('  ',' ')
		return new_q
	except:
		return query

@outputSchema("y:bag{t:tuple(vector:chararray,decomposed:chararray)}")
def predict_query_vector(bag):
	lower = 0.01
        upper = 3.5
	top_term_bias = 0.5
	# decompose into units
        t_units = {}
        for [query,t_unit,uv,weight] in bag:
		if uv!='' and uv!=None:
	                t_units[t_unit] = 1
	terms = query.split(' ')
        final_units = []
        terms_covered = {}
        end_pos = -1
        for i in range(len(terms)):
                # find a maximal unit starting from position i
                # which is not a substring of any of previously found maximal units
                for j in range(len(terms)-i):
                        t_unit = ' '.join(terms[i:len(terms)-j])
                        if t_units.has_key(t_unit):
                                if not (t_unit in final_units) and (len(terms)-j>end_pos):
                                        final_units.append(t_unit)
                                        for k in range(len(terms)-j)[i:]:
                                                terms_covered[k] = 1
                                        end_pos = len(terms)-j
                                        break
	# calculate the average weight
        #sum_weight = 0
        #num_units = 0
	#for [query,t_unit,uv,weight] in bag:
	#	if t_unit in final_units:
	#		if weight!='' and float(weight)<upper and float(weight)>lower:
        #                        sum_weight = sum_weight+float(weight)
        #                        num_units = num_units+1
	#if num_units>0:
        #        avg_weight = sum_weight/float(num_units)
        #else:
        #        avg_weight = 1
	default_weight = 1
	# assign average weight for units with missing (or noisy) weights
	unit_vector_weight = {}
	sum_top_term_weight = 0 
	for [query,t_unit,uv,weight] in bag:
                if t_unit in final_units:
                        if (weight!=None and weight!='') and float(weight)<upper and float(weight)>lower:
				unit_vector_weight[t_unit] = [uv,float(weight)]
				_weight = float(weight)
			else:
				unit_vector_weight[t_unit] = [uv,default_weight]
				_weight = default_weight
			top_element = uv.split('|')[0]
			split = top_element.split(':')
			try:
				t_score = float(split[-1])*_weight
			except:
				t_score = 0
			sum_top_term_weight = sum_top_term_weight+t_score
	# add default vector for terms that are not covered by units
	if len(final_units)>0:
		avg_top_term_weight = top_term_bias*sum_top_term_weight/float(len(final_units))
	else:
		avg_top_term_weight = 1
        for i in range(len(terms)):
                if not terms_covered.has_key(i):
                        unit_vector_weight[terms[i]] = [terms[i]+':'+str(avg_top_term_weight),1]
	combined_t_w = {}
	for unit in unit_vector_weight.keys():
		[uv,weight] = unit_vector_weight[unit]
		split = uv.split('|')
		for item in split:
			_split = item.split(':')
			if (not ':' in item):
				_weight = 0
			else:
				try:
					_weight = float(_split[-1])*float(weight)
				except:
			                _weight = 0
			term = ':'.join(_split[:-1])
			if combined_t_w.has_key(term):
				combined_t_w[term] = combined_t_w[term]+_weight
			else:
				combined_t_w[term] = _weight
	list = []
	for term in combined_t_w.keys():
		list.append([term,combined_t_w[term]])
	list.sort(lambda x, y: -cmp(x[1],y[1]))
	tmp = []
	for [term,weight] in list:
		tmp.append(term+':'+str(weight))
	tmp2 = []
	for key in unit_vector_weight.keys():
		tmp2.append('['+key+','+unit_vector_weight[key][0]+','+str(unit_vector_weight[key][1])+']')
	if len(tmp)>0:
		return [(normalize_vector_truncate_20('|'.join(tmp)),','.join(tmp2))]

@outputSchema("y:bag{t:tuple(q1:chararray,q2:chararray)}")
def drop_one_term(query):
	split = query.split(' ')
	list = []
	for i in range(len(split)):
		tmp = []
		for j in range(len(split)):
			if j!=i:
				tmp.append(split[j])
		list.append((query,' '.join(tmp)))
	return list

@outputSchema("vw_training_case:chararray")
def vw_add_weight(vec,weight):
	split = vec.split(' ')
	label = split[0]
	other = ' '.join(split[1:])
	try:
		if weight==1:
			return vec
		else:
			return label+' '+str(weight)+' '+other
	except:
		print >> sys.stderr, 'error'

@outputSchema("y:bag{t:tuple(s1:chararray,s2:chararray)}")
def compare_sim_baseline(qv,bag):
	t_w_qv = {}
        split = qv.split('|')
        for item in split:
                _split = item.split(':')
                term = ':'.join(_split[:-1])
                weight = round(float(_split[-1]),3)
                t_w_qv[term] = weight
	query = ''
	t_w = {}
	for [q,unit,uv] in bag:
		query = q
                try:
                        split = uv.split('|')
                        for item in split:
                                _split = item.split(':')
                                term = ':'.join(_split[:-1])
                                weight = round(float(_split[-1]),3)
				if t_w.has_key(term):
	                                t_w[term] = t_w[term]+weight
				else:
					t_w[term] = weight
                except:
                        print >> sys.stderr, 'error'
	tv = {}
	for term in query.split(' '):
		tv[term] = 1.0
	return [(cosine_sim(t_w_qv,tv),cosine_sim(t_w_qv,t_w))]

@outputSchema("y:bag{t:tuple(s1:chararray,s2:chararray,s3:chararray)}")
def sim_weight(qv,bag1,bag2):
        t_w_qv = {}
        split = qv.split('|')
        for item in split:
                _split = item.split(':')
                term = ':'.join(_split[:-1])
                weight = round(float(_split[-1]),3)
                t_w_qv[term] = weight
	# get unit weights
	unit_weight = {}
	sum = 0
	in_range_count = 0
	#lower = 0.05
        #upper = 2
	lower = 0.01
        upper = 3.5
	query = ''
	for [q,unit,weight] in bag2:
		query = q
		try:
			unit_weight[unit] = float(weight)
			if float(weight)>=lower and float(weight)<=upper:
				sum = sum+float(weight)
				in_range_count = in_range_count+1
		except:
                        print >> sys.stderr, 'error'
	if in_range_count>0:
		avg_weight = float(sum)/float(in_range_count)
	else:
		avg_weight = 1.0
	# override weight for missing values (assign avg)
	for [q,unit,weight] in bag2:
		try:
			if float(weight)>upper or float(weight)<lower:
				unit_weight[unit] = avg_weight
		except:
                        print >> sys.stderr, 'error'
	t_w = {}
	t_w_baseline = {}
        for [q,unit,uv] in bag1:
                try:
                        split = uv.split('|')
                        for item in split:
                                _split = item.split(':')
                                term = ':'.join(_split[:-1])
	                        weight = round(float(_split[-1]),3)*unit_weight[unit]
                                if t_w.has_key(term):
                                        t_w[term] = t_w[term]+weight
					t_w_baseline[term] = t_w_baseline[term]+round(float(_split[-1]),3)
                                else:
                                        t_w[term] = weight
					t_w_baseline[term] = round(float(_split[-1]),3)
                except:
                        print >> sys.stderr, 'error'
	tv = {}
        for term in query.split(' '):
                tv[term] = 1.0
	return [(cosine_sim(t_w_qv,tv),cosine_sim(t_w_qv,t_w_baseline),cosine_sim(t_w_qv,t_w))]

@outputSchema("y:bag{t:tuple(vw_training_case:chararray)}")
def gen_vw_case(qv,bag):
	w_threshold = 0.1 # removes equations with 0 as target when the weights are small

	set_unit_t_w = []
	union_terms = {}
	all_t_w = {}
	for [q,unit,uv] in bag:
		try:
			t_w = {}
			split = uv.split('|')
			for item in split:
				_split = item.split(':')
	        	        term = ':'.join(_split[:-1])
        	        	weight = round(float(_split[-1]),3)
				t_w[term] = str(weight)
				if all_t_w.has_key(term):
					all_t_w[term] = all_t_w[term]+weight
				else:
					all_t_w[term] = weight
				union_terms[term] = 1
				if len(t_w.keys())==4: break
			set_unit_t_w.append([unit,t_w])
		except:
			print >> sys.stderr, 'error'
	sum_weight = 0
	for key in all_t_w.keys():
		sum_weight = sum_weight+all_t_w[key]**2
	norm = sum_weight**0.5

	# multiply norm (calculated above to approximate similarity)
        t_w_qv = {}
        split = qv.split('|')
        for item in split:
                _split = item.split(':')
                term = ':'.join(_split[:-1])
                #weight = round(float(_split[-1]),3)
                weight = round(float(_split[-1])*norm,3)
                t_w_qv[term] = str(weight)

	output_line = []
	# each term corresponds to one equation
	for term in union_terms.keys():
		line = []
		max_weight = -1
		for [unit,t_w] in set_unit_t_w:
			if t_w.has_key(term):
				weight = t_w[term]
				try:
					if float(weight)>max_weight:
						max_weight = float(weight)
					unit_normalized = unit.replace(' ','#')
					unit_normalized = unit_normalized.replace(':','#COLON#')
					unit_normalized = unit_normalized.replace('|','#PIPE#')
					line.append(unit_normalized+':'+weight)
				except:
					print >> sys.stderr, term
		if t_w_qv.has_key(term):
			if float(t_w_qv[term])>w_threshold:
				output_line.append(t_w_qv[term]+' |features '+' '.join(line))
			else:
				if max_weight>w_threshold:
					output_line.append(t_w_qv[term]+' |features '+' '.join(line))
		else:
			if max_weight>w_threshold:
				output_line.append('0 |features '+' '.join(line))
	if len(output_line)>0:
		return output_line

@outputSchema("v:chararray")
def truncate_and_apply_norm(v,norm_):
	norm = float(norm_)
	k = 20
	split = v.split('|')
	tmp = []
	for item in split:
		if len(tmp)==20: break
		_split = item.split(':')
		a = ':'.join(_split[:-1])
		b = str(float(_split[-1])*norm)
		tmp.append(a+':'+b)
	return '|'.join(tmp)

@outputSchema("y:bag{t:tuple(a:chararray,b:chararray)}")
def online_sampling(bag,k_):
        k = float(k_)
        i = 0
        selected = []
        for item in bag:
                if i<k:
                        selected.append(item)
                else:
                        if random.random()<k/float(i):
                                j = int(random.random()*k)
                                selected[j] = item
                i = i+1
        return selected

@outputSchema("idf:chararray")
def idf(N,n):
	return math.log(float(N)/float(n))

@outputSchema("y:bag{t:tuple(query:chararray,doc:chararray,clicks:chararray)}")
def gen_pseudo_click_graph(id,doc_title):
	outBag = []
	title = doc_title.lower()
        title = title.replace(':',' ')
	split = title.split(' ')
	terms = {}
	for term in split:
		if not terms.has_key(term):
			outBag.append((term,id,1))
		terms[term] = 1
	return outBag

@outputSchema("y:bag{t:tuple(unit:chararray)}")
def gen_unigrams(query):
        outBag = []
        split = query.split(' ')
        # unigrams
        for item in split:
		if item.strip()!='':
	                outBag.append(item)
	return outBag

@outputSchema("y:bag{t:tuple(unit:chararray)}")
def gen_bigrams(query):
        outBag = []
        split = query.split(' ')
	# bigrams
        for i in range(len(split)):
                if i<len(split)-1:
                        outBag.append(' '.join(split[i:i+2]))
        return outBag

@outputSchema("y:bag{t:tuple(unit:chararray)}")
def gen_ngrams(query,n):
        outBag = []
        split = query.strip().split(' ')
        for i in range(len(split)):
                if i<len(split)-n+1:
			if ' '.join(split[i:i+n]).strip()!='':
	                        outBag.append(' '.join(split[i:i+n]))
	if len(outBag)>0:
	        return outBag

@outputSchema("url:chararray")
def add_start_end_tags(query):
	return '<s>'+query+'<e>'

@outputSchema("y:bag{t:tuple(unit:chararray)}")
def gen_units(query):
        outBag = []
        split = query.split(' ')
	# unigrams
        for item in split:
                outBag.append(item)
	# bigrams
	for i in range(len(split)):
		if i<len(split)-1:
			outBag.append(' '.join(split[i:i+2]))
	#q1 = '<s>'+query
	#split = q1.split(' ')
	#for i in range(len(split)):
	#	outBag.append(' '.join(split[:i+1]))
	#q2 = query+'<e>'
	#split= q2.split(' ')
	#for i in range(len(split)):
        #        outBag.append(' '.join(split[i:]))
        return outBag

@outputSchema("y:bag{t:tuple(unit:chararray)}")
def gen_all_units(query):
    outBag = []
    try:
        split = query.split(' ')
	while '' in split:
		split.remove('')
        # unigrams
        for item in split:
                outBag.append(item)
        # 2~5 grams
	for n in [2,3,4,5]:
	        for i in range(len(split)):
        		if i<len(split)-n+1:
                        	outBag.append(' '.join(split[i:i+n]))
	if len(split)<10 and len(outBag)>0:
	        return outBag
    except: return outBag

@outputSchema("y:bag{t:tuple(unit:chararray)}")
def gen_all_units_title(query):
        outBag = []
        split = query.split(' ')
        while '' in split:
                split.remove('')
        # unigrams
        for item in split:
                outBag.append(item)
        # 2~5 grams
        for n in [2,3,4,5]:
                for i in range(len(split)):
                        if i<len(split)-n+1:
                                outBag.append(' '.join(split[i:i+n]))
        if len(split)<15 and len(outBag)>0:
                return outBag

@outputSchema("y:bag{t:tuple(unit:chararray)}")
def gen_all_units_old(query):
        outBag = []
        split = query.split(' ')
        # unigrams
        for item in split:
                outBag.append(item)
        # bigrams
        for i in range(len(split)):
                if i<len(split)-1:
                        outBag.append(' '.join(split[i:i+2]))
	terms = query.split(' ')
	for i in range(len(terms)):
		for j in range(len(terms)-i):
			outBag.append('<s>'+' '.join(terms[i:len(terms)-j])+'<e>')
	return outBag

@outputSchema("y:bag{t:tuple(unit:chararray,weight:chararray)}")
def gen_term_w(vector):
	outBag = []
	split = vector.split('|')
	for item in split:
		_split = item.split(':')
		unit = ':'.join(_split[:-1])
		weight = _split[-1]
		outBag.append((unit,weight))
	return outBag

@outputSchema("vector:chararray")
def unit_decompose(bag):
        tmp = []
        t_units = {}
        query = ''
        for tuple in bag:
                query = tuple[0]
                t_unit = tuple[1]
                t_units[t_unit] = 1
        terms = query.split(' ')
        final_units = []
        terms_covered = {}
        end_pos = -1
        for i in range(len(terms)):
                # find a maximal unit starting from position i
                # which is not a substring of any of previously found maximal units
                for j in range(len(terms)-i):
                        t_unit = ' '.join(terms[i:len(terms)-j])
                        if t_units.has_key(t_unit):
                                if not (t_unit in final_units) and (len(terms)-j>end_pos):
                                        final_units.append(t_unit)
                                        for k in range(len(terms)-j)[i:]:
                                                terms_covered[k] = 1
                                        end_pos = len(terms)-j
                                        break
        all_term_covered = True
        for i in range(len(terms)):
                if not terms_covered.has_key(i):
                        all_term_covered = False
        if all_term_covered and (not t_units.has_key(query)):
                return '|'.join(final_units)

@outputSchema("vector:chararray")
def unit_decompose_old(bag):
        tmp = []
	t_units = {}
	query = ''
        for tuple in bag:
		query = tuple[0]
		t_unit = tuple[1]
		t_units[t_unit] = 1
	terms = query.split(' ')
	final_units_tag = []
	final_units_no_tag = {}
	terms_covered = {}
	end_pos = -1
	for i in range(len(terms)):
		# find a maximal unit starting from position i
		# which is not a substring of any of previously found maximal units
		for j in range(len(terms)-i):
			t_unit_no_tag = ' '.join(terms[i:len(terms)-j])
			t_unit_tag = '<s>'+' '.join(terms[i:len(terms)-j])+'<e>'
			if t_units.has_key(t_unit_tag):
				if not final_units_no_tag.has_key(t_unit_no_tag) and (len(terms)-j>end_pos):
					final_units_tag.append(t_unit_tag)
					final_units_no_tag[t_unit_no_tag] = 1
					for k in range(len(terms)-j)[i:]:
						terms_covered[k] = 1
					end_pos = len(terms)-j
					break
			elif t_units.has_key(t_unit_no_tag):
				if not final_units_no_tag.has_key(t_unit_no_tag) and (len(terms)-j>end_pos):
                                        final_units_tag.append(t_unit_no_tag)
                                        final_units_no_tag[t_unit_no_tag] = 1
					for k in range(len(terms)-j)[i:]:
                                                terms_covered[k] = 1
					end_pos = len(terms)-j
					break
	all_term_covered = True
	for i in range(len(terms)):
		if not terms_covered.has_key(i):
			all_term_covered = False
	if all_term_covered and (not t_units.has_key('<s>'+query+'<e>')):
		return '|'.join(final_units_tag)

@outputSchema("vector:chararray")
def gen_avg(bag):
	tmp = []
	for tuple in bag:
		unit = tuple[0]
		term = tuple[1]
		weight = tuple[2]
		tmp.append(term+':'+str(weight))
	return normalize_vector_truncate_20('|'.join(tmp))

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

@outputSchema("md5:chararray")
def md5(word):
  m = hashlib.md5()
  m.update(word.encode('utf-8'))
  return m.hexdigest()

@outputSchema("md5_16:chararray")
def md5_16(word):
  return (hex(((int(md5(word)[28:],16) % 0xffff) + 1))[2:]).rjust(4,'0')

@outputSchema("quantized:chararray")
def quantize(score):
  table = [float(i)/10000 for i in range(0,9984,39)]
  return str(bisect.bisect(table, score) - 1)

@outputSchema("vector:chararray")
def hash_quantize(vector):
	if vector==None: return ''
	split = vector.split('|')
	tmp = []
	for item in split:
		_split = item.split(':')
		term = ':'.join(_split[:-1])
		score = float(_split[-1])
		hashed = md5_16(term)
		quantized = quantize(score)
		tmp.append(hashed+':'+quantized)
	return '|'.join(tmp)

@outputSchema("q_hash:chararray")
def syn_hash(query):
	cons = ['b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','z']
	# first three
	tmp = []
	for char in query:
		if char in cons:
			tmp.append(char)
		if len(tmp)==4: break
	return ''.join(tmp)

@outputSchema("url:chararray")
def add_http_etc(url):
	tmp_url = url
	tmp_url = tmp_url.replace('https://','')
	tmp_url = tmp_url.replace('http://','')
	split = tmp_url.split('/')
	if len(split)==1:
		url = url+'/'
	if len(url)>=8 and url[:8]=='https://':
		new_url = url
	elif len(url)>=7 and url[:7]=='http://':
		new_url = url
	else:
		new_url = 'http://'+url
	return new_url

@outputSchema("y:bag{t:tuple(url1:chararray)}")
def get_terms_from_vector(vector):
	outBag = []
	split = vector.split('|')
	for item in split:
		_split = item.split(':')
		term = ':'.join(_split[:-1])
		outBag.append(term)
	return outBag

@outputSchema("y:bag{t:tuple(url1:chararray,score:chararray)}")
def get_terms_from_vector_k(vector,k):
        outBag = []
        split = vector.split('|')
        for item in split:
                _split = item.split(':')
                term = ':'.join(_split[:-1])
		score = _split[-1]
                outBag.append((term,score))
		if len(outBag)==k: break
        return outBag

@outputSchema("md5:chararray")
def get_md5_as_bytes(data):
#	m = hashlib.md5()
#	m.update(data.encode('utf-8'))
#	return m.hexdigest()[:16].upper()
	if len(data)>=2 and data[-2:]=='#!':
		data = data[:-2] 
        hash = os.popen('echo %s | ./normalizeMD5' % data).read()[:-1]
        return str(hex(1+(int('0x'+hash[-16:],16) % 0xffffffff)))[2:]

@outputSchema("md5:chararray")
def get_md5_as_bytes_url(data):
	if len(data)>=8 and data[:8]=='https://':
		url = data
	else:
		url = 'http://'+data
        m = hashlib.md5()
        m.update(url.encode('utf-8'))
        return m.hexdigest()[:16].upper()

@outputSchema("f1:chararray")
def concat(s1,s2):
	s = s1+' '+s2
        return s.replace('_',' ') 

@outputSchema("f1:chararray")
def concat_two(s1,s2):
        return s1.tostring()+' w#'+s2.tostring()

@outputSchema("f1:chararray")
def concat_woeid(s1,s2):
        return s1+' w#'+s2

@outputSchema("y:bag{t:tuple(url1:chararray,url2:chararray,c1:int,c2:int)}")
def gen_pairs(bag):
	outBag = []
	top_clicks = -1
	for i in range(len(bag)):
		[q,woeid,url1,clicks1] = bag[i]
		if int(clicks1)>top_clicks:
			top_clicks = int(clicks1)
		for j in range(len(bag)):
			if i>=j: continue
			[q,woeid,url2,clicks2] = bag[j]
			if url1==None or url2==None: continue
			if int(clicks2)>top_clicks:
	                        top_clicks = int(clicks2)
			if clicks1-clicks2>=3 and not ('r.ypcdn.com' in url1) and not ('r.ypcdn.com' in url2):
				tup=(url1,url2,clicks1,clicks2)
				outBag.append(tup)
			elif clicks2-clicks1>=3 and not ('r.ypcdn.com' in url1) and not ('r.ypcdn.com' in url2):
				tup=(url2,url1,clicks2,clicks1)
                                outBag.append(tup)
	if top_clicks>=8 and len(woeid)==7:
		return outBag

@outputSchema("qry:chararray,score:chararray")
def strong_local(qry,vec):
	split = vec.split('|')
	for item in split:
		[cls,score] = item.split(':')
		if cls=='l' and float(score)>0.55:
			return qry,score

@outputSchema("host:chararray")
def get_host(url):
        host = url.split('/')[0]
	return host

@outputSchema("url1:chararray,url2:chararray")
def getLocalUrl(u1,u2):
	host = u1.split('/')[0]
	if u1==u2:
		return u1,'l:1.0','1.0'
	elif '.tripadvisor.com' in u1 or '.zagat.com' in u1 or '.yelp.com' in u1 or '.foursquare.com' in u1 or '.urbanspoon.com' in u1 or '.opentable.com' in u1:
		return u1,'l:1.0','1.0'
	else:
		return u1,'n:1.0','1.0'

@outputSchema("f1:chararray")
def process_url(url):
	tmp = url.split('url')
	if len(tmp)>2:
		new_url = tmp[1].replace('>http://','').replace('>','').replace('</','')
		if '/' in new_url:
			host = new_url.split('/')[0]
			if len(host.split('.'))==2:
				new_url = 'www.'+new_url
		else:
			host = new_url
			if len(host.split('.'))==2:
                                new_url = 'www.'+new_url
			new_url = new_url+'/'	
        	return new_url

@outputSchema("y:bag{t:tuple(f1:chararray,f2:chararray)}")
def filter_url_docloc(url,vec):
	outBag = []
	if url!='' and vec!='':
		_url = url.replace('http://','').replace('https://','')
		split = _url.split('/')
		host = split[0]
		if len(split)==1 and ('yahoo.com' in host or 'google.com' in host):
			return
		if 'craigslist' in host:
			if len(split)==1 and not ('mobile.craigslist.org' in host) and not ('accounts.craigslist.org' in host) and not ('.es.' in host):
				tup=(url,vec)
                                outBag.append(tup)
				return outBag
		elif not ('maps.yahoo.com' in host) and not ('search.yahoo.com' in host) and not ('wikipedia.org' in host):
			tup=(url,vec)
                        outBag.append(tup)
			return outBag

@outputSchema("f1:chararray")
def query_normalize(query):
        q = query.lower()
        for char in set(string.punctuation):
                if char=="'": continue
                if char=='#': continue
                q = q.replace(char,' ')
        split = q.split(' ')
        tmp = []
        for _term in split:
                term = _term.strip()
                if term!='':
                        tmp.append(term)
        return ' '.join(tmp)

@outputSchema("f1:chararray")
def norm_url(url):
	new_url = url.replace('http://','')
        return new_url.lower()

@outputSchema("url:chararray")
def url_normalize(tmp_url):
        url = tmp_url
	if url==None: return ''
        if '://' in url:
                url = url.split('://')[1]
        host = url.split('/')[0]
        host_split = host.split('.')
        if len(host_split)==2:
                url = 'www.'+url
        if len(url)>=2 and url[-1]=='/':
                url = url[:-1]
        return url

@outputSchema("url:chararray")
def url_normalize_lower(tmp_url):
        url = tmp_url
        if url==None: return ''
        if '://' in url:
                url = url.split('://')[1]
        host = url.split('/')[0]
        host_split = host.split('.')
        if len(host_split)==2:
                url = 'www.'+url
        if len(url)>=2 and url[-1]=='/':
                url = url[:-1]
        return url.lower()

@outputSchema("url:chararray")
def url_normalize_local(tmp_url):
        url = tmp_url
        if url==None: return ''
        if '://' in url:
                url = url.split('://')[1]
        host = url.split('/')[0]
        host_split = host.split('.')
        if len(host_split)==2:
                url = 'www.'+url
        if len(url)>=2 and url[-1]=='/':
                url = url[:-1]
	if url=='www.disneyland.com': return 'disneyland.disney.go.com'
        return url

@outputSchema("url:chararray")
def url_normalize_local_lower(tmp_url):
        url = tmp_url
        if url==None: return ''
        if '://' in url:
                url = url.split('://')[1]
        host = url.split('/')[0]
        host_split = host.split('.')
        if len(host_split)==2:
                url = 'www.'+url
        if len(url)>=2 and url[-1]=='/':
                url = url[:-1]
        if url=='www.disneyland.com': return 'disneyland.disney.go.com'
        return url.lower()

@outputSchema("f1:int")
def num_terms(s):
	split = s.split(' ')
	return len(split)

@outputSchema("f1:int")
def len_str(s):
	return len(s)

@outputSchema("f1:double")
def cosine_sim(v1,v2):
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
        if (v1_sum**0.5)*(v2_sum**0.5)==0:
                return 0
        else:
                return float(dot_p)/((v1_sum**0.5)*(v2_sum**0.5))

@outputSchema("f1:chararray")
def get_vector(v):
        _v = {}
        split = v.split('|')
        for item in split:
                _split = item.split(':')
                term = ':'.join(_split[:-1])
                weight = _split[-1]
                _v[term] = float(weight)
        return _v

@outputSchema("sim:double")
def similarity(v1,v2):
	if v1!='' and v2!='' and v1!=None and v2!=None:
		return cosine_sim(get_vector(v1),get_vector(v2))
	else:
		return -1

def similarity_highorder(v1,v2,k):
        if v1!='' and v2!='' and v1!=None and v2!=None:
		sum = cosine_sim(get_vector(v1),get_vector(v2))
		for i in range(k)[1:]:
			sum = sum+cosine_sim(vector_expansion(v1,i+1),vector_expansion(v2,i+1))
                return (1/float(k))*sum
        else:
                return -1

def similarity_highorder_noavg(v1,v2,k):
        if v1!='' and v2!='' and v1!=None and v2!=None:
                return cosine_sim(vector_expansion(v1,k),vector_expansion(v2,k))
        else:
                return -1

def vector_expansion(vector,i):
	top_n = 20
	split = vector.split('|')
	comb = list(combinations(split,i))
	expanded = []
	for e in comb:
		val = 1
		new_term = []
		for item in e:
			_split = item.split(':')
			term = ':'.join(_split[:-1])
			_val = float(_split[-1])
			val = val*_val
			new_term.append(term)
		new_term.sort()
		expanded.append(['#'.join(new_term),val])
	expanded_sorted = sorted(expanded, key=operator.itemgetter(1), reverse=True)
	expanded_truncated = {}
	for i in range(len(expanded_sorted)):
		if i<top_n:
			expanded_truncated[expanded_sorted[i][0]] = expanded_sorted[i][1]
	return expanded_truncated 

def remove_term(v,_term):
	_v = {}
        split = v.split('|')
        for item in split:
                _split = item.split(':')
                term = ':'.join(_split[:-1])
		if term!=_term:
	                weight = _split[-1]
        	        _v[term] = float(weight)
        return _v

@outputSchema("sim:double")
def similarity_without_oneterm(v1,v2,term):
	_v1 = remove_term(v1,term)
	_v2 = remove_term(v2,term)
        if len(_v1.keys())>0 and len(_v2.keys())>0:
                return cosine_sim(_v1,_v2)
        else:
                return 0

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
        return ['|'.join(tmp),str(norm)]

@outputSchema("f1:chararray,f2:chararray")
def extract_cat(v):
	split = v.split('|')
	tmp = []
	for item in split:
		_split = item.split(':')
                cat = ':'.join(_split[:-1])
                val = _split[-1]
		if len(cat)>2 and cat[:2]=='c#':
			tmp.append(cat.replace('c#','')+':'+val)
	if len(tmp)>0:
		normalized = normalize_vector('|'.join(tmp))
		if normalized[0]!='':
			return normalized[0],normalized[1]

@outputSchema("f1:chararray,f2:chararray")
def extract_cat_top_k(v,k):
	top_k = int(k)
        split = v.split('|')
        tmp = []
	i = 0
	top_val = -1
        for item in split:
		if i>=top_k: break
                _split = item.split(':')
                cat = ':'.join(_split[:-1])
                val = _split[-1]
		i = i+1
                if len(cat)>3 and cat[:3]=='!c!':
                        tmp.append(cat.replace('!c!','').replace('#',' ')+':'+val)
			if float(val)>top_val:
				top_val = float(val)
        if len(tmp)>0 and top_val>0.15:
                normalized = normalize_vector('|'.join(tmp))
                return normalized[0],normalized[1]
