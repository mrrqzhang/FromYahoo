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

while True:
        line = sys.stdin.readline()
        if not line: break
        split = line[:-1].split('\t')
	print url_normalize(split[0])
