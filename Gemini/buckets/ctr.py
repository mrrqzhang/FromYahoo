import sys

click=dict()
view=dict()
for line in sys.stdin:
    try:
       q,r,c = line.strip('\r\t\n ').split('\t')
    except: continue
    key=q+'\t'+r
    if c=='1':
       if key in click: click[key]+=int(1)
       else: click.setdefault(key,1)
       if key in view: view[key]+=int(1)
       else: view.setdefault(key,1)

    if c=='0':
       if key in view: view[key]+=int(1)
       else: view.setdefault(key,1)

for key in sorted(view, key=view.get, reverse=True):
    if key in click:
         print (key,"\t",click[key],"\t",view[key]+click[key],"\t",float(click[key])/(click[key]+view[key]))
    else: 
         print (key,"\t0","\t",view[key],"\t0")
