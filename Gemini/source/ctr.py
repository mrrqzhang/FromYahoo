import sys
from collections import defaultdict

click=defaultdict()
view=defaultdict()
for line in sys.stdin:
    try:
       q,v,c = line.strip('\r\t\n ').split('\t')
    except: continue
    click[q]=int(c) if q not in click else click[q]+int(c)
    view[q]=int(v) if q not in view else view[q]+int(v)

for key in view.keys():
    print (key,"\t",click[key],"\t",view[key], "\t", float(click[key])/(view[key]))
