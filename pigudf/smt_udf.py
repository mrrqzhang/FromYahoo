import math

@outputSchema('score:float')
def cosine(x, y):
  try:
    
    xs = x.split()
    ys = y.split()
    if (len(xs) == 0) or (len(ys) == 0):
      return 0.0
    match = 0
    for i in range(len(xs)):
      for j in range(len(ys)):
        if (xs[i] == ys[j]):
          match += 1
          break
    score = float(match) / math.sqrt(1.0 * len(xs) * len(ys))
    return score
  except:
    return 0.0

@outputSchema('y:bag{t:tuple(partition:int, query:chararray)}')
def replicate_queries(npartitions, q):
  output = []
  for i in range(npartitions):
    output.append((i, q))
  return output
