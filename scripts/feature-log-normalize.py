
import sys
import math

FSTART=0

logfeature={}
for line in open(sys.argv[1],'r'):
   if line[0] != '#':
      logfeature[line.strip()]=1

TEST=False
logf=[]
features=[]
ni=0
max_value=[]
min_value=[]

if len(sys.argv) ==3 :
   TEST=True
   for line in open(sys.argv[2],'r'):
     fields = line.strip().split('\t')
     if fields[0]=="MAX:": 
	max_value=fields[1:]
     if fields[0]=="MIN:":
	 min_value=fields[1:]
header=None
for line in sys.stdin:
   if ni==0:
      header = line.strip()
      fields = header.split('\t')
      if len(logf)==0 :
         logf = range(len(fields))
      if TEST==False:
      	max_value = range(len(fields))
      	min_value = range(len(fields))
      for i in range(0,len(fields)):
         if logfeature.has_key(fields[i]):
              logf[i]=1
      ni+=1
      features.append(fields)
      continue
   features.append(line.strip().split('\t'))
   for j in range(FSTART,len(features[ni])):
      if logf[j]==1:
         if float(features[ni][j])>0:
		features[ni][j]=math.log(float(features[ni][j]))
      if TEST==False:
          if float(features[ni][j])>float(max_value[j]) or ni==1: max_value[j]=features[ni][j]
          if float(features[ni][j])<float(min_value[j]) or ni==1: min_value[j]=features[ni][j]
   ni+=1


for i in range(1,ni):
  for j in range(FSTART,len(features[i])):
      if float(max_value[j])==float(min_value[j]): features[i][j] = 0
      else: features[i][j]=(float(features[i][j])-float(min_value[j]))/(float(max_value[j])-float(min_value[j])) 

for i in range(0,ni):
   sys.stdout.write('%s\n' % '\t'.join(str(x) for x in features[i]))

if TEST==False:
   sys.stdout.write('MAX:\t%s\n' % '\t'.join(str(x) for x in max_value[FSTART:]))
   sys.stdout.write('MIN:\t%s\n' % '\t'.join(str(x) for x in min_value[FSTART:]))
