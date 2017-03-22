import sys,numpy
from numpy  import *

sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from myfunc import cosine2,qnormalize

def diversify(domainset):
    simset=[]
    simset.append(0)
    for li in range(1,len(domainset)):
        sim=0
        for ki in range(0,li):
            sim = max(sim, cosine2(qnormalize(domainset[li][2]).lower().split(),qnormalize(domainset[ki][2]).lower().split()))  
	if sim!=0: simset.append(sim)
#    print simset
    mdin = numpy.median(simset)
    if mdin==0: return domainset
    br=[]
    while domainset:
         bc=[]
         bc.append(domainset[0])
         domainset.pop(0)
         li=0
         while  domainset:
            sim=0
	    for ki in range(0,len(bc)):
	        sim = max(sim, cosine2(qnormalize(domainset[li][2]).lower().split(),qnormalize(bc[ki][2]).lower().split()))
#            print sim, mdin
            if sim<mdin: 
		bc.append(domainset[li])
		domainset.pop(li)
                if li==len(domainset): break
            else:
               li += 1
               if li>=len(domainset): break
         br.extend(bc)
    return br
    

debug=False
pred=''
domainset=[]
domainset2=[]
if len(sys.argv)==2: debug=True
line = sys.stdin.readline()
domain,ql,title,score = line.strip('\r\t\n ').split('\t')
pred = domain
domainset.append([domain,ql,title,score])
for line in sys.stdin:
    domain,ql,title,score = line.strip('\r\t\n ').split('\t')
    if domain != pred:
         if debug==True:
            domainset2 = list(domainset) 
         drank = diversify(domainset)
         num = len(drank)
         if debug==False:
             for item in drank:
		item[3] = str(float(item[3])+num)
		num -= 1 
		sys.stdout.write('%s\n' % '\t'.join(item))
         elif debug==True:
             if drank != domainset2:
                 print "<<<<<< after diversify"
                 num=len(drank)
                 for item in drank:
                    item[3]=str(float(item[3])+num)
                    num-=1 
                    print '\t'.join(item)
                 print "====== before diversify"
                 for item in domainset2: print '\t'.join(item)
                 print ">>>>>"


         pred = domain
         domainset=[]
    domainset.append([domain,ql,title,score])
if domainset:
         drank = diversify(domainset)
	 num = len(drank)
         for item in drank:
		item[3] = str(float(item[3])+num)
		num -= 1 
		sys.stdout.write('%s\n' % '\t'.join(item))


