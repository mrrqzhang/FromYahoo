import sys

title={}
count={}
for line in sys.stdin:
   fields = line.strip().split("\t")
   fields2 = fields[0].split(' ')
   url = fields2[1]
   if not count.has_key(url):
      count[url]={}
      title[url]={}
   if fields2[0] > count[fields2[1]]:
       count[url] = fields2[0]       
       title[url] = fields[1]
       
for key in title:
   sys.stdout.write("%s\t%s\n" % (key, title[key]))
