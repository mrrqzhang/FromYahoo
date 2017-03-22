import sys,os

def print_lcw(qry,dict,sum_weight):
        tmp = []
        for key in dict.keys():
                tmp.append(key+':'+str(dict[key]/float(sum_weight)))
        print qry+'\t'+'|'.join(tmp)

prev = '___###___'
dict = {}
sum_weight = 0
while True:
        line = sys.stdin.readline()
        if not line: break
        [qry,weight,lcw] = line[:-1].split('\t')
	if weight=='': weight='0'
        if qry!=prev and prev!='___###___':
                print_lcw(prev,dict,sum_weight)
                dict = {}
                sum_weight = 0
        split = lcw.split('|')
        for item in split:
                split_ = item.split(':')
                cat = ':'.join(split_[:-1])
                cat_w = float(split_[-1])
                if dict.has_key(cat):
                        dict[cat] = dict[cat]+float(weight)*cat_w
                else:
                        dict[cat] = float(weight)*cat_w
        sum_weight = sum_weight+float(weight)
        prev = qry

print_lcw(prev,dict,sum_weight)
