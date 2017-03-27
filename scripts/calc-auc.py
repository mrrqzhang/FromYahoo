import sys
import numpy as np
from sklearn.metrics import roc_auc_score
y_true = []
y_score = []
for line in sys.stdin:
  try:
    a,b = line.strip('\r\t\n').split('\t')
#    print a,b
    y_true.append(int(b))
    y_score.append(float(a))
#    print y_true
  except: pass
#print np.array(y_true)
print roc_auc_score(np.array(y_true), np.array(y_score))
