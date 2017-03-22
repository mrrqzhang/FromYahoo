import sys,os

def url_normalize(tmp_url):
        url = tmp_url
        if '://' in url:
                url = url.split('://')[1]
        host = url.split('/')[0]
        host_split = host.split('.')
        if len(host_split)==2:
                url = 'www.'+url
        if len(url)>=2 and url[-1]=='/':
                url = url[:-1]
        return url

input = open(sys.argv[1],'r')
output = open(sys.argv[2],'w')

for line in input:
	[_q,u] = line[:-1].split('\t')
	q = _q.replace('"','')
	q = q.replace("'",'')
	q = q.replace('+','')
	output.write(q.lower()+'\t'+u+'\t'+url_normalize(u)+'\n')	
