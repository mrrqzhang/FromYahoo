import sys,re

totalindex=0
id_map = dict()

synset=[]
linenum=0




for line in sys.stdin:
    linenum+=1
    if linenum%100000==0:
       sys.stderr.write('line:%d' % linenum)

    fields = line.strip('\r\n ').split('\t')






    left = re.sub('NULL ','',fields[0]) 
    left = re.sub(' NULL','',left)
    right = re.sub('NULL ','',fields[1])
    right = re.sub(' NULL','',right) 

#    if len(left.split())==1 and len(right.split())==1: 
#	sys.stdout.write('%s\t%s\n' % (left,right))
#	continue   #THIS RULE WORK but hurt RECALL: DISAMBUGATION
#    if len(left.split())!=1 or len(right.split())!=1: continue

#    if (left in hfqmap) or (right in hfqmap): 
#	continue    
    lid=int(-1)
    rid=int(-1)
    if left in id_map: 
        lid = id_map[left]
    if right in id_map:
        rid = id_map[right]
#    print lid, rid
    if lid!=rid and (lid!=-1 and rid!=-1):
	if len(synset[rid])>2 and len(synset[lid])>2:continue  # merge cause error grow
	tmp=synset[lid].union(synset[rid])
        if len(tmp)>=20:
		continue
        synset[lid]=tmp
        for item in synset[lid]:
            id_map[item]=lid
        synset[rid].clear()
#        print "AAA2:", synset[rid] 
        continue
    if lid!=rid:
       if lid!=-1: 
		rid=lid
		id_map[right]=rid
		synset[rid].add(right)
       else:  
		lid=rid
		id_map[left]=lid
                synset[lid].add(left)
       continue
    if lid==-1 and rid==-1:
       lid=totalindex 
       rid=totalindex 
       id_map.setdefault(left,lid)
       id_map.setdefault(right,rid)
       synset.append(set([right,left]))
 #      print "AAA:",synset[totalindex], right,left
       totalindex+=1
       continue

for i in range(len(synset)):
    print synset[i]

    
