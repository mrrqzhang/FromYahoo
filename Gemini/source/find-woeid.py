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
#     print dec_start, nseg, len(fields), line
     if dec_start>=len(fields): continue
     city_woeid=[]
     country_woeid=[]
     state_woeid=[]
     for i in range(0,nseg):
         if referent_start+i>=len(fields) or dec_start+i>=len(fields): continue
         if is_number(fields[referent_start+i]):
            if "place_category=/city" in fields[dec_start+i]:
		city_woeid.append('city:'+fields[referent_start+i])
            if "place_category=/state" in fields[dec_start+i]:
                state_woeid.append('state:'+fields[referent_start+i])
            if  "place_category=/country" in fields[dec_start+i]:
		country_woeid.append('country:'+fields[referent_start+i])
     if len(city_woeid)!=0 or len(state_woeid)!=0 or len(country_woeid)!=0: 
         sys.stdout.write('%s\t%s\t%s\t%s\n' % (fields[0], ' '.join(sorted(city_woeid)), ' '.join(sorted(state_woeid)), ' '.join(sorted(country_woeid))  ))

