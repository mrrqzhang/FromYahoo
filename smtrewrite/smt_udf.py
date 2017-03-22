import math

@outputSchema('count:long')
def wordcount(x):
    vx =  x.split()
    return long(len(vx))


@outputSchema('score:float')
def cosine(x, y):
  try:
    
    xs = x.split()
    ys = y.split()
    if (len(xs) == 0) or (len(ys) == 0):
      return 0.0
    match = 0
    for i in range(len(xs)):
      for j in range(len(ys)):
        if (xs[i] == ys[j]):
          match += 1
          break
    score = float(match) / math.sqrt(1.0 * len(xs) * len(ys))
    return score
  except:
    return 0.0

@outputSchema('score:float')
def numerical_cosine(x,y):
  try:
    itemx = x.split('|') 
    itemy = y.split('|')
    dictx = dict(x.split(':') for x in itemx)
    dicty = dict(y.split(':') for y in itemy)     
    sum=0
    for key in dictx:
        if key in dicty:
           sum += float(dictx[key])*float(dicty[key])
    sx=0
    sy=0 
    for key in dictx: sx += float(dictx[key])*float(dictx[key])
    for key in dicty: sy += float(dicty[key])*float(dicty[key])
    score = float(sum)/math.sqrt(sx)/math.sqrt(sy)
    return score
  except: return 0.0

@outputSchema('y:bag{t:tuple(partition:int, query:chararray)}')
def replicate_queries(npartitions, q):
  output = []
  for i in range(npartitions):
    output.append((i, q))
  return output


@outputSchema('y:bag{t:tuple(oldid:chararray,nid:int)}')
def map_adgroupid2(x):
  output = []
  for i in range(len(x)):
    output.append((x[i],i))
  return output

@outputSchema('y:bag{t:tuple(oldid:chararray,nid:int)}')
def map_adgroupid(x):
  BUCKETSIZE=int(15000000)  
  output = []
  nid = int(0)
  sum = int(0)
  for i in range(0,len(x),2):
    oid = x[i]
    count = int(x[i+1])
    if sum+count<BUCKETSIZE:
	output.append((oid,nid))
	sum += count
    else: 
	nid += 1
        output.append((oid,nid))
	sum = count
  if nid==0: 
	return output
  cid = int(0) #change last nid 
  output2 = []
  start = 0
  for i in range(len(output)): 
    if output[i][1] == nid:
           if start==0: start = i
           output2.append((output[i][0],cid))
           cid += 1
           if cid==nid: cid=0   
  return output[0:start]+output2
  
	 



