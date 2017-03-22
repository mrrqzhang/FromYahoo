import sys,re,string

TOPN=5

sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))

#from mypythonlib import has_punct

#stopwords = set(['a','an','and','are','is','at','be','by','for','from','has','he','in',
#                             'is','it','its','of','on','that','the','to','was','were','will','with'])

stopwords = set(['i','a','about','an','are','as','at','be','by','com','for','from','how','in','is','it','of','on','or','that','the','this','to','was','what','when','where','who','will','with','the','www'])


def has_punct(wordstr):
     regex = re.compile(r'([%s])' % re.escape(string.punctuation))
     return regex.search(wordstr) is not None


def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        pass
 
    try:
        import unicodedata
        unicodedata.numeric(s)
        return True
    except (TypeError, ValueError):
        pass
    return False

pre_q=''
arr=[]
for line in sys.stdin:
    fields = line.strip('\r\t\n ').split('\t')
    q = fields[0]
    r = fields[1]
    if has_punct(q) or has_punct(r): continue
    if q in stopwords or r in stopwords: continue 
    if is_number(q) or is_number(r): continue
    if any(c.isalpha() for c in q) is not True or any(c.isalpha() for c in r) is not True: continue
    if len(q.split()) >=4 : continue
    if q != pre_q:
         output = sorted(arr, key=lambda x:x[2], reverse=True)[0:TOPN]
	 for item in output:
             sys.stdout.write('%s\n' % '\t'.join(item))
	 arr=[fields]
         pre_q=q
         continue
    arr.append(fields)






