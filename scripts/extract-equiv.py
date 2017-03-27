import sys,re





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
    if 'PHRASE' not in line:
       continue
    fields = line.strip('\r\n ').split('\t')
    words = fields[1] 
    q,r,s,a,o,t = words.split(' ||| ')

    qf = q.split()
    rf = r.split()
    af = a.split()
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
#    if type != 'None':
#       print source
#       print target
    if type == 'acronynm':
#       sys.stdout.write('%s\t%s\n' % (type,words))
        ip,il,p,l = s.split() 
        sys.stdout.write('%s\t%s\t%s\t%s\n' % (q,r,ip,p))
