import sys

ql={}
domain={}

for line in open(sys.argv[1],'r'):
   fields = line.strip().split('\t')
   if len(fields)<2: continue
   domain[fields[0].strip()]=fields[1].strip()


for line in open(sys.argv[2],'r'):
   fields = line.strip().split('\t')
   if len(fields)<2: continue
   ql[fields[0].strip()]=fields[1].strip()


for line in sys.stdin:
   fields = line.strip().split('\t')
   if fields[0]=="domain" or len(fields) < 2: continue
   dt = "-" 
   qlt = "-" 
   if domain.has_key(fields[0].strip()):
      dt = domain[fields[0].strip()]
   if ql.has_key(fields[1].strip()):
      qlt = ql[fields[1].strip()]
   sys.stdout.write("%s\t%s\t%s\t%s\n" % ("\t".join(fields[0:2]),dt, qlt,"\t".join(fields[2:])))

