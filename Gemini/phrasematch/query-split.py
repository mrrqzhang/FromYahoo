import sys

for line in sys.stdin:
    words = line.strip('\r\t\n').split()
    for i in range(0,len(words)):
        end = len(words) if i==0 else len(words)+1
        for j in range(i+1,end):
        	sys.stdout.write('%s\t%s\n' % (line.strip('\r\t\n'), ' '.join(words[i:j])))
#        sys.stdout.write('%s\t%s\n' % (line.strip('\r\t\n'), ' '.join(words[i-1:len(words)])))
    
