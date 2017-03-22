#!/usr/bin/python

import sys,re,math
inputfile=sys.argv[1]
outputfile=sys.argv[2]
# columns of the format "-k1[rg] -k2[rg] .."
columns=sys.argv[3].split(' ')
colrev = []
doubles = []
for t in columns:
    tmp = re.findall('\-k([1-9][0-9]*)([rgn]*)', t)[0]
    n = int(tmp[0]) - 1
    f = 's'
    if len(tmp) > 1:
        f = tmp[1]
    numeric = 'g' in f or 'n' in f
    if numeric: doubles.append(n)
    rev = 'r' in f
    colrev.append('$%d %s'%(n,'DESC' if rev else 'ASC'))
colrev = ', '.join(colrev)
    
maxn= max(doubles + [0])
caststr = []
for i in xrange(maxn+1):
    if i in doubles:
        caststr.append('(double) $%d'%i)
    else:
        caststr.append('$%d'%i)
caststr.append('$%d ..'%(maxn + 1))
caststr = ', '.join(caststr)
    

finalparallel = 100
if len(sys.argv) > 4:
    finalparallel = int(sys.argv[4])

defaultparallel = 100
if len(sys.argv) > 5:
    defaultparallel = int(sys.argv[5])
dryrun=False
if len(sys.argv)> 6:
    dryrun = eval(str(sys.argv[6]))
noSplit=True
if len(sys.argv) > 7:
    noSplit = eval(str(sys.argv[7]))


script="set default_parallel %d;\n"%defaultparallel
if noSplit:
    script += "SET pig.noSplitCombination true;"
script += "ret = load '$in' using PigStorage('\\t');\n"

script += "ret = foreach ret generate %s;\n"%caststr

script += "ret = order ret by %s parallel %d;\n"%(colrev, finalparallel)

script += "store ret into '$out' using PigStorage('\\t','-schema');\n"

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
