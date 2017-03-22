import sys,re,math

#the best translation score is < -2 (-1 for one word)
WL1TH=float(-2.0)
WL2TH=float(-4.0)
WL3TH=float(-5.0)
WL4TH=float(-5.0)

'''
WL1CNT=float(5)
WL2CNT=float(3)
WL3CNT=float(2)
WL4CNT=float(2)
'''
#change threshold for all bid term training table to reduce size
WL1CNT=float(10)
WL2CNT=float(8)
WL3CNT=float(6)
WL4CNT=float(6)




def equiv_analysis(q,r):
    if len(q)!=len(r):
       return 0    
    type='None'
    for i in range(len(q)):
        if q[i]==r[i]: continue
        elif re.sub(' ','',q[i])==re.sub(' ','',r[i]):
              type='Mix' if type!='None' else 'splitjoin'
        elif q[i]+'s'==r[i] or q[i]==r[i]+'s':
	      type='Mix' if type!='None' else 'sigular'
        elif ' ' in q[i] and ' ' not in r[i]:
              qs = q[i].split()
              ac=''
              for j in range(len(qs)): ac=ac+qs[j][0]
              if ac==r[i]: type='Mix' if type!='None' else 'acronynm'
              else: 
		type='None'
                break
              if len(q)!=1 and len(r)!=1:
                type='None'
		break
        elif ' ' not in q[i] and ' ' in r[i]:
              rs = r[i].split()
              ac=''
              for j in range(len(rs)): ac=ac+rs[j][0]
              if ac==q[i]: type='Mix' if type!='None' else 'acronynm'
              else: 
		type='None'
		break
              if len(q)!=1 and len(r)!=1:
                type='None'
                break

        else: 
	      type='None'
              break
    return type



for line in sys.stdin:
    if 'PHRASETABLE' not in line:
       continue
    fields = line.strip('\r\n ').split('\t')
    words = fields[1] 
    q,r,score,a,o,t = words.split(' ||| ')
    if  q==r and ' ' in q: continue
    qf = q.split() #query
    rf = r.split()  #rewrite
    sf = score.split()  #score
    af = a.split()
    of = o.split()
    for i in range(4): 
        sf[i]=float(sf[i])
    for i in range(3):
        of[i]=float(of[i])



    score = 0.2*math.log(sf[0])+0.2*math.log(sf[1])+0.2*math.log(sf[2])+0.2*math.log(sf[3])
    
    nw=len(qf)
    nt=len(rf)
    threshold = WL1TH if nw==1 else ( WL2TH if nw==2 else ( WL3TH if nw==3  else WL4TH ) )
    cnt_threshold = WL1CNT if nw==1 or nt==1 else ( WL2CNT if nw==2 or nt==2 else (WL3CNT if nw==3 or nt==3 else WL4CNT ) )

    ss=''
    tt=''
    pre_sa=int(-1)
    pre_ta=int(-1)
    for item in af:
        sa,ta = item.split('-')
        sa = int(sa)
        ta = int(ta)
        if sa != pre_sa:
           if ta!=pre_ta:
              ss = ss+'|'+ qf[sa]
           else:
              ss = ss+ ' ' +qf[sa]
        if ta != pre_ta:
           if sa!=pre_sa:
              tt = tt+'|'+rf[ta]
           else: tt = tt+' '+rf[ta]
        pre_sa = sa
        pre_ta = ta
    source = ss.split('|')[1:]
    target = tt.split('|')[1:]

    type = equiv_analysis(source,target)

    if (of[2]<cnt_threshold or score < threshold) and type == 'None': continue  # CUT 

#    if source==target: continue
    value = q + '_' + r
    key = value
    s=[]
    t=[]
    if source!=target and len(source)==len(target):
       for i in range(len(source)):
          if source[i]!=target[i]:
             s.append(source[i])
             t.append(target[i])
       key = ' '.join(s) + '_' + ' '.join(t)
    sys.stdout.write('%s\t%s\t%s\t%s\t%f\t%s\n' %(key,value, q,r,score, words)  ) 



