#!/usr/bin/python

import sys,re,math
inputfile=sys.argv[1]
outputfile=sys.argv[2]
columns=map(int,sys.argv[3].split(','))
dryrun=False
if len(sys.argv)> 4:
    dryrun = eval(str(sys.argv[4]))


script="set default_parallel 100;\n"
script="ret = load '$in' using PigStorage('\\t');\n"

for i,c in enumerate(columns):
    script += "ret%d = foreach ret generate $%d as col;\n"%(i+1,c)

script += "ret0 = union %s;\n"%(','.join('ret%d'%(i+1) for i,c in enumerate(columns)))
script += "ret0 = distinct ret0;\n"
script += "store ret0 into '$out' using PigStorage('\\t','-schema');\n"

if not dryrun:
    from org.apache.pig.scripting import Pig 
    P = Pig.compile(script);
    result = P.bind({'in':inputfile, 'out':outputfile}).runSingle()

    if result.isSuccessful():
        print 'Pig job succeeded!'
    else:
        raise 'Pig job failed!'
else:
    print 'unsubstituted:'
    print script
    print 'substituted:'
    print re.sub('\$in',inputfile,re.sub('\$out',outputfile,script))
