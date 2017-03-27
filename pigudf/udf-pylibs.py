import sys,re,string,math
import array
import jarray
from types import *

@outputSchema('fv:chararray')
def mergedWord2Vec(bag):
    outvec=[]
    for item in bag:
        w = item[-2]
        vec = item[-1]
        tmp = [ float(w)*float(x) for x in vec.split() ]
        if not outvec: outvec=tmp
        else:
            outvec = [ outvec[i]+tmp[i] for i in range(len(outvec)) ]
    outvec = [ str(outvec[i]) for i in range(len(outvec)) ]
    return ' '.join(outvec)

@outputSchema('query:chararray')
def qnormalize(query):
    regex = re.compile('[%s]' % re.escape(string.punctuation))
    query = regex.sub(' ', query.lower())
    query = query.strip(' ')
    query = re.sub(' +',' ',query)
    return query



@outputSchema('url:chararray')
def normalize(url):
    # caveats: 
    # home.[a-z]+: https://vetrecs.archives.gov/VeteranRequest/home.html
    # home: http://15dollarstore.com/s/home
    # home/index.html: http://www.boatracingfacts.com/home/index.html
    ret = url
    if isinstance(url,array.array):
       s=[]
       [ s.append(int(url[i])) for i in range(0,len(url)) ]
       ret = ''.join([chr(x) for x in s])
    for p,q in [('^https?://',''),
                ('^m\.',''),
                ('^touch\.',''),
                ('^www[0-9]?\.',''),
                ('/$',''),  # strip forward slash at the end
                ('/(index|home|default)\.[a-z]+$','')]:
        ret = re.sub(p,q,ret)
    ret = ret.strip('\r\t\n ')
    return ret

@outputSchema('url:chararray')
def MildNormalize(url):
    # only allow certain extension after index, home, or default, since facebook.com/index.cc for instance is a search query
    ret = url
    if isinstance(url,array.array):
       s=[]
       [ s.append(int(url[i])) for i in range(0,len(url)) ]
       try: 
          ret = ''.join([chr(x) for x in s])
       except: pass
    for p,q in [('^https?://',''),
                ('^(m|touch|mobile|www[0-9]?)\.',''),
                ('^(m|touch|mobile|www[0-9]?)\.',''),
                ('/(index|home|default)\.(ognc|aspx|html|htm|jsp|gsp|tmpl)$',''),
                ('/(index|home|default)$',''),
                ('/$','') # strip forward slash at the end
                ]:
        try: ret= re.sub(p,q,ret,flags=re.I)
        except: ret= re.sub(p+'(?i)',q,ret)
    return ret.strip('\r\t\n ')


@outputSchema('url:chararray')
def Normalize(url):
    return MildNormalize(url)


def Normalize2(url):
    return MildNormalize(url)

@outputSchema('weight:double')
def piglog(x):
    ret=x
    if isinstance(x,array.array):
       s=[]
       [ s.append(int(x[i])) for i in range(0,len(x)) ]
       ret = ''.join([chr(x) for x in s])
       ret = float(ret)
    if float(ret)<=0: return 0
    return math.log(float(ret))
   

@outputSchema('weight:double')
def pigdouble(x):
    ret=x
    if isinstance(x,array.array):
       s=[]
       [ s.append(int(x[i])) for i in range(0,len(x)) ]
       ret = ''.join([chr(x) for x in s])
       ret = float(ret)
    if float(ret)<=0: return 0
    return float(ret)



"""
for line in sys.stdin:
    line = [ord(c) for c in line]
    print line
    print normalize(line)
"""
