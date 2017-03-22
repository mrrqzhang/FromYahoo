import sys,re,math
from unidecode import unidecode
import htmllib
def unescape(s):
    p = htmllib.HTMLParser(None)
    p.save_bgn()   
    try: 
        p.feed(s)
    except:
        raise ValueError(s)
    return p.save_end()

def TitleBeautify(title): 
    # test re.sub('&(amp;)+','&', 'a &amp;amp; b') => a & b
    return unescape(unidecode(re.sub('</?b>','',re.sub('_', ' ',title))))
if __name__ == "__main__":
    for line in sys.stdin:
        tmp = line.strip('\r\t\n ').split('\t')
        print '\t'.join(tmp[:2] + [TitleBeautify(tmp[2].decode('utf-8','ignore'))] + tmp[3:])
