import os,sys,string,re
from HTMLParser import HTMLParser

class MLStripper(HTMLParser):
    def __init__(self):
        self.reset()
        self.fed = []
    def handle_data(self, d):
        self.fed.append(d)
    def get_data(self):
        return ''.join(self.fed)

def strip_tags(html):
    s = MLStripper()
    t = s.unescape(html.lower())
    cleanr =re.compile('<.*?>')
    return re.sub(cleanr,'',t)

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

stop = {}

stop_file = open(sys.argv[1],'r')
for line in stop_file:
	stop[line[:-1]] = 1

while True:
        line = sys.stdin.readline()
        if not line: break
	[url,_title] = line[:-1].split('\t')
	if not is_ascii(_title): continue
	title = strip_tags(_title)
	for char in set(string.punctuation):
		if char=="'": continue
		title = title.replace(char,' ')
	terms = title.split(' ')
	tmp = []
	for _term in terms:
		term = _term.strip()
		if (not stop.has_key(term)) and term!='':
			tmp.append(term)
	print url+'\t'+'|'.join(tmp)
