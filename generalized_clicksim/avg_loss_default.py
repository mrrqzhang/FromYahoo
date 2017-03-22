import sys,os

file = open(sys.argv[1],'r')
sum = 0
i = 0
for line in file:
	split = line[:-1].split(' ')
	try:
		label = float(split[0])
		w_sum = 0
		for item in split[2:]:
			_split = item.split(':')
			weight = float(_split[-1])
			w_sum = w_sum+weight
		sum = sum+(label-w_sum)**2
	except:
		print line[:-1]
	i = i+1
	if i%1000000==0: print i,sum/float(i)

print sum/float(i)
