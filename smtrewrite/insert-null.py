
#1
#4 romantic hotels arden hills  # 4 5 1 2
#5 arden hills mn romantic hotel  # 3 4 4 1 2

#1
#6 romantic hotels near arden hills minnesota  # 4 5 0 1 2 3
#5 arden hills mn romantic hotel  # 4 5 6 1 2


import sys

nullpos='postprev' # postprev, prevnext, first, last



def get_null_position(vx):
    np=int(0)  #null pos
    cp=int(0)  #current pos
    for i in range(0,len(vx)):
        if int(vx[i])==0:
           cp=i+1   #### the first word indexed from 1
           if nullpos=='postprev':
              if i==0: np=int(vx[0])+1
              if i>=1: np=int(vx[i-1])+1
           if nullpos=='prevnext':
              if i==len(vx)-1: np=int(vx[i])
              if i<len(vx)-1: np=int(vx[i+1])
           if nullpos=='first':
              np=1
           if nullpos=='last':
              np=len(vx)
           break
    return [np,cp]



E = open(sys.argv[1],'r')
F = open(sys.argv[2],'r')
A = open(sys.argv[3],'r')

EO = open(sys.argv[4],'w')
FO = open(sys.argv[5],'w')
AO = open(sys.argv[6],'w')


while(True) :
     try:
        le = E.readline()
        lf = F.readline()
        count = A.readline()
     	line = A.readline()
        fields1 = line.strip('\r\n ').split(' # ')
        line = A.readline()
        fields2 = line.strip('\r\n ').split(' # ')
        if le=='' or lf=='' or count=='': break
	if  len(fields1)!=2 or len(fields2)!=2: continue
        aligne,pe = fields1
        alignf,pf = fields2
     except: continue
     efields = aligne.split()[1:] 
     ffields = alignf.split()[1:]
     lpe = pe.split()  # position e
     lpf = pf.split()
     npf,ei = get_null_position(lpe)  # if e has 0, then insert NULL to f; npf-th f word and ei-th e word. lpe(ei-1)=0 
     if npf!=0:     
          if npf-1>=len(ffields):
             ffields.append('NULL')
             lpf.append(str(ei))
          else:
             ffields.insert(npf-1,'NULL')
             lpf.insert(npf-1,str(ei))
          for j in range(0,len(lpe)):   # update e alignment; npf!=0, null start from 1
	      if lpe[j]=='0': lpe[j]=str(npf)
              elif int(lpe[j])>=npf: lpe[j]= str(int(lpe[j])+int(1))   # if pe[j]+1 because NULL insert before
     npe,fi = get_null_position(lpf)
     if npe!=0:
          if npe-1>=len(efields):
             efields.append('NULL')
             lpe.append(str(fi))
          else:
             efields.insert(npe-1,'NULL')
             lpe.insert(npe-1,str(fi))
          for j in range(0,len(lpf)):
               if lpf[j]=='0': lpf[j]=str(npe)
               elif int(lpf[j])>=npe: lpf[j]=str(int(lpf[j]) + int(1))
     EO.write('%s\n' % ' '.join(efields))
     FO.write('%s\n' % ' '.join(ffields))
     AO.write(count)
     AO.write('%d %s # %s\n' % (len(efields),' '.join(efields),' '.join(lpe)))
     AO.write('%d %s # %s\n' % (len(ffields),' '.join(ffields),' '.join(lpf)))
E.close()
F.close()
A.close()
EO.close()
FO.close()
AO.close()








         

	
