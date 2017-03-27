import sys
for line in sys.stdin:
    x,y,s,t = line.split('\t')
    xs = x.split()
    ys = y.split()
    out=True
    if xs[0]==ys[0]:
       out=False
    if len(xs)>1:
       if ys[0]==xs[1]: out=False
       tmp=xs[0][0:len(ys[0])]
       if tmp==ys[0]: out=False
    if len(ys)>1:
       if xs[0]==ys[1]: out=False
       tmp=ys[0][0:len(xs[0])]
       if tmp==xs[0]: out=False
    if out==True:
       print line.strip('\r\n ')
