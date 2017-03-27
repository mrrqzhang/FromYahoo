import math


@outputSchema('type:chararray')
def matchTypeConvert(x):
    dict = {"0": "UNDEFINED_MATCH_TYPE", "1": "EXACT_MATCH", "2": "YELLOWSTONE", "3": "QBERT", "4": "PHRASE", "5": "QUAD_SESSION_ADS", "6": "QUAD_REMEMBER_ME", "7": "QUAD_HUBBLE_DIRECT", "8": "QUAD_MARK_ME", "9": "VARIANT_MATCH", "10": "QBERT_HUBBLE", "11": "QBERT_MODS", "12": "QBERT_SPM", "13": "QBERT_PREFERRED", "14": "QBERT_OSCAR", "15": "QBERT_BEVERLY", "16": "QBERT_RANDOMWALK", "17": "QUAD_SUPER_SON", "18": "QBERT_BRANDNAME", "19": "QBERT_GRIFFITH", "20": "QBERT_GEOREWRITE", "21": "QUAD_ANTARES", "22": "QUAD_BIDTERM_EXPANSION", "23": "PHRASE_VARIANT", "24": "GEO_PHRASE_VARIANT", "25": "AMETHYST", "26": "PRODUCT_AD", "27": "QUAD_FREEDOM"}
    try:
       if x in dict:
          x = dict[x]
    except:
       pass
    return x

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
