#!/usr/bin/env python2.7
#usage ./RBO.py yst-list 
#this script at first read yst list and then get google results from desktop_east_google.tsv
# input has to be sorted based on ranking score



import sys,math,re,os
mylibdir =os.path.expanduser('~/mylib')
yst={}

def get_yst_result(query):
    list={}
    count=1
    while count < 10:
        if not yst[query].has_key(count):continue
        list[count] = {'url':yst[query][count]['url'],'norm':get_normalized_url(yst[query][count])}
        count = count +1
    return list


def get_normalized_url(url):
    url = re.sub('\s+','',url)
    url = re.sub('^https?://','',url)
    url = re.sub('^www[0-9]?[.]', '', url)
    url = re.sub('^([^/]+)/(home|html|web)/(index|home|default).(ognc|aspx|html|htm|jsp|gsp|tmpl)$','\\1',url)
    url = re.sub('^([^/]+)/(index|home|default).(ognc|aspx|html|htm|jsp|gsp|tmpl)$' ,'\\1', url)
    url = re.sub('/$','',url)
    return url

if __name__ == '__main__':
#read yst result list
#example:70065  1 bedroom apartment for rent    http://www.apartments.com/one-bedroom-apartments    0   2.0816727918

    pos=0
    for line in open(sys.argv[1],'r'):
        query,url=line.split('\t')[0:2]
        pos = int(pos) + 1
        if not yst.has_key(query):
                yst[query]={}
		pos=1
        yst[query][pos]={}
        yst[query][pos]['url']=url
        yst[query][pos]['norm']=get_normalized_url(url)


# read google results
#http://www.057info.hr/  057 info        http://www.057info.hr/vijesti/  0

    gst = {}
    pos=0
    for line in open(sys.argv[2],'r'):
        query,url=line.split('\t')[0:2]
        if not yst.has_key(query):continue
        pos = int(pos)+1
        if not gst.has_key(query):
            gst[query]={}
            pos=1
        gst[query][pos]={}
        gst[query][pos]['url']=url
        gst[query][pos]['norm']=get_normalized_url(url)
    total_rbo=0
    for query in gst.keys():
        #yst[query]=get_yst_result(query)
        sum=0
        sum2=0
        total=0.0
        A={}
        length = max(len(yst[query].keys()),len(gst[query].keys()))   #bug fix 
        for depth in range(1,length+1):
            A[depth]=0
            for i in range(1,depth+1):
                for j in range(1,depth+1):
                    if not yst[query].has_key(i) or not gst[query].has_key(j):continue
                    if yst[query][i]['norm'] == gst[query][j]['norm'] or yst[query][i]['url'] == gst[query][j]['url']   or yst[query][i]['norm'] == gst[query][j]['url'] or yst[query][i]['url'] == gst[query][j]['norm']:
                        A[depth]=1+A[depth]
       #                 break
            sum = sum + math.pow(0.8,depth-1)*A[depth]/depth
            sum2 = sum2 + math.pow(0.8,depth-1)
	#    print query,  sum,sum2,A[depth]
#        print "%s\tRBO@5\t%f" % (query,sum/sum2)
        total_rbo = total_rbo + sum/sum2
    print "%f" % (total_rbo/len(gst.keys()))

