import sys

second=False
if len(sys.argv)>1: second=True

query=""
ac=int(0)
predomain=""
preq=""
view = 0
for line in sys.stdin:
    query,domain,count=line.strip('\r\n ').split('\t')
    if second==False:
       if preq != query:
            sys.stdout.write('%s\t%s\t%d\n' % (preq,predomain,int(ac)))
            preq=query
            predomain=domain
            ac=count
       else:
            ac = int(ac)+int(count)
    else:
       if preq != query or predomain != domain:
            sys.stdout.write('%s\t%s\t%d\t%d\n' % (preq,predomain,int(ac),view))
            preq=query
            predomain=domain
            ac=count
            view=1
       else:
            ac = int(ac)+int(count)
            view += 1
       
