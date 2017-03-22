#!/usr/bin/python

import sys,re,math
inputfile1=sys.argv[1]
inputfile2=sys.argv[2]
outputfile=sys.argv[3]
columns1 = sys.argv[4]
columns2 = sys.argv[5]

columns1 = ', '.join('$%s'%i for i in columns1.split(','))

columns2 = ', '.join('$%s'%i for i in columns2.split(','))


# columns of the format "-k1[rg] -k2[rg] .."
columns=sys.argv[6].split(' ')
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
    
maxn= max(doubles)
caststr = []
for i in xrange(maxn+1):
    if i in doubles:
        caststr.append('(double) $%d'%i)
    else:
        caststr.append('$%d'%i)
caststr.append('$%d ..'%(maxn + 1))
caststr = ', '.join(caststr)




finalparallel = 100
if len(sys.argv) > 7:
    finalparallel = int(sys.argv[7])

defaultparallel = 100
if len(sys.argv) > 8:
    defaultparallel = int(sys.argv[8])
    
dryrun=False
if len(sys.argv)> 9:
    dryrun = eval(str(sys.argv[9]))


noSplit=True
if len(sys.argv) > 10:
    noSplit = eval(str(sys.argv[10]))




script="set default_parallel %d;\n"%defaultparallel
if noSplit:
    script += "SET pig.noSplitCombination true;\n"
script += "ret1 = load '$in1' using PigStorage('\\t');\n"
script += "ret2 = load '$in2' using PigStorage('\\t');\n"

script += "ret = foreach (cogroup ret1 by ( %s ), ret2 by ( %s ) inner) generate flatten(ret1);\n"%(columns1, columns2)

script += "ret = foreach ret generate %s;\n"%caststr


script += "ret = order ret by %s parallel %d;\n"%(colrev, finalparallel)

script += "store ret into '$out' using PigStorage('\\t','-schema');\n"

if not dryrun:
    from org.apache.pig.scripting import Pig 
    P = Pig.compile(script);
    result = P.bind({'in1':inputfile1, 'in2':inputfile2, 'out':outputfile}).runSingle()

    if result.isSuccessful():
        print 'Pig job succeeded!'
    else:
        raise 'Pig job failed!'
else:
    print 'unsubstituted:'
    print script
    print 'substituted:'
    print re.sub('\$in2', inputfile2, re.sub('\$in1', inputfile1, re.sub('\$out', outputfile, script)))
