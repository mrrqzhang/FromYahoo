#use two colunm file as the first parameter. multiple column file as the second

import sys

# file format: recall\tprecision

dict1 = dict()
dict2 = {}
for line in open(sys.argv[1],'r'):
    try:
        fields = line.strip('\r\t\n').split('\t')
        dict1[fields[0]] = '\t'.join(fields[1:])
    except:pass

for line in open(sys.argv[2],'r'):
    try:
        fields = line.strip('\r\t\n').split('\t')
        dict2[fields[0]] = '\t'.join(fields[1:])
    except:pass

for key in dict1.keys():
    if key in dict2:
        sys.stdout.write('%s\t%s\t%s\n' %(key, dict1[key],dict2[key]))
    else:
        sys.stdout.write('%s\t%s\t\n' %(key, dict1[key]))


for key in dict2.keys():
#    if key in dict1:
#        sys.stdout.write('%s\t%s\t%s\n' %(key, dict1[key],dict2[key]))
    if key not in dict1:
        sys.stdout.write('%s\t\t%s\n' %(key, dict2[key]))

