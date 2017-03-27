import sys

from collections import defaultdict

fdict = open(sys.argv[1],'r')
fin = open(sys.argv[2],'r')

dict=defaultdict()

for line in fdict:
    fields = line.strip('\r\t\n').split('\t')
#    dict.setdefault(fields[0],line.strip('\r\t\n'))
    dict[fields[0]] = line.strip('\r\t\n')

for line in fin:
    fields = line.strip('\r\t\n').split('\t')
    if fields[0] in dict:
       sys.stdout.write('%s\t%s\n' %(dict[fields[0]],line.strip('\r\t\n')))

fdict.close()
fin.close()
