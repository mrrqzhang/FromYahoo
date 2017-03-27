import sys

validfeature=['TOKENS_title', 'CHARS_title', 'COSINE_title', 'BM25_title', 'LSI_title']

for line in sys.stdin:
  try:
    q,r,grade,features = line.strip('\r\t\n').split('\t')
    features = [ tuple([x[0],x[1]]) for x in ( item.split('#') for item in features.split(',') )  ]
    fmap = dict((features))
    sys.stdout.write('%s\t%s\t%s\n' % (q,r,' '.join([key+':'+value for key,value in fmap.items() if key in validfeature])) )
  except: pass
