import codecs
import os,sys
import math
import re
import sets
from string import *

def calc_ctrs( data ):
    clks=[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    imps=0
    clicked_sessions=0.0
    for i in range(len(data)):
        line=data[i]
        line=line.strip()
        if line=="": continue
        items=split(line,'\t')
        if len(items) < 23: continue
        clicked=0
        for i in range(10):
            item=items[i+14].strip()
            if item=='0':continue
            #sub_items=split(item,',')
            #clks[i]+=len(sub_items)
            #del(sub_items)
            clks[i] += 1.0
            clicked=1
        imps += 1
        if clicked > 0: clicked_sessions += 1.0
        del(items)
    
    total_imps=0.0
    ctrs=[]
    total_clk = 0.0
    if imps < 1: return ctrs
    for i in range(10):
        total_clk += clks[i]
        total_imps += imps
        ctrs.append(str(clks[i]/imps))
        #ctrs.append(str(total_clk/total_imps))
    #if clicked_sessions > 0:
        #ctrs.append(str(clicked_sessions))
    #else: ctrs.append("0")
    ctrs.append(str(clicked_sessions))
    ctrs.append(str(imps))
    return ctrs

    
if __name__== '__main__':
    if ( len(sys.argv)!= 4 ):
        print """Usage: calc_ctrs_by_qry.py <input> <min> <output>\n"""
        sys.exit(1)

input = codecs.open( sys.argv[1], 'r', 'utf-8')
output = codecs.open( sys.argv[3], 'w', 'utf-8' )
min=int(sys.argv[2])
current_qry=""
new_qry=""
data=[]
count=0
for line in input:
    line=line.strip()
    if line=="": continue
    new_qry=split(line,'\t')[1]
    if new_qry!=current_qry:
        if ( current_qry!=""):
            if count >=  min and count > 0:
                ctrs = calc_ctrs(data)
                if  len(ctrs) > 0:
                    output.write(current_qry+'\t'+'\t'.join(ctrs)+'\t'+'\t'.join(data[-1].split('\t')[4:14])+'\n')
                    del(ctrs)
            del(data)
        current_qry=new_qry
        count=0
        data=[]
    data.append(line); count += 1;
if ( current_qry!=""):
    if count >= min and count > 0:
        ctrs = calc_ctrs(data)
        if len(ctrs)>0:
            output.write(current_qry+'\t'+'\t'.join(ctrs)+'\n')
            del(ctrs)
    del(data)
input.close()
output.close()

            
            


