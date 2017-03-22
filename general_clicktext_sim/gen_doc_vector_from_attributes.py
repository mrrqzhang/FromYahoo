import sys,os

def normalize_vector(vector,weight_given):
        split = vector.split('|')
        sum = 0
        for item in split:
		if weight_given:
			if ':' in item:
				_split = item.split(':')
				cat = ':'.join(_split[:-1])
				val = float(_split[-1])
			else:
				cat = item
	                        val = 1.0
		else:
			cat = item
	                val = 1.0
                sum = sum+float(val)*float(val)
        norm = float(sum**0.5)
        tmp = []
        for item in split:
		if weight_given:
			if ':' in item:
	                        _split = item.split(':')
        	                cat = ':'.join(_split[:-1])
                	        val = float(_split[-1])
			else:
				cat = item
	                        val = 1.0
                else:
                        cat = item
                        val = 1.0
                tmp.append(cat+':'+str(float(val)/norm))
        return ['|'.join(tmp),norm]

weight_given = sys.argv[1]=='yes'
while True:
        line = sys.stdin.readline()
        if not line: break
        split = line[:-1].split('\t')
	id = split[0]
	dcats = split[1]
	if len(dcats.strip())==0: continue
	[vec,norm] = normalize_vector(dcats,weight_given)
	print id+'\t'+vec+'\t'+str(norm)
