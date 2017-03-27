#! /usr/bin/env python
# Adapted from Zhaohui's wilconxon.py by Jiang Chen <jiangc@yahoo-inc.com>
import sys
from string import *
#from stats import lwilcoxont

def csviter(IN, lineseek = 0, lineskip = 1, lineskipmod = 0):
    for lineno, line in enumerate(IN):
        if lineno >0 and lineno < lineseek:
            continue
        if lineno >0 and lineno % lineskip != lineskipmod:
            continue
        
        line = line.strip('\n')
        row = line.split('\t')
        yield row

def read_metrics(filename):
    metrics = {}
    IN = open(filename)
    t = csviter(IN)
    head = t.next()
    qList = []
    for c in head:
        if c.lower() != 'query':
            metrics[c] = []

    for lineno, row in enumerate(t):
        if len(row) != len(head):
            break

        for c,v in zip(head,row):
            if c.lower() != 'query':
                try:
                    metrics[c].append(float(v))
                except:
                    metrics[c].append(None)
            else:
                qList.append(v)

    
    return head, qList, metrics

def intersect(qList1, qList2):
    qDict = dict([(q,0) for q in qList1])
    
    for q in qList2:        
        if qDict.get(q) != None:
            qDict[q] = 1

    return qDict
            
    

def main():
    if len(sys.argv) != 3:
	print '''Usage: python wilcoxon.py dcg1 dcg2'''
	sys.exit()
    
    heads1, qList1, metrics1 = read_metrics(sys.argv[1])
    heads2, qList2, metrics2 = read_metrics(sys.argv[2])


    # make the intersection two lists
    qDict = intersect(qList1, qList2)
    qIdx1 = [i for (i,q) in enumerate(qList1) if qDict.get(q) == 1]
    qIdx2 = [i for (i,q) in enumerate(qList2) if qDict.get(q) == 1]

    assert(len(qIdx1) == len(qIdx2))

    
    for c in metrics1:
        metrics1[c] = [metrics1[c][i] for i in qIdx1]
    for c in metrics2:
        metrics2[c] = [metrics2[c][i] for i in qIdx2]

    print "%d common queries"%len(qIdx1)
    for c in heads1:
        if c not in metrics1:
            continue
        
        if c not in metrics2:
            print >>sys.stderr, "%s not in %s" % (c, sys.argv[2])
            continue        
        try:
            assert(len(metrics1[c]) == len(metrics2[c]))
        except:
            print >> sys.stderr, "\n[ERROR] column %s has mismatched lengths (%d,%d)" % (c, len(metrics1[c]),len(metrics2[c]))
            continue

        lMetricIdx = [i for i in range(len(metrics1[c])) if metrics1[c][i] != None and metrics2[c][i] != None]
        metrics1[c] = [metrics1[c][i] for i in lMetricIdx]
        metrics2[c] = [metrics2[c][i] for i in lMetricIdx]
        
        if len(metrics1[c]) == 0:
            print '\n%s is empty' % c
            continue
        
        aver_1 = sum(metrics1[c])/len(metrics1[c])
        aver_2 = sum(metrics2[c])/len(metrics1[c])

        print "\n%s: "%c, aver_1, aver_2, "   (+%)", (aver_1-aver_2)*100/aver_1
        print "p value: ", lwilcoxont(metrics1[c],metrics2[c])[1]
        
    return


if(__name__ == "__main__"):
    #	xp = [78.0, 24.0, 64.0, 45.0, 64.0, 52.0, 30.0, 50.0, 64.0, 50.0, 78.0, 22.0, 84.0, 40.0, 90.0, 72.0]
#	yp = [78.0, 24.0, 62.0, 48.0, 68.0, 56.0, 25.0, 44.0, 56.0, 40.0, 68.0, 36.0, 68.0, 20.0, 58.0, 32.0]

	
#	print lwilcoxont(xp,yp)
	main()
