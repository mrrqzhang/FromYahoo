import sys

prekey = ''
maxscore = sys.float_info.min
first = True

for line in sys.stdin:
  try:
    fields = line.strip('\r\n ').split('\t')
    fields[0]=fields[0].strip()
    fields[1]=fields[1].strip()
    fields[2]=fields[2].strip()
    key = fields[0] + '\t' + fields[1]
    if (key != prekey) and (first != True):
      sys.stdout.write('%s\t%f\n' % (prekey, maxscore))
      prekey = key
      maxscore = float(fields[2])
    else: 
      if first == True:
        prekey = key
        first = False
        maxscore = float(fields[2])
      elif float(fields[2]) > float(maxscore): 
        maxscore = float(fields[2])
  except: pass

sys.stdout.write('%s\t%f\n' % (prekey, maxscore))

