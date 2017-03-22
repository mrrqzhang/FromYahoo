#!/usr/bin/env python

import sys,re,math,os,logging,subprocess

mylibloc = '%s/mylib'%os.path.expanduser('~')
sys.path.insert(0,mylibloc)
def normalize(url):
    # caveats: 
    # home.[a-z]+: https://vetrecs.archives.gov/VeteranRequest/home.html
    # home: http://15dollarstore.com/s/home
    # home/index.html: http://www.boatracingfacts.com/home/index.html

    ret = url
    for p,q in [('^https?://',''),
                ('^(m|touch|mobile|www[0-9]?)\.',''),
                ('^(m|touch|mobile|www[0-9]?)\.',''),
                ('/(index|home|default)(\.[a-z]+)?$',''),
                ('/$','') # strip forward slash at the end
                ]:
        try: ret= re.sub(p,q,ret,flags=re.I)
        except: ret = re.sub(p + '(?i)', q, ret)
    return ret.strip('\r\t\n ')

def run_bash(script,ret=False):    
    if ret:
        return subprocess.Popen(script, shell=True, stdout=PIPE, stderr=PIPE).stdout.readlines()
    for line in script.split('\n'):
        if not line.strip('\r\t\n '): continue
        subprocess.call(line.strip('\n\r\t '),shell=True) #, shell=True, stdout = subprocess.PIPE, stderr = subprocess.PIPE)

def TryEval(s):
    try:
        return eval(str(s))
    except:
        return s

def normalizetitle(t):
    return re.sub('\s+',' ',t.lower().strip('\r\t\n '))

def self_name():
    try:
        fn = os.path.basename(__file__)
    except:
        fn = sys.argv[0]
    logging.warning('current file is %s\n'%fn)
    return fn

def multsubs(content, keyvalpairs):
    for k,v in keyvalpairs:
        content = re.sub(k,v,content)
    return content

def get_script(aggregateby = 'rawcount'):

    if aggregateby == 'sublinkscore':
        aggstep =   """ 
summed = foreach (group joined by (category,title) ) generate flatten(group) as (category,title), SUM(joined.score) as score;
                    """
    elif aggregateby == 'rawcount':
        aggstep =   """
summed = foreach (group joined by (category,title) ) generate flatten(group) as (category,title), COUNT(joined.score) as score;
                    """

    return  """
REGISTER $mylibloc/jars/pig-to-json.jar;  -- from Hortonworks
REGISTER $mylibloc/jars/json-simple-1.1.jar;

SET mapreduce.job.queuename default
SET mapreduce.reduce.speculative true
SET mapreduce.map.speculative true

SET default_parallel 100
rmf $output;

DEFINE NormalizeDomainTitle `python $selfname mode=normalize_domain_title` ship('$selfname');

DEFINE ExtractTopCategory `python $selfname mode=extract_top_category` ship('$selfname');

titledata = load '$titledata' using PigStorage('\\t') as (domain:chararray, url:chararray, title:chararray, score:double);

ldadata = load '$ldadata' using TextLoader;

ndomcats = stream ldadata through ExtractTopCategory as (ndom:chararray, category:int);

titles = stream titledata through NormalizeDomainTitle as (ndom:chararray, url:chararray, title:chararray, score:double);

joined = foreach (cogroup ndomcats by ndom inner, titles by ndom) generate  group as ndom, 
                                                                            flatten(ndomcats.category) as category,
                                                                            flatten(titles.(title,score)) as (title,score);
            """ + aggstep + \
            """
topped = foreach (group summed by category) {
            tmp = TOP(1000,2,summed);
            generate flatten(tmp.(category,title,score)) as (category, title,score);
}

sorted = order topped by category, score DESC parallel 1;

store sorted into '$output' using PigStorage('\\t','-schema');
            """
            
def PrintScript(args=None, sub=True): 
    script=  get_script(aggregateby = args['aggregateby'])
    if not sub: return script
    else: return multsubs(script, [('\$%s'%k, str(v)) for k,v in args.items()]) 


if __name__ == '__main__':
    args = dict(arg.split('=') for arg in sys.argv[1:])
    args = dict((k,TryEval(v)) for k,v in args.items())
    mode = args.setdefault('mode','master') # other choices are normalize_domain_title, extract_top_category
    output = args.setdefault('output',None)
    dryrun  =args.setdefault('dryrun',False)
    selfname = args.setdefault('selfname',self_name())
    ldadata = args.setdefault('ldadata',None)
    titledata = args.setdefault('titledata',None)
    aggregateby = args.setdefault('aggregateby','rawcount') # alternative is sublinkscore

    script = get_script(aggregateby = aggregateby)
    if mode == 'master':
        logging.warning('unsubstituted script:\n')
        logging.warning(script)
        logging.warning('substituted script:\n')
        logging.warning(PrintScript(args=args,sub=True))
        args['mode'] = 'pigmode'
        run_bash(  'pig %s %s'%(  self_name(), ' '.join('='.join(map(str,[k,v])) for k,v in args.items())   )   )
        #run_bash('pig %s mode=pigmode output=%s dryrun=%s ldadata=%s titledata=%s aggregateby=%s'%(self_name(), output, str(dryrun), ldadata, titledata, aggvalue))

    elif mode == 'pigmode':
        if not dryrun:
            from org.apache.pig.scripting import Pig 
            P = Pig.compile(script);
            result = P.bind({'output':output, 'selfname':self_name(), 'ldadata':ldadata, 'titledata':titledata, 'mylibloc':mylibloc}).runSingle()

            if result.isSuccessful():
                print 'Pig job succeeded!'
            else:
                raise 'Pig job failed!'
        else:
            print 'unsubstituted:'
            print PrintScript(args=args,sub=False)
            print 'substituted:'
            print PrintScript(args=args,sub=True)


    elif mode == 'extract_top_category':
        for line in sys.stdin:
            tmp = re.split('\s+',line)
            d = tmp[0]
            topcat = tmp[1].strip('()').split(',')[0]
            print '\t'.join([d,topcat])

    elif mode == 'normalize_domain_title':
        pd = None
        for line in sys.stdin:
            d,u,t,s = line.strip('\n').split('\t')
            if not pd == d:
                nd = normalize(d)
                pd = d
            nt = normalizetitle(t)
            print '\t'.join([nd,u,nt,s])
    
