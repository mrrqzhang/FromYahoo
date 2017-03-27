import codecs
import os,sys
import math
import re
from string import *

preurl=""
start=0
ql=[]
ql_click=[]
total=0
click=0
maxclick=0
for line in sys.stdin:
  fields = line.strip().split("\t")
  url = fields[0]
  click=0
  if float(fields[3])!=0 : click = math.log(float(fields[3]),2)
  start += 1
#  print total, url, preurl
  if start==1:
     ql.append(line)
     ql_click.append(click)
     preurl = url
     total = click
     maxclick = click
     continue
  if url != preurl:
     if total==0: total=1
     if maxclick==0: maxclick=1
     for i in range(0, len(ql)):
      sys.stdout.write("%s\t%g\n" % (ql[i].strip(),ql_click[i]/maxclick))
     ql=[]
     ql_click=[]
     preurl=url
     ql.append(line)
     ql_click.append(click)
     total=click
     maxclick=click
  else:
     ql.append(line)
     ql_click.append(click)
     total += click
     if(maxclick<click) : maxclick=click

