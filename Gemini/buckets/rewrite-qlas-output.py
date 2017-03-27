import sys

sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))

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
     if 'place_name' not in line or len(fields)<=4 or fields[1]!='1': continue

     rawq = fields[0]
     nseg = int(fields[5]) 
     if nseg < 1: continue
     qlastag=[]
     referent_start=6+nseg+nseg+1
     if referent_start>=len(fields):continue
     dec_start=6+nseg+nseg+nseg+1
#     print (dec_start, nseg, len(fields), line)
     if dec_start>=len(fields): continue
     cat_start = 6+nseg
     for i in range(0,nseg):
#         if referent_start+i>=len(fields) or dec_start+i>=len(fields): continue
         sys.stdout.write('%s\t%s\t%s\n' % (fields[0],fields[6+i], fields[cat_start+i]))
