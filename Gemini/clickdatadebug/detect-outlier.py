import sys

for line in sys.stdin:
  try:
    query,fv = line.strip('\r\t\n').split('\t')
    fields = fv.split('|')
    feature = [ item.split(':')  for item in fields ]
    sortedfeature = sorted(feature, key=lambda x:x[1], reverse=True)
    if len(sortedfeature)>1 and float(sortedfeature[0][1])>=0.8 and float(sortedfeature[0][1])>5*float(sortedfeature[1][1]):
        if sortedfeature[0][0] not in query:
            sys.stdout.write('%s\n'  % line)
    if len(sortedfeature)==1 and sortedfeature[0][0] not in query: 
		sys.stdout.write('%s\n'  % line)
  except:pass
