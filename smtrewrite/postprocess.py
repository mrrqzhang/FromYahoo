import sys

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        pass
 
    try:
        import unicodedata
        unicodedata.numeric(s)
        return True
    except (TypeError, ValueError):
        pass
    return False

for line in sys.stdin:
    fields = line.strip('\r\t\n ').split('\t')
    q = fields[0].split()
    r = fields[1].split()
    qn=[]
    rn=[]
    for i in range(len(q)):
	if is_number(q[i]):
           qn.append(q[i])
    for i in range(len(r)):
        if is_number(r[i]):
           rn.append(r[i])
    if rn != qn and len(rn)==len(qn): continue
    sys.stdout.write('%s' % line) 
