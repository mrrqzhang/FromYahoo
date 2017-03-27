#! /usr/bin/env python

import sys
import os
import codecs
import math
import sets
from string import *

def get_common_qry( input1, input2 ):
    in1 = codecs.open( input1, 'r', 'utf-8' )
    in2 = codecs.open( input2, 'r', 'utf-8' )
    out1 = codecs.open( input1+'.common', 'w', 'utf-8' )
    out2 = codecs.open( input2+'.common', 'w', 'utf-8' )
    q_table=set()
    for line in in1:
        if not line: break
        line = line.strip()
        if line=="": continue
        items = split(line,'\t')
        if len(items) < 23: continue
        qry=items[1]
        q_table.add( qry )
    in1.close()

    another_q_table=set()
    for line in in2:
        if not line: break
        line = line.strip()
        if line=="": continue
        items = split(line,'\t')
        if len(items) < 23: continue
        qry=items[1]
        if not qry in q_table: continue
        out2.write( line+'\n' )
        another_q_table.add( qry )
                
    in2.close()
    out2.close()
    del( q_table )

    in1 = codecs.open(input1, 'r', 'utf-8')
    for line in in1:
        if not line: break
        line = line.strip()
        if line == "": continue
        items = split( line, '\t' )
        if len(items) < 23: continue
        qry = items[1]
        if not qry in another_q_table: continue
        out1.write( line+'\n' )
    in1.close()
    out1.close()
    del( another_q_table )
    
def main():
    if len(sys.argv) != 3:
        print '''
        Usage: python getCommonQry.py <input1> <input2>
        Input: <input1>, <input2>
        Output: <input1.common> <input2.common>
        '''
        sys.exit()
    get_common_qry(sys.argv[1], sys.argv[2] )

if(__name__ == "__main__"):
   main()
