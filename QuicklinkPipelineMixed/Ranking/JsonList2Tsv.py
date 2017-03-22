import sys,re,math,logging
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
try:
    from kitchen.text.converters import to_bytes, to_unicode
except:
    pass
try:
    import simplejson as json
except ImportError:
    import json

mapping={'true':1,'false':0,'fal':0,'parent':1,'mirror':0}

def TryEval(s):
    try: return eval(str(s))
    except: return s

def OpenJs(js,size,defaultval):
    if not js: js2 = []
    else:
        try:
            js2 = json.loads(js)
        except:
            logging.warning('Cannot load json: %s'%js)
            raise ValueError('Cannot load json: %s'%js)
    if not len(js2) == size:
        return [defaultval] * size
    else:
        return [mapping.get(k,k) for k in js2]

def fixstr(s):
    try:
        return str(s)
    except:
        try:
            return s.decode('utf-8','ignore')
        except:
            return to_bytes(s)

if __name__ == '__main__':
    jsindices = map(int,sys.argv[1].split(','))
    jssizes = map(int, sys.argv[2].split(','))
    jssizedict = dict(zip(jsindices,jssizes))
    defaultval = TryEval(sys.argv[3])

    for line in sys.stdin:
        tmp = line.strip('\n').split('\t')
        # flatten out melange of atomic columns with json columns
        try:
            ret = [t for u in [OpenJs(s, jssizedict[i],defaultval) if i in jsindices else [s] for i,s in enumerate(tmp)] for t in u]
        except:
            logging.warning('Cannot load json for this record: %s; tmp = %s'%(line,str(tmp)))
        
        print '\t'.join(map(fixstr,ret))

