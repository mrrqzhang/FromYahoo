import sys,re

for line in sys.stdin:
    try:
#        tmp,field = line.strip('\r\t\n').split('\t')
        fields = line.strip('\r\t\n').split(' ||| ')
    	if (re.search(''.join([' .*',fields[1],' .*']), fields[0]) or re.search(''.join([' .*',fields[1],'$']), fields[0]) or re.search(''.join(['^',fields[1],'.* ']), fields[0]) ) and fields[0] != fields[1]: 
        	  sys.stdout.write('%s\t%s\n' % (fields[0],fields[1])) 
    except: pass
