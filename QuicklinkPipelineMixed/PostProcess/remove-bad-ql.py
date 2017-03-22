import sys,logging
from collections import defaultdict

BadQL = ['Probably not likely','Definitely not likely','NJ']
BadTitle = ['Fair','Bad','NJ']

#edit_file: domain, url,  m._ql_title     a.linkquality   a.linklowquality        a.titlequality  a.titlerewritten        a.qlreplacements
edit_file = sys.argv[1]
etable = defaultdict(dict)


def LinkQuality (et,domain,url):
    ret = 'ok'
    if domain in et and url in et[domain]:
	if len(et[domain][url])>=2: ret =  et[domain][url][1]
    return ret

# return ''
def GetGoodTitle (et,domain,url,title):
    ret = title
    if domain in et and url in et[domain]:
	if len(et[domain][url])>=4 and title==et[domain][url][0] and  et[domain][url][3] in BadTitle: ret = ''
        if ret == '' and len(et[domain][url])>=5 and et[domain][url][4]!='': ret = et[domain][url][4]
    return ret
    


with open(edit_file) as f:
     for line in f.readlines():
        fields = line.strip('\r\t\n ').split('\t')
	etable[fields[0]][fields[1]] = fields[2:]

for line in sys.stdin:
    domain,url,title,score = line.strip('\r\t\n ').split('\t')
    if LinkQuality(etable,domain,url) in BadQL: 
	logging.warning('removed worse unlikely ql: %s' % line.strip('\r\t\n '))
	continue
    title = GetGoodTitle(etable,domain,url,title)
    if title != '' :
         sys.stdout.write('%s\t%s\t%s\t%s\n' % (domain,url,title,score))
    else:
         logging.warning('removed worse title ql: %s' % line.strip('\r\t\n ')) 
