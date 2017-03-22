import sys,os

input = open(sys.argv[1],'r')
locations = {}
for line in input:
	loc = line[:-1].strip()
	if len(loc)<=2: continue
	locations[loc] = 1
	#split = loc.split(' ')
	#if len(split)>=2:
	#	locations[' '.join(split[:-1])] = 1

while True:
        line = sys.stdin.readline()
        if not line: break
        [qry,url,clicks] = line[:-1].split('\t')
	split = qry.split(' ')
	blnFound = False
	for i in range(len(split)):
		for k in range(5):
			j = 4-k
			if i+j<len(split):
				if locations.has_key(' '.join(split[i:i+j+1])):
					print '_'.join(split[i:i+j+1])+'\t'+url+'\t'+clicks
					blnFound = True
					break
		if blnFound: break
