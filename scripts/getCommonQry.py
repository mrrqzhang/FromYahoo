#! /usr/bin/env python

import sys
import os
import codecs
import math
from string import *

def get_common_qry( input1, input2, output, flag ):
    in1 = codecs.open( input1, 'r', 'utf-8' )
    in2 = codecs.open( input2, 'r', 'utf-8' )
    out = codecs.open( output, 'w', 'utf-8' )
    qv_table={}
    for line in in1:
        if not line: break
        line = line.strip()
        if line=="": continue
        items = split(line,'\t')
        qry=items[0]
        if not qv_table.has_key( qry ): qv_table[ qry ]= float(items[11])/float(items[12])
    in1.close()

    r =[]
    for line in in2:
        if not line: break
        line = line.strip()
        if line=="": continue
        items = split(line,'\t')
        qry=items[0]
	freq=float(items[12]);
        if not qv_table.has_key( qry ): continue
        v1 = float( qv_table[qry]); v2 = float( items[11] )/float(items[12]);
        if flag==0: v=v1-v2
        else: v=v2-v1
        r.append([v, qry, v1, v2, freq])

    r = sorted(r)
    for items in r:
        out.write('%s\t%f\t%f\t%f\t%d\n' % (items[1],items[2],items[3],items[0],items[4]) )
    in2.close()
    out.close()
    del( qv_table )
        
def main():
    if len(sys.argv) != 5:
        print '''
        Usage: python getCommonQry.py <input1> <input2> <output> <flag>
        Input: <input1>, <input2>, <flag>
        Output: <output>
        if flag==0 then, common queries are sorded in ascending order of the differences of field 2 elements.
        '''
        sys.exit()
    flag = int(sys.argv[4])
    get_common_qry(sys.argv[1], sys.argv[2], sys.argv[3], flag )

if(__name__ == "__main__"):
   main()
