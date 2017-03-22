import sys,os

file = open(sys.argv[1],'r')
sum = 0
i = 0
for line in file:
	[label,predicted] = line[:-1].split('\t')
	try:
		sum = sum+(float(label)-float(predicted))**2	
        except:
                print line[:-1]
        i = i+1
        if i%1000000==0: print i,sum/float(i)

print sum/float(i)
