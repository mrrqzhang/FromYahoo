#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re,math,sys,random
try: import simplejson as json
except ImportError: import json

# sample input
"""
{"srcpvid":"56XvvDE4My5RpFDEU1S3qhDbMjIwLlNhmbX_rKl4","clicks":[{"ql_url":"hanja.naver.com/yp/busu","dpos":"4","device_type":"Desktop","bcookie":"5392goh9l9dta","srcpvid":"56XvvDE4My5RpFDEU1S3qhDbMjIwLlNhmbX_rKl4","timestamp":"1398905299","sec":"sr","pos":"1","ql_txt":"부수로 찾기"}],"views":[{"viewbag":[{"viewinfo":{"slk":"aa_link","gpos":"1","title":"Naver Hanja Dictionary","rscr":"28.39368","it":"aa_nav","dpos":"1","targurl":"hanja.naver.com/category/idiom","sec":"sr","ql_txt":"고사성어 숙어","parent_url":"hanja.naver.com/","pos":"1","parent_title":"Naver Hanja Dictionary"}},{"viewinfo":{"slk":"aa_link","gpos":"1","title":"Naver Hanja Dictionary","rscr":"28.39368","it":"aa_nav","dpos":"2","targurl":"hanja.naver.com/category/yitizi","sec":"sr","ql_txt":"이형동의자","parent_url":"hanja.naver.com/","pos":"1","parent_title":"Naver Hanja Dictionary"}},{"viewinfo":{"slk":"aa_link","gpos":"1","title":"Naver Hanja Dictionary","rscr":"28.39368","it":"aa_nav","dpos":"3","targurl":"hanja.naver.com/category/misuse","sec":"sr","ql_txt":"틀리기 쉬운 <b>한자</b>","parent_url":"hanja.naver.com/","pos":"1","parent_title":"Naver Hanja Dictionary"}},{"viewinfo":{"slk":"aa_link","gpos":"1","title":"Naver Hanja Dictionary","rscr":"28.39368","it":"aa_nav","dpos":"4","targurl":"hanja.naver.com/yp/busu","sec":"sr","ql_txt":"부수로 찾기","parent_url":"hanja.naver.com/","pos":"1","parent_title":"Naver Hanja Dictionary"}},{"viewinfo":{"slk":"aa_link","gpos":"1","title":"Naver Hanja Dictionary","rscr":"28.39368","it":"aa_nav","dpos":"5","targurl":"hanja.naver.com/category/address","sec":"sr","ql_txt":"한자주소","parent_url":"hanja.naver.com/","pos":"1","parent_title":"Naver Hanja Dictionary"}},{"viewinfo":{"slk":"aa_link","gpos":"1","title":"Naver Hanja Dictionary","rscr":"28.39368","it":"aa_nav","dpos":"6","targurl":"hanja.naver.com/category/surname","sec":"sr","ql_txt":"한자성씨","parent_url":"hanja.naver.com/","pos":"1","parent_title":"Naver Hanja Dictionary"}}],"device_type":"Desktop","bcookie":"5392goh9l9dta","srcpvid":"56XvvDE4My5RpFDEU1S3qhDbMjIwLlNhmbX_rKl4","timestamp":"1398905270"}]}
"""
for line in sys.stdin:
    tmp = json.loads(line.strip('\r\t\n '))
    clickinfo = tmp[u'clicks']
    views = tmp[u'views'][0]
    viewbag = views[u'viewbag']
    domain_url = ""
    if viewbag[0][u'viewinfo']['parent_url'] is not None:
	 domain_url = viewbag[0][u'viewinfo'][u'parent_url']
    domain_title = ""
    if viewbag[0][u'viewinfo']['parent_title'] is not None:
    	domain_title = viewbag[0][u'viewinfo'][u'parent_title']
    srcpvid = tmp['srcpvid']
    for c in clickinfo:
#	outstring = u'\t'.join([domain_url, c[u'ql_url'], domain_title, c[u'ql_txt'],c[u'timestamp']]).encode('utf-8')
        print '\t'.join([srcpvid, c['timestamp'], domain_url, domain_title, c['ql_url'], c['ql_txt'], c['dpos'],"click"]).encode('utf-8')
    for v in viewbag:
        vi = v['viewinfo']
        print '\t'.join([srcpvid,views['timestamp'],domain_url, domain_title, vi['targurl'], vi['ql_txt'],  vi['dpos'],"view"]).encode('utf-8')
