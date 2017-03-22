import sys,random

BUCKETSIZE=int(1000000) 
nid=int(0)

key=str(random.random())
sum=int(0)
outputid = key+'-'+str(nid)

mapping = dict()
for line in sys.stdin:
    oid,count = line.strip('\r\t\n ').split('\t')
    count = int(count)
    if sum+count<BUCKETSIZE:
       mapping[oid] = outputid
       sum += count
    else:
       for key in mapping: 
	   sys.stdout.write('%s\t%s\t%d\n' % (key,mapping[key],sum))
       nid += 1
       sum=count
       outputid = key+'-'+str(nid)
       mapping.clear()
       mapping[oid] = outputid


