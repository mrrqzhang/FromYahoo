import re,math,sys
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import normalize
import xml.etree.ElementTree as et
from xml.sax.saxutils import escape

for line in sys.stdin:
    dom, outlinks = line.strip('\n').split('\t')
    ndom = normalize(dom)
    #try:
    #print escape(outlinks)
    #root = et.fromstring('<root>' + outlinks + '</root>')
    for link in re.findall('<L>(.*?)</L>',outlinks):


    #for link in root.iter('L'):
        # <L>13da8a85e450 84d103dc8a0a9980 http://www.gobluehose.com/ en canonical 12 1419811200</L>
        #tmp = link.text.split(' ')
        tmp = link.split(' ')
        ol = tmp[2]
        nol = normalize(ol)
        anchor = ' '.join(tmp[4:-2])
        print '\t'.join([dom, ndom, ol, nol, anchor])
    #except:
    #    continue



