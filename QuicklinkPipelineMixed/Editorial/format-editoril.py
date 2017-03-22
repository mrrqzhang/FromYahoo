import sys

titlemap = {'1':'Excellent', '2':'Good', '3':'Fair', '4':'Bad', '5':'NJ'}
qlmap = {'1':'VL','2':'L','3':'PNL','4':'DNL','5':'NJ'}
for line in sys.stdin:
    fields = line.strip('\r\t\n ').split('\t')
    domain = fields[13]
    ql = fields[17]
    title = fields[14]
    qlscore = 'ql:'+qlmap[fields[9]]
    titlescore = 'title:'+titlemap[fields[7]]
    rank = fields[12]
    source = fields[15]
    qlcomment = fields[10]
    titlecomment = fields[8]
    sys.stdout.write('%s\n' % '\t'.join([source,domain,ql, title,qlscore,titlescore,rank,qlcomment,titlecomment]))

